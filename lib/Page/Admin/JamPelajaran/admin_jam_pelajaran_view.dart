import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/JamPelajaran/admin_jam_pelajaran_form_view.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_jam_pelajaran_form_edit_view.dart';

class AdminJamPelajaran extends StatefulWidget {
  const AdminJamPelajaran({super.key});

  @override
  State<AdminJamPelajaran> createState() => _AdminJamPelajaranState();
}

class _AdminJamPelajaranState extends State<AdminJamPelajaran> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> jamPelajaranData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await JamPelajaranDataUtil.fetchData();
    setState(() {
      jamPelajaranData = data['Data'];
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
    SystemNavigator.pop();
  }

  Future<void> confirmLogout() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Log Out'),
          content: const Text('Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Batalkan log out
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Konfirmasi log out
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      _logout(); // Lakukan log out jika dikonfirmasi
    }
  }

  void _filterJamPelajaranData(String searchText) async {
    // Kirim permintaan pencarian ke API dan perbarui filteredPelajaranData
    final searchData = await JamPelajaranSearch.searchData(searchText);
    setState(() {
      jamPelajaranData = searchData['Data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 52, 95, 168),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Jam Pelajaran",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 16,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: GestureDetector(
              onTap: () {
                Get.to(AdminJamPelajaranFormView(
                  updateCallback: loadData,
                ));
              },
              child: const Icon(
                Icons.add_circle,
                color: Color(0xffffffff),
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 15, 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: searchController,
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffd2d2d2), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffd2d2d2), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                  color: Color(0xffd2d2d2), width: 1),
                            ),
                            hintText: "Pencarian...",
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xffafaeae),
                            ),
                            filled: true,
                            fillColor: const Color(0x00f2f2f3),
                            isDense: false,
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 8, 12, 8),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              loadData();
                            }
                            // _filterPeriodeData(value);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          String value = searchController.text;
                          _filterJamPelajaranData(value);
                        },
                        color: const Color(0xffcdcdcd),
                        iconSize: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              itemCount: jamPelajaranData.length,
              itemBuilder: (context, index) {
                final jampelajaran = jamPelajaranData[index];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 59, 138, 195),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminJamPelajaranFormEdit(
                                updateCallback: loadData,
                                jamPelajaranData: jampelajaran,
                                jampelId: jampelajaran['id'],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                '${jampelajaran['jam_ke']}',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xfffee3cf),
                                ),
                              ),
                            ),
                            Text(
                              '${jampelajaran['pukul']}',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xffffe8d3),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminJamPelajaranFormEdit(
                                      updateCallback: loadData,
                                      jamPelajaranData: jampelajaran,
                                      jampelId: jampelajaran['id'],
                                    ),
                                  ),
                                );
                              },
                              color: const Color(0xfffff0e3),
                              iconSize: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class JamPelajaranDataUtil {
  static Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jampel-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData;
    } else {
      print('Gagal mengambil data jam pelajaran');
      return {};
    }
  }
}

class JamPelajaranSearch {
  static Future<Map<String, dynamic>> searchData(String? searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    String urlStr =
        'https://jurnalmengajar-1-r8590722.deta.app/jampel-cari?tenant_id=$tenant&fields=&sort_order=ascending&page=1&limit=10';

    if (searchText != null && searchText.isNotEmpty) {
      urlStr += '&search=${Uri.encodeQueryComponent(searchText)}';
    }
    final url = Uri.parse(urlStr);

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData;
    } else {
      print('Failed to fetch jam pelajaran data:');
      return {'Data': []};
    }
  }
}

// class JamPelajaranSearch {
//   static Future<List<dynamic>> searchData(String? searchText) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? tokenJwt = prefs.getString('tokenJwt');
//     final token = 'Bearer $tokenJwt';
//     String? tenant;

//     String urlStr =
//         'https://jurnalmengajar-1-r8590722.deta.app/pelajaran-cari?tenant_id=$tenant&fields=&sort_order=ascending&page=1&limit=10';
//     if (searchText != null && searchText.isNotEmpty) {
//       urlStr += '?search=$searchText';
//     }
//     final url = Uri.parse(urlStr);

//     final headers = {
//       'accept': 'application/json',
//       'Authorization': token,
//     };

//     final response = await http.post(url, headers: headers);

//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);

//       return responseData;
//     } else {
//       print('Gagal mengambil data jam pelajaran');
//       return [];
//     }
//   }
// }

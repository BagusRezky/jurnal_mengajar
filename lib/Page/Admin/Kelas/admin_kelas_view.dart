import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/Kelas/admin_kelas_form_view.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_kelas_form_edit_view.dart';

class AdminKelas extends StatefulWidget {
  const AdminKelas({super.key});

  @override
  State<AdminKelas> createState() => _AdminKelasState();
}

class _AdminKelasState extends State<AdminKelas> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> kelasData = []; // List untuk menyimpan data kelas
  // List<dynamic> filteredKelasData = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var data = await KelasDataUtil.fetchData();
    setState(() {
      kelasData = data['Data'];
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

  void _filterKelasData(String searchText) async {
    // Kirim permintaan pencarian ke API dan perbarui filteredKelasData
    final searchData = await KelasSearch.searchData(searchText);
    setState(() {
      kelasData = searchData['Data'];
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
          "Kelas",
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
                  Get.to(AdminKelasForm(
                    updateCallback: loadData,
                  ));
                },
                child: const Icon(Icons.add_circle,
                    color: Color(0xffffffff), size: 24),
              )),
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
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          String value = searchController.text;
                          _filterKelasData(value);
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
              itemCount: kelasData.length,
              itemBuilder: (context, index) {
                final kelas = kelasData[index];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      height: 50,
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
                              builder: (context) => AdminKelasFormEdit(
                                updateCallback: loadData,
                                kelasData: kelas,
                                kelasId: kelas['id'],
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
                              padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    '${kelas['nama']}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xfffff0e3),
                                    ),
                                  ),
                                  Text(
                                    '${kelas['periode']}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xfffff0e3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${kelas['siswa']}',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xfffff0e3),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminKelasFormEdit(
                                      updateCallback: loadData,
                                      kelasData: kelas,
                                      kelasId: kelas['id'],
                                    ),
                                  ),
                                );
                              },
                              color: const Color(0xfffff0e3),
                              iconSize: 20,
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

class KelasDataUtil {
  static Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];

    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/kelas-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData;
    } else {
      print('Gagal mengambil data kelas');
      return {};
    }
  }
}

class KelasSearch {
  static Future<Map<String, dynamic>> searchData(String? searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    tenant = decodedToken['tenant_id'];

    String urlStr =
        'https://jurnalmengajar-1-r8590722.deta.app/kelas-cari?tenant_id=$tenant&fields=nama%2Cperiode%2Csiswa&sort_order=ascending&page=1&limit=10';
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

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/Periode/admin_periode_form_edit_view.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_periode_form_view.dart';

class AdminPeriode extends StatefulWidget {
  const AdminPeriode({super.key});

  @override
  State<AdminPeriode> createState() => AdminPeriodeState();
}

class AdminPeriodeState extends State<AdminPeriode> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> periodeData = []; // List untuk menyimpan data periode
  List<dynamic> filteredPeriodeData = [];

  @override
  void initState() {
    super.initState();
    showToken();
    loadData();
  }

  void showToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('tokenJwt');
    print('$token');
  }

  Future<void> loadData() async {
    var data = await PeriodeDataUtil.fetchData();
    setState(() {
      periodeData = data['Data'];
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
    SystemNavigator.pop();
  }

  // void _filterPeriodeData(String searchText) async {
  //   // Kirim permintaan pencarian ke API dan perbarui filteredPeriodeData
  //   final searchData = await PeriodeSearch.searchData(searchText);
  //   if (searchData != null) {
  //     setState(() {
  //       periodeData = searchData;
  //     });
  //   }
  // }

  // void _filterPeriodeData(String searchText) async {
  //   // Kirim permintaan pencarian ke API dan perbarui filteredPeriodeData
  //   final searchData = await PeriodeSearch.searchData(searchText);
  //   if (searchData is Map<String, dynamic>) {
  //     final dataList = searchData['Data'] as List<dynamic>;
  //     setState(() {
  //       periodeData = dataList;
  //     });
  //   } else if (searchData is FutureOr<List<dynamic>>) {
  //     final data = searchData;
  //     setState(() {
  //       periodeData = data['Data'];
  //     });
  //   }
  // }

  void _filterPeriodeData(String searchText) async {
    final filteredData = await PeriodeSearch.searchData(searchText);

    setState(() {
      periodeData = filteredData['Data'];
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
          "Periode",
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
                  Get.to(PeriodeForm(
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
                          _filterPeriodeData(value);
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
              itemCount: periodeData.length,
              itemBuilder: (context, index) {
                final periode = periodeData[index];
                final bool isAktif = periode['is_aktif'];
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: periode['is_aktif']
                            ? const Color.fromARGB(255, 59, 138, 195)
                            : const Color.fromARGB(255, 198, 207, 222),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPeriodeFormEditView(
                                updateCallback: loadData,
                                periodeData: periode,
                                periodeId: periode['id'],
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
                                '${periode['nama']}',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: isAktif
                                      ? Colors.white
                                      : const Color.fromARGB(255, 59, 138, 195),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminPeriodeFormEditView(
                                      updateCallback: loadData,
                                      periodeData: periode,
                                      periodeId: periode['id'],
                                    ),
                                  ),
                                );
                              },
                              color: isAktif
                                  ? Colors.white
                                  : const Color.fromARGB(255, 59, 138, 195),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                    )
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

class PeriodeDataUtil {
  static Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/periode-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData;
    } else {
      print('Gagal mengambil data periode');
      return {};
    }
  }
}

class PeriodeSearch {
  static Future<Map<String, dynamic>> searchData(String? searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    String urlStr =
        'https://jurnalmengajar-1-r8590722.deta.app/periode-cari?tenant_id=$tenant&fields=&sort_order=ascending&page=1&limit=10';
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

      if (responseData['IsError'] == false) {
        return responseData;
      } else {
        print('Data tidak ditemukan');
        return {'Data': []};
      }
    } else {
      print('Gagal mengambil data periode: ${response.statusCode}');
      print('Response Body: ${response.body}');
      return {'Data': []};
    }
  }
}

// class PeriodeSearch {
//   static Future<List<dynamic>?> searchData(String? searchText) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? tokenJwt = prefs.getString('tokenJwt');
//     final token = 'Bearer $tokenJwt';
//     String? sekolah;
//     Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

//     sekolah = decodedToken['nama'];
//     String urlStr =
//         'https://jurnalmengajar-1-r8590722.deta.app/periode-cari?nama=$sekolah&page=1&limit=10';
//     // 'https://jurnalmengajar-1-r8590722.deta.app/periode-cari?tenant_id=651a3ea147a3d131b32ff353&sort_order=ascending&page=1&limit=10';

//     if (searchText != null && searchText.isNotEmpty) {
//       urlStr += '&search=$searchText';
//     }
//     final url = Uri.parse(urlStr);

//     final headers = {
//       'accept': 'application/json',
//       'Authorization': token,
//     };

//     final response = await http.post(url, headers: headers);

//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       if (searchText != null && searchText.toLowerCase() == 'aktif') {
//         return responseData.where((periode) => periode['is_aktif']).toList();
//       } else if (searchText != null &&
//           searchText.toLowerCase() == 'tidak aktif') {
//         return responseData.where((periode) => !periode['is_aktif']).toList();
//       }
//       return responseData;
//     } else {
//       print('Gagal mengambil data periode');
//       return null;
//     }
//   }
// }

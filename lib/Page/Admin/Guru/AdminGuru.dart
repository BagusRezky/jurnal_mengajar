import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/Guru/AdminGuruDetail.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminGuru extends StatefulWidget {
  const AdminGuru({super.key});

  @override
  State<AdminGuru> createState() => _AdminGuruState();
}

class _AdminGuruState extends State<AdminGuru> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> guruData = []; // List untuk menyimpan data guru
  List<dynamic> filteredguruData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var data = await GuruDataUtil.fetchData();
    setState(() {
      guruData = data['Data'];
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
    SystemNavigator.pop();
  }

  void _filterguruData(String searchText) async {
    // Kirim permintaan pencarian ke API dan perbarui filteredguruData
    final searchData = await GuruSearch.searchData(searchText);
    setState(() {
      filteredguruData = searchData;
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
          backgroundColor: const Color(0xff345ea8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: const Text(
            "Guru",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 20,
              color: Color(0xfcffffff),
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
                              _filterguruData(value);
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
                itemCount: guruData.length,
                itemBuilder: (context, index) {
                  final guru = guruData[index];
                  final String base64Image = guru['foto'] ??
                      ''; // Ganti 'foto' dengan nama field base64 gambar
                  Uint8List? imageBytes;

                  if (base64Image.isNotEmpty) {
                    imageBytes = base64Decode(base64Image.split(',').last);
                    print('Berhasil');
                  } else {
                    print('Gagal');
                  }
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 15);
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(5),
                        width: double.infinity,
                        height: 67,
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
                                builder: (context) => AdminGuruDetail(
                                  updateCallback: loadData,
                                  guruData: guru,
                                  guruId: guru['id'],
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
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: imageBytes != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.memory(
                                            imageBytes,
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/images/guru1.png',
                                          width: 40,
                                          height: 40,
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        '${guru['nama']}',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          color: Color(0xffeedbcb),
                                        ),
                                      ),
                                      Text(
                                        '${guru['jabatan']}',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14,
                                          color: Color(0xffeedbcb),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xffeedbcb),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ))
            ]));
  }
}

class GuruDataUtil {
  static Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/guru-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10'); // URL POST yang sesuai dengan kebutuhan

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData;
    } else {
      print('Gagal mengambil data guru');
      return {};
    }
  }
}

class JadwalGuruDataUtil {
  static Future<List<dynamic>?> fetchData(DateTime selectedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    String? tenantId;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenantId = decodedToken['tenant_id'];
    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };
    final selectedDateFormatted =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jadwal-cari/guru?tanggal=$selectedDateFormatted&tenant_id=$tenantId&sort_order=ascending&page=1&limit=10');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['Data']; // Ganti dengan nama yang sesuai di API
    } else {
      print('Gagal mengambil data jadwal');
      return null;
    }
  }
}

class GuruSearch {
  static Future<List<dynamic>> searchData(String? searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenantId;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenantId = decodedToken['tenant_id'];
    String urlStr =
        'https://jurnalmengajar-1-r8590722.deta.app/guru-cari?tenant_id=$tenantId&sort_order=ascending';
    if (searchText != null && searchText.isNotEmpty) {
      urlStr += '?search=$searchText';
    }
    final url = Uri.parse(urlStr);

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (searchText != null && searchText.toLowerCase() == 'aktif') {
        return responseData.where((guru) => guru['is_aktif']).toList();
      } else if (searchText != null &&
          searchText.toLowerCase() == 'tidak aktif') {
        return responseData.where((guru) => !guru['is_aktif']).toList();
      }
      return responseData;
    } else {
      print('Gagal mengambil data guru');
      return [];
    }
  }
}

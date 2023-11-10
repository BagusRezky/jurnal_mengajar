import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jurnal_mengajar/Page/Guru/GuruJurnal/GuruJurnalDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/Calendar/calendar.dart';

class GuruJurnal extends StatefulWidget {
  const GuruJurnal({super.key});

  @override
  State<GuruJurnal> createState() => _GuruJurnalState();
}

class _GuruJurnalState extends State<GuruJurnal> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> jurnalData = []; // List untuk menyimpan data periode
  List<dynamic> filteredJurnalData = [];

  @override
  void initState() {
    super.initState();
    showToken();
    loadData();
  }

  void showToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('tokenJwt');
    print('${token}');
  }

  Future<void> loadData() async {
    var data = await JurnalDataUtil.fetchData();
    if (data != null) {
      setState(() {
        jurnalData = data;
        filteredJurnalData = data;
      });
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
    SystemNavigator.pop();
  }

  void _filterPeriodeData(String searchText) async {
    // Kirim permintaan pencarian ke API dan perbarui filteredPeriodeData
    final searchData = await JurnalSearch.searchData(searchText);
    if (searchData != null) {
      setState(() {
        filteredJurnalData = searchData;
      });
    }
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
          "Jurnal Mengajar",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 20,
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Calendar(),
          Expanded(
            flex: 1,
            child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                itemCount: filteredJurnalData.length,
                itemBuilder: (context, index) {
                  final jurnal = filteredJurnalData[index];
                  final bool isAktif = jurnal['is_aktif'];
                  return Column(children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(const GuruJurnalDetail());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xffc6cfde),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                              color: const Color(0x4d9e9e9e), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                      child: Text(
                                        '${jurnal['Kelas']}',
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16,
                                          color: Color(0xff3b8ac3),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          '${jurnal['Pelajaran']}',
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xff3b8ac3),
                                          ),
                                        ),
                                        const Text(
                                          "S:1  I:0  A:1",
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xff3b8ac3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                              child: Icon(
                                Icons.verified,
                                color: Color(0xff54b175),
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]);
                }),
          ),
        ],
      ),
    );
  }
}

class JurnalDataUtil {
  static Future<List<dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';

    final url =
        Uri.parse('https://jurnalmengajar-1-r8590722.deta.app/jurnal/admin');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData;
    } else {
      print('Gagal mengambil data periode');
      return [];
    }
  }
}

class JurnalSearch {
  static Future<List<dynamic>> searchData(String? searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';

    String urlStr = 'https://jurnalmengajar-1-r8590722.deta.app/jurnal/admin';
    if (searchText != null && searchText.isNotEmpty) {
      urlStr += '?search=$searchText';
    }
    final url = Uri.parse(urlStr);

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (searchText != null && searchText.toLowerCase() == 'aktif') {
        return responseData.where((periode) => periode['is_aktif']).toList();
      } else if (searchText != null &&
          searchText.toLowerCase() == 'tidak aktif') {
        return responseData.where((periode) => !periode['is_aktif']).toList();
      }
      return responseData;
    } else {
      print('Gagal mengambil data periode');
      return [];
    }
  }
}

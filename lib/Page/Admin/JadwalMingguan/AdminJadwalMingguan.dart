///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/JadwalMingguan/AdminJawalMingguanForm.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../color/color.dart';
import '../../../widgets/dialog_adminjadwalmingguan.dart';
import 'admin_jadwal_mingguan_form_edit.dart';

class AdminJadwalMingguan extends StatefulWidget {
  const AdminJadwalMingguan({super.key});

  @override
  State<AdminJadwalMingguan> createState() => _AdminJadwalMingguanState();
}

class _AdminJadwalMingguanState extends State<AdminJadwalMingguan> {
  List<dynamic> jadwalMingguanData = [];
  bool isExpanded = true;
  bool isAktif = false;
  List<dynamic> itemsPeriode = []; // periode
  String? selectedValuePeriode; // pe

  List<dynamic> itemsKelas = [];
  String? selectedValueKelas;

  List<dynamic> itemsGuru = [];
  String? selectedValueGuru;

  String? tokenJwt = "";

  @override
  void initState() {
    super.initState();
    showToken();
    loadData();
    fetchDataPeriodeFromApi();
    fetchDataKelasFromApi();
    fetchDataGuruFromApi();
  }

  void showToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('tokenJwt');
    print('$token');
  }

  Future<void> loadData() async {
    var data = await JadwalMingguanDataUtil.fetchData();
    setState(() {
      jadwalMingguanData = data['Data'];
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
    SystemNavigator.pop();
  }

  Future<void> fetchDataPeriodeFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/periode-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsPeriode = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataKelasFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/kelas-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsKelas = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataGuruFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/guru-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsGuru = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
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
        backgroundColor: MainColor.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Jadwal Mingguan",
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
            size: 26,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.dialog(DialogAdminJadwalMingguan(
                updateCallback: loadData,
              ));
            },
            child: const Icon(
              Icons.add_box,
              color: Color(0xffffffff),
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: GestureDetector(
                onTap: () {
                  Get.to(AdminJadwalMingguanForm(
                    updateCallback: loadData,
                  ));
                },
                child: const Icon(
                  Icons.add_circle,
                  color: Color(0xffffffff),
                  size: 30,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Filter :",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: const Color(0xff212435),
                              size: 24,
                            ),
                            // Icon(
                            //   Icons.expand_less,
                            //   color: Color(0xff212435),
                            //   size: 24,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isExpanded,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                      padding: const EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Color(0x00000000),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              "Periode",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xffe0e0e0),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(
                                    "Pilih Periode",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  value: selectedValuePeriode,
                                  items: itemsPeriode.map((item) {
                                    return DropdownMenuItem(
                                      value: item['nama'],
                                      child: Text(item['nama']),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValuePeriode = value as String?;
                                    });
                                  },
                                  elevation: 8,
                                  isExpanded: true,
                                ),
                              )),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              "Kelas",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xffdedede),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(
                                    "Pilih Kelas",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  value: selectedValueKelas,
                                  items: itemsKelas.map((item) {
                                    return DropdownMenuItem(
                                      value: item['nama'],
                                      child: Text(item['nama']),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValueKelas = value as String?;
                                    });
                                  },
                                  elevation: 8,
                                  isExpanded: true,
                                ),
                              )),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              "Hari",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xffdedede),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  value: "Pilih Hari",
                                  items: ["Pilih Hari"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  onChanged: (value) {},
                                  elevation: 8,
                                  isExpanded: true,
                                ),
                              )),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Text(
                              "Guru",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 16,
                                color: Color(0xff000000),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xffdddddd),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(
                                    "Pilih Guru",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                  value: selectedValueGuru,
                                  items: itemsGuru.map((item) {
                                    return DropdownMenuItem(
                                      value: item['nama'],
                                      child: Text(item['nama']),
                                    );
                                  }).toList(),
                                  style: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValueGuru = value as String?;
                                    });
                                  },
                                  elevation: 8,
                                  isExpanded: true,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: MaterialButton(
                      onPressed: () {},
                      color: const Color.fromARGB(255, 52, 95, 168),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xffffffff),
                      height: 50,
                      minWidth: double.infinity,
                      child: const Text(
                        "Tampilkan Data",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // isi
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
            //   child: SizedBox(
            //     width: double.infinity,
            //     height: 355,
            //     child: Expanded(
            //       child: ListView(
            //         scrollDirection: Axis.vertical,
            //         padding: const EdgeInsets.all(0),
            //         shrinkWrap: true,
            //         physics: const ScrollPhysics(),
            //         children: [
            //           Container(
            //             margin: const EdgeInsets.all(0),
            //             padding: const EdgeInsets.all(0),
            //             width: MediaQuery.of(context).size.width,
            //             height: 85,
            //             decoration: BoxDecoration(
            //               color: const Color.fromARGB(255, 59, 138, 195),
            //               shape: BoxShape.rectangle,
            //               borderRadius: BorderRadius.circular(10.0),
            //               border: Border.all(
            //                   color: const Color(0x4d9e9e9e), width: 1),
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               mainAxisSize: MainAxisSize.max,
            //               children: [
            //                 Padding(
            //                   padding: const EdgeInsets.fromLTRB(12, 0, 0, 17),
            //                   child: Container(
            //                     height: 40,
            //                     width: 40,
            //                     clipBehavior: Clip.antiAlias,
            //                     decoration: const BoxDecoration(
            //                       shape: BoxShape.circle,
            //                     ),
            //                     child: Image.asset("assets/images/guru2.jpg",
            //                         fit: BoxFit.cover),
            //                   ),
            //                 ),
            //                 const Flexible(
            //                   child: Padding(
            //                     padding: EdgeInsets.fromLTRB(14, 6, 0, 0),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.start,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       mainAxisSize: MainAxisSize.max,
            //                       children: [
            //                         Padding(
            //                           padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
            //                           child: Text(
            //                             "Yunida Maudy",
            //                             textAlign: TextAlign.start,
            //                             overflow: TextOverflow.clip,
            //                             style: TextStyle(
            //                               fontWeight: FontWeight.w500,
            //                               fontStyle: FontStyle.normal,
            //                               fontSize: 18,
            //                               color: Color(0xffffffff),
            //                             ),
            //                           ),
            //                         ),
            //                         Padding(
            //                           padding: EdgeInsets.fromLTRB(0, 0, 14, 7),
            //                           child: Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.center,
            //                             mainAxisSize: MainAxisSize.max,
            //                             children: [
            //                               Text(
            //                                 "Rabu",
            //                                 textAlign: TextAlign.start,
            //                                 overflow: TextOverflow.clip,
            //                                 style: TextStyle(
            //                                   fontWeight: FontWeight.w400,
            //                                   fontStyle: FontStyle.normal,
            //                                   fontSize: 16,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                               Padding(
            //                                 padding: EdgeInsets.fromLTRB(
            //                                     110, 0, 0, 0),
            //                                 child: Text(
            //                                   "XI MM 1",
            //                                   textAlign: TextAlign.start,
            //                                   overflow: TextOverflow.clip,
            //                                   style: TextStyle(
            //                                     fontWeight: FontWeight.w400,
            //                                     fontStyle: FontStyle.normal,
            //                                     fontSize: 16,
            //                                     color: Colors.white,
            //                                   ),
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         ),
            //                         Padding(
            //                           padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
            //                           child: Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.center,
            //                             mainAxisSize: MainAxisSize.max,
            //                             children: [
            //                               Expanded(
            //                                 child: Text(
            //                                   "2023/2024 Genap",
            //                                   textAlign: TextAlign.start,
            //                                   overflow: TextOverflow.clip,
            //                                   style: TextStyle(
            //                                     fontWeight: FontWeight.w400,
            //                                     fontStyle: FontStyle.normal,
            //                                     fontSize: 14,
            //                                     color: Colors.white,
            //                                   ),
            //                                 ),
            //                               ),
            //                               Padding(
            //                                 padding: EdgeInsets.fromLTRB(
            //                                     38, 0, 0, 0),
            //                                 child: Text(
            //                                   "Animasi 2D",
            //                                   textAlign: TextAlign.start,
            //                                   overflow: TextOverflow.clip,
            //                                   style: TextStyle(
            //                                     fontWeight: FontWeight.w400,
            //                                     fontStyle: FontStyle.normal,
            //                                     fontSize: 14,
            //                                     color: Colors.white,
            //                                   ),
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Form(
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                      child: ListView.builder(
                        itemCount: jadwalMingguanData.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final jadwalmingguan = jadwalMingguanData[index];
                          // var isCreateJurnal = Jurnal['Approved']; //bool
                          final String base64Image = jadwalmingguan['foto'] ??
                              ''; // Ganti 'foto' dengan nama field base64 gambar
                          Uint8List? imageBytes;

                          if (base64Image.isNotEmpty) {
                            imageBytes =
                                base64Decode(base64Image.split(',').last);
                            print('Berhasil');
                          } else {
                            print('Gagal');
                          }
                          return Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            height: 78,
                            // decoration: BoxDecoration(
                            //   color: isCreateJurnal
                            //       ? MainColor.validateColor
                            //       : MainColor.secondaryColor,
                            //   shape: BoxShape.rectangle,
                            //   borderRadius: BorderRadius.circular(10.0),
                            // ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminJadwalMingguanFormEdit(
                                      updateCallback: loadData,
                                      jadwalMingguanData: jadwalmingguan,
                                      jadwalMingguanId: jadwalmingguan['_id'],
                                      // updateCallback: () {},
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 13, 0, 18),
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
                                              'assets/images/guru2.jpg',
                                              width: 40,
                                              height: 40,
                                            ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 14, 12, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 3),
                                                child: Text(
                                                  "${jadwalmingguan['guru']}",
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16,
                                                    color: isAktif
                                                        ? Colors.white
                                                        : const Color.fromARGB(
                                                            255, 59, 138, 195),
                                                  ),
                                                ),
                                              ),
                                              // isCreateJurnal
                                              //     ? Icon(
                                              //         Icons.verified,
                                              //         color: MainColor
                                              //             .sudahValidasiCheckColor,
                                              //         size: 22,
                                              //       )
                                              //     : Icon(
                                              //         Icons.verified,
                                              //         color: MainColor
                                              //             .alternateColor,
                                              //         size: 22,
                                              //       ),
                                            ],
                                          ),
                                          Text(
                                            "${jadwalmingguan['hari']}",
                                            textAlign: TextAlign.start,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14,
                                              color: isAktif
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 59, 138, 195),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    "${jadwalmingguan['periode']}",
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12,
                                                      color: isAktif
                                                          ? Colors.white
                                                          : const Color
                                                              .fromARGB(255, 59,
                                                              138, 195),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${jadwalmingguan['pelajaran']}",
                                                    textAlign: TextAlign.start,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12,
                                                      color: isAktif
                                                          ? Colors.white
                                                          : const Color
                                                              .fromARGB(255, 59,
                                                              138, 195),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // const Padding(
                                  //   padding:
                                  //       EdgeInsets.fromLTRB(5, 0, 10, 0),
                                  //   child: Icon(
                                  //     Icons.arrow_forward_ios,
                                  //     color: Color.fromARGB(
                                  //         255, 241, 241, 241),
                                  //     size: 22,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//https://jurnalmengajar-1-r8590722.deta.app/jadwalmingguan-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10

class JadwalMingguanDataUtil {
  // static Future<Map<String,dynamic>> fetchData(DateTime selectedDate) async
  static Future<Map<String, dynamic>> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    String? tenant;
    // String? periode;
    // String? kelas;
    // String? hari;
    // String? guru;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    // periode = decodedToken['periode'];
    // kelas = decodedToken['kelas'];
    // hari = decodedToken['hari'];
    // guru = decodedToken['guru'];
    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };
    // final selectedDateFormatted =
    //     '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final url = Uri.parse(
        // 'https://jurnalmengajar-1-r8590722.deta.app/jadwalmingguan-cari?periode=$periode&kelas=$kelas&hari=$hari&guru=$guru&tenant_id=$tenant&sort_order=ascending&page=1&limit=10');
        //'https://jurnalmengajar-1-r8590722.deta.app/jadwalmingguan-cari?tenant_id=$tenant&fields=$periode%2C$kelas%2C$hari%2C$guru&sort_order=ascending&page=1&limit=10');
        'https://jurnalmengajar-1-r8590722.deta.app/jadwalmingguan-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return {
        'Data': responseData['Data']
      }; // Wrap the responseData['Data'] in a Map
    } else {
      print('Gagal mengambil data jadwal');
      return {'Data': {}}; // Return an empty Map in case of failure
    }
  }
}

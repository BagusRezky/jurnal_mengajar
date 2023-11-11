import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jurnal_mengajar/color/color.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminJadwalForm extends StatefulWidget {
  final VoidCallback updateCallback;
  const AdminJadwalForm({Key? key, required this.updateCallback})
      : super(key: key);

  @override
  State<AdminJadwalForm> createState() => _AdminJadwalFormState();
}

DateTime dateTime = DateTime.now();

// Format the DateTime using intl package
String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

class _AdminJadwalFormState extends State<AdminJadwalForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _date =
      TextEditingController(text: formattedDate);
  TextEditingController catatanController = TextEditingController();

  //bool isAktif = true;
  bool isAktif = false;
  // periode
  List<dynamic> itemsPeriode = []; // periode
  String? selectedValuePeriode; // pe

  // jam
  List<dynamic> itemsJam = [];
  String? selectedValueJam;

  // kelas
  List<dynamic> itemsKelas = [];
  String? selectedValueKelas;

  // pelajaran
  List<dynamic> itemsPelajaran = [];
  String? selectedValuePelajaran;

  // gURU
  List<dynamic> itemsGuru = [];
  String? selectedValueGuru;

  String? tokenJwt = "";

  @override
  void initState() {
    super.initState();
    fetchDataPeriodeFromApi();
    fetchDataJamFromApi();
    fetchDataKelasFromApi();
    fetchDataGuruFromApi();
    fetchDataPelajaranFromApi();
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

  Future<void> fetchDataJamFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jampel-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsJam = listData['Data'];
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

  Future<void> fetchDataPelajaranFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/pelajaran-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsPelajaran = listData['Data'];
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

  Future<void> createJadwal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';

    final ctt = catatanController.text;
    print('Bearer $tokenJwt');
    final url =
        //Uri.parse('https://jurnalmengajar-1-r8590722.deta.app/jadwal-tambah');
        Uri.parse('https://jurnalmengajar-1-r8590722.deta.app/jadwal-tambah');

    final Map<String, dynamic> body = {
      'catatan': ctt,
      'tanggal': _date.text,
      'periode': selectedValuePeriode,
      'pukul': selectedValueJam,
      'guru': selectedValueGuru,
      'kelas': selectedValueKelas,
      'pelajaran': selectedValuePelajaran,
      'tenant_id': '651a3ea147a3d131b32ff353',
      'is_aktif': '$isAktif'
    };
    print('Request Body: $body');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers, body: body);
    print('Response Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Pembuatan jadwal berhasil');
      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
    } else {
      print('Pembuatan jadwal gagal');
      print('Response Body: ${response.body}');
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
          "Jadwal Mengajar",
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
      body: SafeArea(
        top: true,
        child: Form(
          key: _formKey,
          child: Stack(
            alignment: Alignment.bottomRight,
            // mencoba
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 140),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        decoration: const BoxDecoration(
                          color: Color(0x1fffffff),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: MainColor.primaryBackground,
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
                                          selectedValuePeriode =
                                              value as String?;
                                        });
                                      },
                                      elevation: 8,
                                      isExpanded: true,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        decoration: const BoxDecoration(
                          color: Color(0x00fafafa),
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
                                "Tanggal",
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
                            TextField(
                              controller: _date,
                              obscureText: false,
                              textAlign: TextAlign.start,
                              readOnly: true,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                hintText: formattedDate,
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                filled: true,
                                fillColor: MainColor.primaryBackground,
                                isDense: false,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                suffixIcon: const Icon(Icons.calendar_today,
                                    color: Color(0xff212435), size: 24),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  setState(() {
                                    _date.text = DateFormat('yyyy-MM-dd')
                                        .format(pickedDate);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        padding: const EdgeInsets.all(0),
                        width: double.infinity,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0x00ffffff),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(
                                    "Jam Ke",
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
                                    width: 120,
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: MainColor.primaryBackground,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: const Text(
                                          "Pilih Jam",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        value: selectedValueJam,
                                        items: itemsJam.map((item) {
                                          return DropdownMenuItem(
                                            value: item['jam_ke'].toString(),
                                            child:
                                                Text(item['jam_ke'].toString()),
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
                                            selectedValueJam = value;
                                          });
                                        },
                                        elevation: 8,
                                        isExpanded: true,
                                      ),
                                    )),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                        height: 50,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: MainColor.primaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                                selectedValueKelas =
                                                    value as String?;
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
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: 75,
                        decoration: const BoxDecoration(
                          color: Color(0x00ffffff),
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
                                "Pelajaran",
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
                                  color: MainColor.primaryBackground,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    hint: const Text(
                                      "Pilih Pelajaran",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    value: selectedValuePelajaran,
                                    items: itemsPelajaran.map((item) {
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
                                        selectedValuePelajaran =
                                            value as String?;
                                      });
                                    },
                                    elevation: 8,
                                    isExpanded: true,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: 75,
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
                                  color: MainColor.primaryBackground,
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
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        padding: const EdgeInsets.all(0),
                        width: MediaQuery.of(context).size.width,
                        height: 110,
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 0),
                              child: Text(
                                "Catatan",
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
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: catatanController,
                                obscureText: false,
                                textAlign: TextAlign.start,
                                maxLines: 4,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x00000000), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x00000000), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x00000000), width: 1),
                                  ),
                                  filled: true,
                                  fillColor: MainColor.primaryBackground,
                                  isDense: false,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Checkbox(
                              value: isAktif,
                              onChanged: (bool? value) {
                                setState(() {
                                  isAktif = value ?? false;
                                });
                              },
                              activeColor: const Color(0xff3a57e8),
                              autofocus: false,
                              checkColor: const Color(0xffffffff),
                              hoverColor: const Color(0x42000000),
                              splashRadius: 20,
                            ),
                            const Text(
                              "Aktif",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Container(
                  margin: const EdgeInsets.only(top: 505),
                  padding: const EdgeInsets.fromLTRB(19, 22, 21, 24),
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xff345ea8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: TextButton(
                    // group34456KJR (4:1128)
                    onPressed: () {
                      createJadwal();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff4ab4de),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Center(
                          child: Text(
                            'Simpan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

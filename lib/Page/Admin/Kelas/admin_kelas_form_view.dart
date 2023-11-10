import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminKelasForm extends StatefulWidget {
  final VoidCallback updateCallback;
  const AdminKelasForm({super.key, required this.updateCallback});

  @override
  State<AdminKelasForm> createState() => _AdminKelasFormState();
}

class _AdminKelasFormState extends State<AdminKelasForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // periode
  List<dynamic> itemsPeriode = []; // periode
  String? selectedValuePeriode;

  TextEditingController nameController = TextEditingController();
  TextEditingController siswaController = TextEditingController();

  String? tokenJwt = "";
  @override
  void initState() {
    super.initState();
    fetchDataPeriodeFromApi();
  }

  Future<void> fetchDataPeriodeFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/periode?page=1&limit=5');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsPeriode = listData;
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> createKelas() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final name = nameController.text;
    final siswaa = siswaController.text;

    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/kelas?page=1&limit=5');

    final Map<String, dynamic> body = {
      'nama': name,
      'siswa': siswaa,
      'periode': selectedValuePeriode,
    };

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Pembuatan kelas berhasil');
      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
      // ignore: use_build_context_synchronously
    } else {
      print('Pembuatan kelas gagal');
      // ignore: use_build_context_synchronously
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            fontFamily: 'Poppins',
            fontSize: 18,
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
            alignment: const AlignmentDirectional(0, -1),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: SingleChildScrollView(
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
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Container(
                            width: double.infinity,
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xfff2f2f3),
                              borderRadius: BorderRadius.circular(10),
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
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          "Nama",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: TextFormField(
                          controller: nameController,
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wajib diisi';
                            }
                            return null; // Return null if validation passes
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00b46e6e), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00b46e6e), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00b46e6e), width: 1),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff2f2f3),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(
                          "Jumlah Siswa",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: siswaController,
                        obscureText: false,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wajib diisi';
                          }
                          return null; // Return null if validation passes
                        },
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0x00000000), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0x00000000), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0x00000000), width: 1),
                          ),
                          filled: true,
                          fillColor: const Color(0xfff2f2f3),
                          isDense: false,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 3),
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
                      createKelas();
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminJamPelajaranFormView extends StatefulWidget {
  final VoidCallback updateCallback;
  const AdminJamPelajaranFormView({Key? key, required this.updateCallback})
      : super(key: key);

  @override
  State<AdminJamPelajaranFormView> createState() =>
      _AdminJamPelajaranFormViewState();
}

class _AdminJamPelajaranFormViewState extends State<AdminJamPelajaranFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController jamkeController = TextEditingController();
  TextEditingController pukulController = TextEditingController();
  String? tokenJwt = "";

  bool isAktif = true;

  Future<void> createJamPelajaran() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final String token = 'Bearer $tokenJwt';

    final jamKe = jamkeController.text;
    final pukull = pukulController.text;

    print('Bearer $tokenJwt');
    final url =
        Uri.parse('https://jurnalmengajar-1-r8590722.deta.app/jampel-tambah');

    final Map<String, dynamic> body = {
      'jam_ke': jamKe,
      'pukul': pukull,
      'tenant_id': '651a3ea147a3d131b32ff353',
    };

    print('Request Body: $body');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers, body: body);
    print('Response Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Pembuatan jam pelajaran berhasil');
      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
    } else if (response.statusCode == 400) {
      print('Pembuatan jam $jamKe sudah ada');
      print('Response Body: ${response.body}');
    } else {
      print('Pembuatan jam pelajaran gagal');
      print('Response Body: ${response.body}');
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
          "Jam Pelajaran",
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
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Align(
                      alignment: Alignment(-0.8, 0.0),
                      child: Text(
                        "Jam Ke",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 0),
                      child: TextFormField(
                        controller: jamkeController,
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
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x00000000), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x00000000), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
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
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment(-0.8, 0.0),
                        child: Text(
                          "Pukul",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 3, 25, 0),
                      child: TextFormField(
                        controller: pukulController,
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
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x00000000), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: const BorderSide(
                                color: Color(0x00000000), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
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
                    ),
                  ],
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Container(
                  margin: const EdgeInsets.only(top: 330),
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
                      createJamPelajaran();
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminPelajaranForm extends StatefulWidget {
  final VoidCallback updateCallback;
  const AdminPelajaranForm({super.key, required this.updateCallback});

  @override
  State<AdminPelajaranForm> createState() => _AdminPelajaranFormState();
}

class _AdminPelajaranFormState extends State<AdminPelajaranForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  String? tokenJwt = "";

  bool isAktif = true;
  Future<void> createPelajaran() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final name = nameController.text;
    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/pelajaran?page=1&limit=5');

    final Map<String, dynamic> body = {
      'nama': name,
      'is_aktif': '$isAktif',
    };

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Pembuatan pelajaran berhasil');
      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
      // ignore: use_build_context_synchronously
    } else {
      print('Pembuatan pelajaran gagal');
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
          "Pelajaran",
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
                        "Nama",
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
                              vertical: 5, horizontal: 10),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Checkbox(
                            value: isAktif,
                            onChanged: (bool? value) {
                              setState(() {
                                isAktif = value ?? true;
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
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
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
              Align(
                alignment: const AlignmentDirectional(0, 1),
                child: Container(
                  margin: const EdgeInsets.only(top: 365),
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
                      createPelajaran();
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

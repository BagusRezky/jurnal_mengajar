import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/Pelajaran/admin_pelajaran_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPelajaranFormEdit extends StatefulWidget {
  final Map<String, dynamic> pelajaranData;
  final String pelajaranId;
  final VoidCallback updateCallback;
  const AdminPelajaranFormEdit(
      {super.key,
      required this.pelajaranData,
      required this.pelajaranId,
      required this.updateCallback});

  @override
  State<AdminPelajaranFormEdit> createState() => _AdminPelajaranFormEditState();
}

class _AdminPelajaranFormEditState extends State<AdminPelajaranFormEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool isAktif = false;
  String? tokenJwt = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai TextField dan Checkbox dengan data pelajaran yang diterima
    nameController.text = widget.pelajaranData['nama'];
    isAktif = widget.pelajaranData['is_aktif'];
  }

  Future<void> deletePelajaran(String pelajaranId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');

    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/pelajaran/${widget.pelajaranId}');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Delete pelajaran berhasil');

      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminPelajaran(),
            ));
      });
    } else {
      print('Delete pelajaran gagal');
      print('Response status code: ${response.statusCode}');
    }
  }

  Future<void> updatePelajaran(String pelajaranId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final name = nameController.text;
    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/pelajaran/${widget.pelajaranId}');

    final Map<String, dynamic> body = {
      'nama': name,
      'is_aktif': '$isAktif',
    };

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Update pelajaran berhasil');

      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
    } else {
      print('Update pelajaran gagal');
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
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text('Yakin ingin menghapus data?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Tidak'),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                deletePelajaran(widget.pelajaranId);
                              },
                              child: const Text('Ya'))
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.delete),
              color: const Color(0xffffffff)),
          const SizedBox(
            width: 20,
          ),
        ],
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
                    onPressed: isLoading
                        ? null // Jangan aktifkan tombol saat sedang loading
                        : () {
                            setState(() {
                              isLoading = true;
                            });
                            updatePelajaran(widget.pelajaranId);
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

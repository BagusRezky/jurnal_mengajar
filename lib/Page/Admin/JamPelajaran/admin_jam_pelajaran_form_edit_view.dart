import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/JamPelajaran/admin_jam_pelajaran_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminJamPelajaranFormEdit extends StatefulWidget {
  final Map<String, dynamic> jamPelajaranData;
  final String jampelId;
  final VoidCallback updateCallback;
  const AdminJamPelajaranFormEdit(
      {super.key,
      required this.jamPelajaranData,
      required this.jampelId,
      required this.updateCallback});

  @override
  State<AdminJamPelajaranFormEdit> createState() =>
      _AdminJamPelajaranFormEditState();
}

class _AdminJamPelajaranFormEditState extends State<AdminJamPelajaranFormEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController jamkeController = TextEditingController();
  TextEditingController pukulController = TextEditingController();

  String? tokenJwt = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai TextField dan Checkbox dengan data jam pelajaran yang diterima
    jamkeController.text = widget.jamPelajaranData['jam_ke'].toString();
    pukulController.text = widget.jamPelajaranData['pukul'];
  }

  Future<void> deleteJampel(String jampelId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');

    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jampel/${widget.jampelId}');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Delete jam pelajaran berhasil');

      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminJamPelajaran(),
            ));
      });
    } else {
      print('Delete jam pelajaran gagal');
      print('Response status code: ${response.statusCode}');
    }
  }

  Future<void> updateJampel(String jampelId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final jamKe = jamkeController.text.toString();
    final pukull = pukulController.text;

    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jampel/${widget.jampelId}');

    final Map<String, dynamic> body = {
      'jamke': jamKe,
      'pukul': pukull,
    };

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Update jam pelajaran berhasil');

      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
    } else {
      print('Update jam pelajaran gagal');
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
                              deleteJampel(widget.jampelId);
                            },
                            child: const Text('Ya'))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.delete),
            color: const Color(0xffffffff),
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
                    onPressed: isLoading
                        ? null // Jangan aktifkan tombol saat sedang loading
                        : () {
                            setState(() {
                              isLoading = true;
                            });
                            updateJampel(widget.jampelId);

                            style:
                            TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            );
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

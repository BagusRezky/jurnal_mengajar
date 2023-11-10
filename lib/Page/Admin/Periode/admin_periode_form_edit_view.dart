import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/Periode/admin_periode_view.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPeriodeFormEditView extends StatefulWidget {
  final Map<String, dynamic> periodeData;
  final String periodeId;
  final VoidCallback updateCallback;
  const AdminPeriodeFormEditView(
      {super.key,
      required this.periodeData,
      required this.periodeId,
      required this.updateCallback});

  @override
  _AdminPeriodeFormEditViewState createState() =>
      _AdminPeriodeFormEditViewState();
}

class _AdminPeriodeFormEditViewState extends State<AdminPeriodeFormEditView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  bool isAktif = false;
  String? tokenJwt = "";
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai TextField dan Checkbox dengan data periode yang diterima
    nameController.text = widget.periodeData['nama'];
    isAktif = widget.periodeData['is_aktif'];
  }

  Future<void> deletePeriode(String periodeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/periode-edit?periode_id=${widget.periodeId}&tenant_id=$tenant');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Delete periode berhasil');

      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminPeriode(),
            ));
      });
    } else {
      print('Delete periode gagal');
      print('Response status code: ${response.statusCode}');
    }
  }

  Future<void> updatePeriode(String periodeId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final name = nameController.text;
    final token = 'Bearer $tokenJwt';
    print('Bearer $tokenJwt');
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/periode-edit?periode_id=${widget.periodeId}&tenant_id=$tenant');

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
      print('Update periode berhasil');

      widget.updateCallback();
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
    } else {
      print('Update periode gagal');
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
          "Periode",
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
                                deletePeriode(widget.periodeId);
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
                            updatePeriode(widget.periodeId);
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnal_mengajar/color/color.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GuruProfileEdit extends StatefulWidget {
  // const GuruProfileEdit({super.key});
  final Map<String, dynamic> profileData;
  final String profileId;
  final VoidCallback updateCallback;
  GuruProfileEdit(
      {required this.profileData,
      required this.profileId,
      required this.updateCallback});

  @override
  State<GuruProfileEdit> createState() => _GuruProfileEditState();
}

class _GuruProfileEditState extends State<GuruProfileEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController namapanjangController = TextEditingController();
  TextEditingController namapanggilanController = TextEditingController();
  TextEditingController jabatanController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  bool isAktif = false;
  String? tokenJwt = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi nilai TextField dan Checkbox dengan data periode yang diterima
    // namapanjangController.text = widget.profileData['namapanjang'];
    namapanggilanController.text = widget.profileData['panggilan'];
    jabatanController.text = widget.profileData['jabatan'];
    alamatController.text = widget.profileData['alamat'];
    notelpController.text = widget.profileData['notelp'];
    // emailController.text = widget.profileData['email'];
    // isAktif = widget.periodeData['is_aktif'];
  }

  Future<void> updatePeriode(String periodeId) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    // final namapanjang = namapanjangController.text;
    final panggilan = namapanggilanController.text;
    final jabatan = jabatanController.text;
    final alamat = alamatController.text;
    final notelp = notelpController.text;
    // final email = emailController.text;
    final token = 'Bearer ${tokenJwt}';
    print('Bearer ${tokenJwt}');
    String? tenantId;
    String? guruId;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenantId = decodedToken['tenant_id'];
    guruId = decodedToken['guru_id'];
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/profil/$guruId?tenant_id=$tenantId');

    final Map<String, dynamic> body = {
      // 'namapanjang': namapanjang,
      'panggilan': panggilan,
      'jabatan': jabatan,
      'alamat': alamat,
      'notelp': notelp,
      // 'email': email,
      // 'is_aktif': '${isAktif}',
    };

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Update periode berhasil');

      widget.updateCallback();
      Future.delayed(Duration(seconds: 2), () {
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
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: MainColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 16,
            color: Color(0xffffffff),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: Color(0xffffffff),
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Icon(Icons.save, color: Color(0xffffffff), size: 24),
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          alignment: const AlignmentDirectional(0, -1),
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                    padding: EdgeInsets.all(0),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Color(0xff6c85f9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Container(
                      height: 90,
                      width: 90,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/images/guru2.jpg",
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: MaterialButton(
                      onPressed: () {},
                      color: Color(0xfff0e0dd),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Upload Foto",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      textColor: Color(0xff000000),
                      height: 40,
                      minWidth: 140,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.8, 0.0),
                    child: Text(
                      "Nama Lengkap",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: TextField(
                      // controller: namapanjangController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        hintText: "Hilmi Wulan",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: Color(0xffededed),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Align(
                      alignment: Alignment(-0.8, 0.0),
                      child: Text(
                        "Nama Panggilan",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: TextField(
                      controller: namapanggilanController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00a19696), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00a19696), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00a19696), width: 1),
                        ),
                        // hintText: "Hilmi",
                        // hintStyle: TextStyle(
                        //   fontWeight: FontWeight.w400,
                        //   fontStyle: FontStyle.normal,
                        //   fontSize: 16,
                        //   color: Color(0xff000000),
                        // ),
                        filled: true,
                        fillColor: Color(0xffececec),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Align(
                      alignment: Alignment(-0.8, 0.0),
                      child: Text(
                        "Jabatan",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: TextField(
                      controller: jabatanController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        // hintText: "Guru Bahasa Inggris",
                        // hintStyle: TextStyle(
                        //   fontWeight: FontWeight.w400,
                        //   fontStyle: FontStyle.normal,
                        //   fontSize: 16,
                        //   color: Color(0xff000000),
                        // ),
                        filled: true,
                        fillColor: Color(0xffededed),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Align(
                      alignment: Alignment(-0.8, 0.0),
                      child: Text(
                        "Alamat",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: TextField(
                      controller: alamatController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        // hintText: "Malang",
                        // hintStyle: TextStyle(
                        //   fontWeight: FontWeight.w400,
                        //   fontStyle: FontStyle.normal,
                        //   fontSize: 14,
                        //   color: Color(0xff000000),
                        // ),
                        filled: true,
                        fillColor: Color(0xfff0f0f0),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Align(
                      alignment: Alignment(-0.8, 0.0),
                      child: Text(
                        "No.Telp",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
                    child: TextField(
                      controller: notelpController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        // hintText: "097851935985",
                        // hintStyle: TextStyle(
                        //   fontWeight: FontWeight.w400,
                        //   fontStyle: FontStyle.normal,
                        //   fontSize: 14,
                        //   color: Color(0xff000000),
                        // ),
                        filled: true,
                        fillColor: Color(0xfff0f0f0),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: Align(
                      alignment: Alignment(-0.8, 0.0),
                      child: Text(
                        "Email",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 5, 30, 130),
                    child: TextField(
                      // controller: emailController,
                      obscureText: false,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              BorderSide(color: Color(0x00000000), width: 1),
                        ),
                        hintText: "hilmiwulan8@gmail.com",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        filled: true,
                        fillColor: Color(0xffededed),
                        isDense: false,
                        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 1),
              child: Container(
                margin: const EdgeInsets.only(top: 365),
                padding: EdgeInsets.fromLTRB(19, 22, 21, 24),
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xff345ea8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: TextButton(
                  // group34456KJR (4:1128)
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xff4ab4de),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
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
    );
  }
}

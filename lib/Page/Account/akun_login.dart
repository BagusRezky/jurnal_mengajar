///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:jurnal_mengajar/Page/Admin/dashboard_admin.dart';
import 'package:jurnal_mengajar/Page/Guru/DasboardGuru.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../color/color.dart';
import 'akun_daftar.dart';
import 'akun_lupa_password.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AkunLogin extends StatefulWidget {
  const AkunLogin({super.key});

  @override
  State<AkunLogin> createState() => _AkunLoginState();
}

class _AkunLoginState extends State<AkunLogin> {
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final passwordVisibility = true.obs;

  var isLoading =
      false.obs; // Tambahkan variabel untuk mengontrol indikator loading

  void loginUser() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));

    final email = emailController.text;
    final password = passwordController.text;

    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/login?email=$email&password=$password');
    final response = await http.post(url);

    /* decode() method will decode your token's payload */

    if (response.statusCode == 200) {
      final respon = json.decode(response.body);
      print('${respon}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('tokenJwt', respon);

      Map<String, dynamic> decodedToken = JwtDecoder.decode(respon);
      var roles = decodedToken["roles"];

      if (roles == 'admin') {
        Get.to(const DashboardAdmin());
      } else {
        Get.to(const DashboardGuru());
      }

      isLoading.value = false;
    } else {
      isLoading.value = false;

      // Tampilkan pesan error jika login gagal
      // ignore: use_build_context_synchronously
      Get.defaultDialog(
        title: "Login Gagal",
        middleText:
            "Sepertinya ada yang salah dengan email dan password yang Anda masukkan",
        backgroundColor: MainColor.error,
        titleStyle: TextStyle(color: MainColor.alternateColor),
        middleTextStyle: TextStyle(color: MainColor.alternateColor),
      );
    }
    void _logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6e6e6),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        color: MainColor.primaryColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.zero,
                        border: Border.all(
                            color: const Color(0x4d9e9e9e), width: 1),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                    width: MediaQuery.of(context).size.width,
                    height: 420,
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      border:
                          Border.all(color: const Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ///***If you have exported images you must have to copy those images in assets/images directory.
                            Image(
                              image: const AssetImage(
                                  "assets/images/logo/LogoJr.png"),
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.5,
                              fit: BoxFit.fitWidth,
                            ),
                            TextField(
                              controller: emailController,
                              obscureText: false,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Color(0x00000000), width: 1),
                                ),
                                hintText: "Email",
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff494646),
                                ),
                                filled: true,
                                fillColor: const Color(0xffeeeeee),
                                isDense: false,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: Obx(
                                () => TextField(
                                  controller: passwordController,
                                  obscureText: passwordVisibility.value,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  autofillHints: const [AutofillHints.password],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                  ),
                                  decoration: InputDecoration(
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                          color: Color(0x00ffffff), width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                          color: Color(0x00ffffff), width: 1),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                          color: Color(0x00ffffff), width: 1),
                                    ),
                                    hintText: "Password",
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: Color(0xff494646),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xffeeeeee),
                                    isDense: false,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        passwordVisibility.value =
                                            !passwordVisibility.value;
                                      },
                                      child: Icon(
                                        passwordVisibility.value
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xff212435),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      const AkunLupaPassword(),
                                    );
                                  },
                                  child: Text(
                                    "Lupa Password?",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14,
                                      color: MainColor.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Obx(
                              () => Container(
                                width: double.infinity,
                                height: 44,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MainColor.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Stack(
                                    children: [
                                      isLoading.value
                                          ? SizedBox(
                                              width: 25,
                                              height: 25,
                                              child:
                                                  const CircularProgressIndicator(
                                                strokeWidth: 4.0,
                                              ),
                                            )
                                          : const Text(
                                              "Login",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                    ],
                                  ),
                                  onPressed: () {
                                    loginUser();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                    child: Text(
                                      "Guru Baru?",
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
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const AkunDaftar());
                                    },
                                    child: Text(
                                      "Daftar Disini",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: MainColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            ///***If you have exported images you must have to copy those images in assets/images dire
          ],
        ),
      ),
    );
  }
}

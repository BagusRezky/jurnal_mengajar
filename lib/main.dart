import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

// import 'package:jurnal_mengajar/Page/Admin/Guru/AdminGuru.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'Page/Account/akun_login.dart';
import 'Page/Account/app_splash_screen.dart';
// import 'Page/Admin/dashboard_admin.dart';
// import 'Page/Guru/DasboardGuru.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   // Timer(Duration(seconds: 2), () {

  //   // });
  //   checkLoginStatus();
  // }

  // Future<void> checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? tokenJwt = prefs.getString('tokenJwt');

  //   if (tokenJwt != null && tokenJwt.isNotEmpty) {
  //     Get.to(DashboardAdmin());
  //   } else {
  //     Get.to(AkunLogin());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: Future.delayed(const Duration(seconds: 3)),
    //   builder: (context, snapshot) {
    //     // kondisi ketika lagi tunggu selama 3 detik
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const AppSplashScreen();
    //     } else if (tokenJwt != null && tokenJwt.isNotEmpty) {
    //       return const GetMaterialApp(
    //         title: 'Application',
    //         debugShowCheckedModeBanner: false,
    //         home: AdminGuru(),
    //       );

    //     } else {
    //       Get.to(AkunLogin());
    //     };
    //   },
    // );
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        // kondisi ketika lagi tunggu selama 3 detik
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppSplashScreen();
        } else {
          return const GetMaterialApp(
            title: 'Application',
            debugShowCheckedModeBanner: false,
            home: AkunLogin(),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnal_mengajar/Page/Account/app_about.dart';
import 'package:jurnal_mengajar/Page/Admin/Guru/AdminGuru.dart';
import 'package:jurnal_mengajar/Page/Admin/JadwalMingguan/AdminJadwalMingguan.dart';
import 'package:jurnal_mengajar/Page/Admin/Jurnal/AdminJurnal.dart';
import 'package:jurnal_mengajar/Page/Admin/admin_setting.dart';
import 'package:jurnal_mengajar/Page/Admin/dashboard_admin.dart';

import '../Page/Account/akun_login.dart';
import '../Page/Admin/Jadwal/AdminJadwal.dart';
import '../Page/Admin/JamPelajaran/admin_jam_pelajaran_view.dart';
import '../Page/Admin/Kelas/admin_kelas_view.dart';
import '../Page/Admin/Pelajaran/admin_pelajaran_view.dart';
import '../Page/Admin/Periode/admin_periode_view.dart';
import '../color/color.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({super.key});

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/logo/LogoJr.png',
              width: 138,
              height: 63,
            ),
            const Divider(
              color: Color(0xFFC6C6C6),
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(
                    const DashboardAdmin(),
                  );
                },
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: MainColor.secondaryText,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          'Dashboard',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(const AdminJurnal());
                },
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: MainColor.secondaryText,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          'Jurnal Mengajar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(const AdminJadwal());
                },
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: MainColor.secondaryText,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          'Jadwal Mengajar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(const AdminJadwalMingguan());
                },
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: MainColor.secondaryText,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          'Jadwal Mingguan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(const AdminSetting());
                },
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.settings,
                        color: MainColor.secondaryText,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(const AppAbout());
                },
                child: SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.help,
                        color: MainColor.secondaryText,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text(
                          'Tentang Aplikasi',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFC6C6C6),
              thickness: 2,
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Master Data',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: ('Poppins'),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const AdminPeriode());
              },
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.label,
                      color: MainColor.secondaryText,
                      size: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        'Periode',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const AdminPelajaran());
              },
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.library_books,
                      color: MainColor.secondaryText,
                      size: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        'Pelajaran',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const AdminJamPelajaran());
              },
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.watch_later,
                      color: MainColor.secondaryText,
                      size: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        'Jam Pelajaran',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const AdminKelas());
              },
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_city,
                      color: MainColor.secondaryText,
                      size: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        'Kelas',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(const AdminGuru());
              },
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      color: MainColor.secondaryText,
                      size: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        'Guru',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFC6C6C6),
              thickness: 2,
            ),
            GestureDetector(
              onTap: () {
                Get.to(const AkunLogin());
              },
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.logout,
                      color: MainColor.secondaryText,
                      size: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        'Keluar',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: MainColor.secondaryText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/Jadwal/admin_jadwal_form.dart';
import 'package:jurnal_mengajar/Page/Admin/Jadwal/admin_jadwal_form_edit.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../color/color.dart';

class AdminJadwal extends StatefulWidget {
  // const AdminJadwal({super.key});
  final DateTime? Tanggal;

  const AdminJadwal({super.key, this.Tanggal});

  @override
  State<AdminJadwal> createState() => _AdminJadwalState();
}

class _AdminJadwalState extends State<AdminJadwal> {
  List<dynamic> jadwalData = [];
  bool isSelesai = false;
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _onDaySelected(selectedDate, selectedDate);
    showToken();
  }

  Future<void> _onDaySelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      selectedDate = day;
    });
    await loadData(selectedDate);
  }

  Future<void> loadData(DateTime date) async {
    var data = await JadwalDataUtil.fetchData(date);
    if (data != null) {
      setState(() {
        jadwalData = data['Data'];
        isSelesai = true;
      });
    } else {
      setState(() {
        jadwalData = [];
      });
    }
  }

  void showToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('tokenJwt');
    print('$token');
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: MainColor.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Jadwal Mengajar",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 20,
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
            size: 26,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminJadwalForm(
                      updateCallback: () {
                        loadData(selectedDate);
                      },
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.add_circle,
                color: Color(0xffffffff),
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Text("Selected dAY = " + today.toString().split(" ")[0]),
            TableCalendar(
              locale: "en_US",
              focusedDay: today,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              // onDaySelected: (selectedDay, focusedDay) {
              //   setState(() {
              //     selectedDate = selectedDay;
              //   });
              //   JadwalDataUtil();
              // },
              // selectedDayPredicate: (day) => isSameDay(selectedDate, day),
              calendarFormat: CalendarFormat.week,
              rowHeight: 64,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
                weekendStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: MainColor.primaryBackground,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MainColor.primaryColor,
                ),
                selectedTextStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: MainColor.primaryBackground,
                ),
              ),
              availableGestures: AvailableGestures.all,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: MainColor.primaryColor,
                ),
                // onChange
              ),
            ),
            Stack(
              children: [
                isSelesai
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                          child: ListView.builder(
                            itemCount: jadwalData.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final Jadwal = jadwalData[index];
                              var isCreateJadwal = Jadwal['Aktif']; //bool
                              final String base64Image = Jadwal['foto'] ??
                                  ''; // Ganti 'foto' dengan nama field base64 gambar
                              Uint8List? imageBytes;

                              if (base64Image.isNotEmpty) {
                                imageBytes =
                                    base64Decode(base64Image.split(',').last);
                                print('Berhasil');
                              } else {
                                print('Gagal');
                              }
                              return Container(
                                margin: const EdgeInsets.only(
                                  bottom: 5,
                                ),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width,
                                height: 85,
                                decoration: BoxDecoration(
                                  color: isCreateJadwal
                                      ? MainColor.validateColor
                                      : MainColor.secondaryColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminJadwalFormEdit(
                                          updateCallback: () =>
                                              loadData(DateTime.now()),
                                          jadwalData: Jadwal,
                                          jadwalId: Jadwal['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 10),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: imageBytes != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.memory(
                                                    imageBytes,
                                                    fit: BoxFit.cover,
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                )
                                              : Image.asset(
                                                  'assets/images/guru2.jpg',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 14, 12, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 3),
                                                    child: Text(
                                                      "${Jadwal['Guru']}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16,
                                                        color: isCreateJadwal
                                                            ? MainColor
                                                                .secondaryColor
                                                            : MainColor
                                                                .primaryBackground,
                                                      ),
                                                    ),
                                                  ),
                                                  isCreateJadwal
                                                      ? Icon(
                                                          Icons.verified,
                                                          color: MainColor
                                                              .sudahValidasiCheckColor,
                                                          size: 22,
                                                        )
                                                      : Icon(
                                                          Icons.verified,
                                                          color: MainColor
                                                              .alternateColor,
                                                          size: 22,
                                                        ),
                                                ],
                                              ),
                                              Text(
                                                "${Jadwal['Pelajaran']}",
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14,
                                                  color: isCreateJadwal
                                                      ? MainColor.secondaryColor
                                                      : MainColor
                                                          .primaryBackground,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 0, 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        "${Jadwal['Kelas']}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12,
                                                          color: isCreateJadwal
                                                              ? MainColor
                                                                  .secondaryColor
                                                              : MainColor
                                                                  .primaryBackground,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${Jadwal['Pukul']}",
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 12,
                                                          color: isCreateJadwal
                                                              ? MainColor
                                                                  .secondaryColor
                                                              : MainColor
                                                                  .primaryBackground,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
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
                            },
                          ),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class JadwalDataUtil {
  static Future<Map<String, dynamic>> fetchData(DateTime selectedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    String? tenantId;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenantId = decodedToken['tenant_id'];
    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };
    final selectedDateFormatted =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jadwal-cari/admin?tanggal=$selectedDateFormatted&tenant_id=$tenantId&sort_order=ascending&page=1&limit=10');
    final response = await http.post(url, headers: headers);

    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData; // Ganti dengan nama yang sesuai di API
    } else {
      print('Gagal mengambil data jadwal');
      return {};
    }
  }
}

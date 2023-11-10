import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jurnal_mengajar/Page/Admin/Jadwal/AdminJadwal.dart';
import 'package:jurnal_mengajar/Page/Admin/Jadwal/AdminJadwal.dart';
import 'package:jurnal_mengajar/Page/Guru/GuruJadwal/GuruJadwalDetail.dart';
import 'package:jurnal_mengajar/Page/Guru/GuruJadwal/GuruJadwalDetail2.dart';
import 'package:jurnal_mengajar/widgets/Calendar/calendar_controller.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../../color/color.dart';
import '../../../widgets/Calendar/calendar.dart';

class GuruJadwal extends StatefulWidget {
  // const GuruJadwal({super.key});
  final DateTime? Tanggal;

  const GuruJadwal({super.key, this.Tanggal});

  @override
  State<GuruJadwal> createState() => _GuruJadwalState();
}

class _GuruJadwalState extends State<GuruJadwal> {
  List<dynamic> jadwalData = [];
  bool isSelesai = false;
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _onDaySelected(selectedDate, selectedDate);
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
        jadwalData = data;
        isSelesai = true;
      });
    } else {
      setState(() {
        jadwalData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.secondaryBackground,
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
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GuruJadwalDetail(
                      updateCallback: () {
                        loadData(selectedDate);
                      },
                      jadwalData: {},
                      jadwalId: '',
                    ),
                  ),
                );
              },
              child: Icon(
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Calendar(),
            // Text("Selected Day = " + today.toString().split(" ")[0]),
            TableCalendar(
              // focusedDay: _focusedDay,
              // firstDay: DateTime(2022),
              // lastDay: DateTime(2025),
              // calendarFormat: _calendarFormat,

              // onDaySelected: (selectedDay, focusedDay){
              //   if(!isSameDay(_selectedDate, selectedDay)){
              //     setState(() {
              //       _selectedDate = selectedDay;
              //       _focusedDay = focusedDay;
              //     });
              //   }
              // },
              // selectedDayPredicate: (day){
              //   return isSameDay(_selectedDate, day);
              // },

              // onFormatChanged: (format) {
              //   if(_calendarFormat != format){
              //     setState(() {
              //       _calendarFormat = format;
              //     });
              //   }
              // },
              // onPageChanged: (focusedDay) {
              //   _focusedDay = focusedDay;
              // },
              locale: "en_US",
              focusedDay: today,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected,
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
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
            //           selectedDayPredicate: (day) {
            //             return isSameDay(_selectedDay, day);
            //           },
            //           onDaySelected: (selectedDay, focusedDay) {
            //           setState(() {
            //             _selectedDay = selectedDay;
            //             _focusedDay = focusedDay; // update `_focusedDay` here as well
            //             });
            //           },

            //           calendarFormat: _calendarFormat,
            //           onFormatChanged: (format) {
            //             setState(() {
            //               _calendarFormat = format;
            //             });
            //           },
            //           onPageChanged: (focusedDay) {
            //             _focusedDay = focusedDay;
            //           },
            //           eventLoader: (day) {
            //             return _getJadwalForDay(day);
            //           },

            //           List<JadwalDataUtil> _getJadwalForDay(DateTime day) {
            //             return jadwalData[day] ?? [];
            //           }

            //           final jadwalData = LinkedHashMap(
            //             equals: isSameDay,
            //             hashCode: getHashCode,
            //           )..addAll(jurnalSource);

            //           jadwalLoader: (day){
            //             if (day.weekday == DateTime.monday){
            //               return [JadwalDataUtil('Clyclic jurnal')];
            //             }
            //             return [];
            //           },
            //           void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
            //           if (!isSameDay(_selectedDay, selectedDay)) {
            //           setState(() {
            //             _focusedDay = focusedDay;
            //             _selectedDay = selectedDay;
            //             _selectedJadwals = _getJadwalForDay(selectedDay);
            //           });
            //         }
            //       }
            //       calendarBuilders: CalendarBuilders(
            //         dowBuilder: (context, day) {
            //       if (day.weekday == DateTime.sunday) {
            //       final text = DateFormat.E().format(day);

            //       return Center(
            //         child: Text(
            //           text,
            //           style: TextStyle(color: Colors.red),
            //         ),
            //       );
            //     }
            //   },
            // ),
            Stack(
              children: [
                isSelesai
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: false,
                            physics: const ScrollPhysics(),
                            itemCount: jadwalData.length,
                            itemBuilder: (context, index) {
                              // final GuruJadwal = jadwalData[index];
                              // ignore: unused_label
                              final Jadwal = jadwalData[index];
                              var isCreateJadwal = Jadwal['Jadwal'];
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                padding: const EdgeInsets.all(0),
                                width: 200,
                                height: 69,
                                decoration: BoxDecoration(
                                  color: isCreateJadwal != null
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
                                        builder: (context) => GuruJadwalDetail2(
                                          jadwalData: Jadwal,
                                          jadwalId: Jadwal['id'],
                                          updateCallback: () {},
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 35, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 15, 0),
                                                    child: Text(
                                                      '${Jadwal['pukul']}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16,
                                                        color: isCreateJadwal !=
                                                                null
                                                            ? MainColor
                                                                .secondaryColor
                                                            : MainColor
                                                                .primaryBackground,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${Jadwal['kelas']}",
                                                    textAlign: TextAlign.start,
                                                    overflow: TextOverflow.clip,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16,
                                                      color: isCreateJadwal !=
                                                              null
                                                          ? MainColor
                                                              .secondaryColor
                                                          : MainColor
                                                              .primaryBackground,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${Jadwal['pelajaran']}",
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14,
                                                  color: isCreateJadwal != null
                                                      ? MainColor.secondaryColor
                                                      : MainColor
                                                          .primaryBackground,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        isCreateJadwal != null
                                            ? Icon(
                                                Icons.arrow_forward_ios,
                                                color:
                                                    MainColor.primaryBackground,
                                                size: 22,
                                              )
                                            : Icon(
                                                Icons.arrow_forward_ios,
                                                color: MainColor.secondaryColor,
                                                size: 22,
                                              ),
                                        // Icon(
                                        //   Icons.arrow_forward_ios,
                                        //   color: Color(0xffc6cfde),
                                        //   size: 24,
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : CircularProgressIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class JadwalDataUtil {
  static Future<List<dynamic>?> fetchData(DateTime selectedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer $tokenJwt';
    String? tenantId;
    String? guru;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenantId = decodedToken['tenant_id'];
    guru = decodedToken['guru_id'];
    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };
    final selectedDateFormatted =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jadwal-cari/guru?tanggal=$selectedDateFormatted&guru=$guru&tenant_id=$tenantId&sort_order=ascending&page=1&limit=10');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['Data']; // Ganti dengan nama yang sesuai di API
    } else {
      print('Gagal mengambil data jadwal');
      return null;
    }
  }
}

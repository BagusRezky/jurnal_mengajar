///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jurnal_mengajar/Page/Admin/Jurnal/AdminJurnalDetail.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../color/color.dart';

class AdminJurnal extends StatefulWidget {
  // const AdminJurnal({super.key});
  final DateTime? Tanggal;

  const AdminJurnal({super.key, this.Tanggal});

  @override
  State<AdminJurnal> createState() => _AdminJurnalState();
}

class _AdminJurnalState extends State<AdminJurnal> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> jurnalData = []; // List untuk menyimpan data periode
  List<dynamic> filteredJurnalData = [];
  bool isSelesai = false;
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _onDaySelected(selectedDate, selectedDate);
    // super.initState();
    // showToken();
    // loadData();
  }

  Future<void> _onDaySelected(DateTime day, DateTime focusedDay) async {
    setState(() {
      selectedDate = day;
    });
    await loadData(selectedDate);
  }

  Future<void> loadData(DateTime date) async {
    var data = await JurnalDataUtil.fetchData(date);
    if (data != null) {
      setState(() {
        jurnalData = data;
        isSelesai = true;
      });
    } else {
      setState(() {
        jurnalData = [];
      });
    }
  }

  void showToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.get('tokenJwt');
    print('$token');
  }

  // Future<void> loadData() async {
  //   var data = await JurnalDataUtil.fetchData();
  //   if (data != null) {
  //     setState(() {
  //       jurnalData = data;
  //       filteredJurnalData = data;
  //     });
  //   }
  // }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('tokenJwt'); // Menghapus token dari SharedPreferences
    SystemNavigator.pop();
  }

  // void _filterPeriodeData(String searchText) async {
  //   // Kirim permintaan pencarian ke API dan perbarui filteredPeriodeData
  //   final searchData = await JurnalSearch.searchData(searchText);
  //   if (searchData != null) {
  //     setState(() {
  //       filteredJurnalData = searchData;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryBackground,
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: MainColor.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Jurnal Mengajar",
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
                            itemCount: jurnalData.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              final Jurnal = jurnalData[index];
                              var isCreateJurnal = Jurnal['Approved']; //bool
                              final String base64Image = Jurnal['foto_guru'] ??
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
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                padding: const EdgeInsets.all(0),
                                width: MediaQuery.of(context).size.width,
                                height: 78,
                                decoration: BoxDecoration(
                                  color: isCreateJurnal
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
                                        builder: (context) => AdminJurnalDetail(
                                          jurnalData: const {},
                                          jurnalId: 'id',
                                          updateCallback: () {},
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
                                            10, 13, 0, 18),
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
                                                      "${Jurnal['Guru']}",
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
                                                        color: isCreateJurnal
                                                            ? MainColor
                                                                .secondaryColor
                                                            : MainColor
                                                                .primaryBackground,
                                                      ),
                                                    ),
                                                  ),
                                                  isCreateJurnal
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
                                                "${Jurnal['Kelas']}",
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14,
                                                  color: isCreateJurnal
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
                                                        "${Jurnal['Pelajaran']}",
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
                                                          color: isCreateJurnal
                                                              ? MainColor
                                                                  .secondaryColor
                                                              : MainColor
                                                                  .primaryBackground,
                                                        ),
                                                      ),
                                                      Text(
                                                        "S:${Jurnal['Absensi Sakit']} I:${Jurnal['Absensi Izin']}  A:${Jurnal['Absensi Alpha']}",
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
                                                          color: isCreateJurnal
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
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 10, 0),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color.fromARGB(
                                              255, 241, 241, 241),
                                          size: 22,
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

class JurnalDataUtil {
  static Future<List<dynamic>?> fetchData(DateTime selectedDate) async {
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
        'https://jurnalmengajar-1-r8590722.deta.app/jurnal-cari/admin?tanggal=$selectedDateFormatted&tenant_id=$tenantId&sort_order=ascending&page=1&limit=10');
    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['Data']; // Ganti dengan nama yang sesuai di API
    } else {
      print('Gagal mengambil data jurnal');
      return null;
    }
  }
}

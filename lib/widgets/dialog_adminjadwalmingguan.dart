import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DialogAdminJadwalMingguan extends StatefulWidget {
  // const DialogAdminJadwalMingguan({super.key});
  final VoidCallback updateCallback;
  const DialogAdminJadwalMingguan({super.key, required this.updateCallback});

  @override
  State<DialogAdminJadwalMingguan> createState() =>
      _DialogAdminJadwalMingguanState();
}

class _DialogAdminJadwalMingguanState extends State<DialogAdminJadwalMingguan> {
  final TextEditingController _date = TextEditingController();

  final isAktif = true.obs;

  // periode
  List<dynamic> itemsPeriode = [];
  String? selectedValuePeriode;

  // tahun
  List<dynamic> itemsTahun = [];
  String? selectedValueTahun;

  // bulan
  List<dynamic> itemsBulan = [];
  String? selectedValueBulan;

  String? tokenJwt = "";

  @override
  void initState() {
    super.initState();
    fetchDataPeriodeFromApi();
    fetchDataTahunFromApi();
    fetchDataBulanFromApi();
  }

  Future<void> fetchDataPeriodeFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/periode-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsPeriode = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataTahunFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jadwalmingguan-cari?periode=2023%2F2024&kelas=XII%20RPL%201&hari=Senin&guru=Jasmine&tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsTahun = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataBulanFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer $tokenJwt');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/kelas-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsBulan = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Align(
              alignment: Alignment(-1.0, 0.0),
              child: Text(
                "Buat Jadwal",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                  fontSize: 16,
                  color: Color(0xff000000),
                ),
              ),
            ),
          ),
          const Divider(
            color: Color(0xfff5e1d5),
            height: 16,
            thickness: 0,
            indent: 3,
            endIndent: 7,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Align(
              alignment: Alignment(-1.0, 0.0),
              child: Text(
                "Periode",
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: const Text(
                      "Pilih Periode",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 12,
                        color: Color(0xff000000),
                      ),
                    ),
                    value: selectedValuePeriode,
                    items: itemsPeriode.map((item) {
                      return DropdownMenuItem(
                        value: item['nama'],
                        child: Text(item['nama']),
                      );
                    }).toList(),
                    style: const TextStyle(
                      color: Color(0xff000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedValuePeriode = value as String?;
                      });
                    },
                    elevation: 8,
                    isExpanded: true,
                  ),
                )),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Align(
              alignment: Alignment(-1.0, 0.0),
              child: Text(
                "Tahun",
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: "Pilih Tahun",
                    items: ["Pilih Tahun"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: const TextStyle(
                      color: Color(0xff000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                    onChanged: (value) {},
                    elevation: 8,
                    isExpanded: true,
                  ),
                )),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Align(
              alignment: Alignment(-1.0, 0.0),
              child: Text(
                "Bulan",
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: "Pilih Bulan",
                    items: ["Pilih Bulan"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: const TextStyle(
                      color: Color(0xff000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                    onChanged: (value) {},
                    elevation: 8,
                    isExpanded: true,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: MaterialButton(
              onPressed: () {},
              color: const Color(0xff2267d5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.0),
              ),
              padding: const EdgeInsets.all(16),
              textColor: const Color(0xffffffff),
              height: 50,
              minWidth: 320,
              child: const Text(
                "Buat Jadwal",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

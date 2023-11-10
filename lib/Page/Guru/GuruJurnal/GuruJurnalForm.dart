import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../color/color.dart';

class GuruJurnalForm extends StatefulWidget {
  final VoidCallback updateCallback;
  const GuruJurnalForm({required this.updateCallback});

  @override
  State<GuruJurnalForm> createState() => _GuruJurnalFormState();
}

DateTime dateTime = DateTime.now();

// Format the DateTime using intl package
String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

class _GuruJurnalFormState extends State<GuruJurnalForm> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController materi = TextEditingController();
  final TextEditingController sakit = TextEditingController();
  final TextEditingController izin = TextEditingController();
  final TextEditingController alpha = TextEditingController();
  final TextEditingController catatan = TextEditingController();
  final TextEditingController image = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formfield = GlobalKey<FormState>();

  // jam
  List<dynamic> itemsJam = [];
  String? selectedValueJam;

  // kelas
  List<dynamic> itemsKelas = [];
  String? selectedValueKelas;

  // pelajaran
  List<dynamic> itemsPelajaran = [];
  String? selectedValuePelajaran;

  String? tokenJwt = "";

  void initState() {
    super.initState();
    fetchDataJamFromApi();
    fetchDataKelasFromApi();
    fetchDataPelajaranFromApi();
  }

  Future<void> fetchDataJamFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer ${tokenJwt}');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jampel-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsJam = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataKelasFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer ${tokenJwt}');
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
        itemsKelas = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> fetchDataPelajaranFromApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');
    final token = 'Bearer $tokenJwt';
    String? tenant;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenant = decodedToken['tenant_id'];
    print('Bearer ${tokenJwt}');
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/pelajaran-cari?tenant_id=$tenant&sort_order=ascending&page=1&limit=10');

    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      var listData = jsonDecode(response.body);
      setState(() {
        itemsPelajaran = listData['Data'];
      });
    } else {
      throw Exception('Failed to load data from the API');
    }
  }

  Future<void> createJurnal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenJwt = prefs.getString('tokenJwt');

    final token = 'Bearer ${tokenJwt}';
    String? tenantId;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    tenantId = decodedToken['tenant_id'];
    final headers = {
      'accept': 'application/json',
      'Authorization': token,
    };
    final url = Uri.parse(
        'https://jurnalmengajar-1-r8590722.deta.app/jurnal-tambah?jadwal_id=6539d63c6e0487c38a50ff69&materi=Dasar%20basis%20data&sakit=1&izin=0&alpha=0&catatan=siswa%20dapat%20melaksanakannya%20dengan%20baik&tenant_id=651a3ea147a3d131b32ff353');

    final Map<String, dynamic> body = {
      'materi': materi,
      'sakit': sakit,
      'izin': izin,
      'alpha': alpha,
      'catatan': catatan,
      'date': _date,
      'pukul': selectedValueJam,
      'kelas': selectedValueKelas,
      'pelajaran': selectedValuePelajaran,
    };

    // final headers = {
    //   'accept': 'application/json',
    //   'Authorization': token,
    // };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Jurnal berhasil ditambahkan');
      widget.updateCallback();
      Future.delayed(Duration(seconds: 2), () {
        setState(() {});
        Navigator.pop(context);
      });
      // ignore: use_build_context_synchronously
    } else {
      print('Jurnal gagal ditambahkan');
      // ignore: use_build_context_synchronously
    }
  }

  Future<File> getImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //TO convert Xfile into file
    File file = File(image!.path);
    //print(‘Image picked’);
    return file;
  }

  var request;
  final url = Uri.parse(
      'https://jurnalmengajar-1-r8590722.deta.app/jurnal?page=1&limit=10');

  // Future<void> fetchDataPelajaranFromApi() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   tokenJwt = prefs.getString('tokenJwt');

  //   final token = 'Bearer ${tokenJwt}';
  //   print('Bearer ${tokenJwt}');
  //   final url = Uri.parse(
  //       'https://jurnalmengajar-1-r8590722.deta.app/pelajaran?page=1&limit=10');

  //   final headers = {
  //     'accept': 'application/json',
  //     'Authorization': token,
  //   };

  //   final response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     var listData = jsonDecode(response.body);
  //     setState(() {
  //       itemsPelajaran = listData;
  //     });
  //   } else {
  //     throw Exception('Failed to load data from the API');
  //   }
  // }

  String _baseUrl =
      'https://jurnalmengajar-1-r8590722.deta.app/kelas?page=1&limit=5';
  late String _kelas;
  void getKelas() async {
    final respose = await http.get((_baseUrl + "getKelas1")
        as Uri); //untuk melakukan request ke webservice
    var listData = jsonDecode(respose.body); //lalu kita decode hasil datanya
    setState(() {
// dan kita set kedalam variable _dataProvince
    });
    print("data : $listData");
  }

  late File selectedImage;
  var resJson;

  onUploadImage() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("Enter You API Url"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'image',
        selectedImage.readAsBytes().asStream(),
        selectedImage.lengthSync(),
        filename: selectedImage.path.split('/').last,
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    setState(() {
      resJson = jsonDecode(response.body);
    });
  }

  // Future getImage() async {
  //   var image = await ImagePicker().getImage(source: ImageSource.gallery);

  //   setState(() {
  //     selectedImage = File(image.path);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff345ea8),
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
        actions: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Icon(Icons.save, color: Color(0xffffffff), size: 20),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    height: 85,
                    decoration: const BoxDecoration(
                      color: Color(0x00000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Tanggal",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            color: Color(0xff000000),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _date,
                                obscureText: false,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                                decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x00000000), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x00000000), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: const BorderSide(
                                        color: Color(0x00000000), width: 1),
                                  ),
                                  hintText: formattedDate,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xfff1f4f8),
                                  isDense: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  suffixIcon: const Icon(Icons.calendar_today,
                                      color: Color(0xff212435), size: 24),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    setState(() {
                                      _date.text = DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0x00000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text(
                                "Jam Ke",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                  color: Color(0xff000000),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff1f4f8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: Text(
                                          "Pilih Jam",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        value: selectedValueJam,
                                        items: itemsJam.map((item) {
                                          return DropdownMenuItem(
                                            child:
                                                Text(item['jam_ke'].toString()),
                                            value: item['jam_ke'].toString(),
                                          );
                                        }).toList(),
                                        style: const TextStyle(
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValueJam = value;
                                          });
                                        },
                                        elevation: 8,
                                        isExpanded: true,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text(
                                "Kelas",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16,
                                  color: Color(0xff000000),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                                child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff1f4f8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        hint: Text(
                                          "Pilih Kelas",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                            color: Color(0xff000000),
                                          ),
                                        ),
                                        value: selectedValueKelas,
                                        items: itemsKelas.map((item) {
                                          return DropdownMenuItem(
                                            child: Text(item['nama']),
                                            value: item['nama'],
                                          );
                                        }).toList(),
                                        style: const TextStyle(
                                          color: Color(0xff000000),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValueKelas =
                                                value as String?;
                                          });
                                        },
                                        elevation: 8,
                                        isExpanded: true,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    height: 79,
                    decoration: const BoxDecoration(
                      color: Color(0x00a31212),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Pelajaran",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            color: Color(0xff000000),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xfff1f4f8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                  "Pilih Pelajaran",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                value: selectedValuePelajaran,
                                items: itemsPelajaran.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['nama']),
                                    value: item['nama'],
                                  );
                                }).toList(),
                                style: const TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedValuePelajaran = value as String?;
                                  });
                                },
                                elevation: 8,
                                isExpanded: true,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    height: 71,
                    decoration: const BoxDecoration(
                      color: Color(0x00000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Materi",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            color: Color(0xff000000),
                          ),
                        ),
                        TextFormField(
                          controller: materi,
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00000000), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00000000), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: const BorderSide(
                                  color: Color(0x00000000), width: 1),
                            ),
                            filled: true,
                            fillColor: const Color(0xfff1f4f8),
                            isDense: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    height: 68,
                    decoration: const BoxDecoration(
                      color: Color(0x00000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Absensi (S, I, A)",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              width: 33,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xfff1f4f8),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: TextFormField(
                                controller: sakit,
                                textAlign: TextAlign.start,
                                // overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              padding: const EdgeInsets.all(0),
                              width: 33,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xfff1f4f8),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: TextFormField(
                                controller: izin,
                                textAlign: TextAlign.start,
                                // overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              width: 33,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xfff1f4f8),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: TextFormField(
                                controller: alpha,
                                textAlign: TextAlign.start,
                                // overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14,
                                  color: Color(0xff000000),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text(
                                "Total Siswa : ",
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
                            // const Text(
                            //   "36",
                            //   textAlign: TextAlign.start,
                            //   overflow: TextOverflow.clip,
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w400,
                            //     fontStyle: FontStyle.normal,
                            //     fontSize: 16,
                            //     color: Color(0xff000000),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0x00000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Catatan",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: TextFormField(
                            controller: catatan,
                            obscureText: false,
                            textAlign: TextAlign.start,
                            maxLines: 4,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                            decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0x00750808), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0x00750808), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                borderSide: const BorderSide(
                                    color: Color(0x00750808), width: 1),
                              ),
                              filled: true,
                              fillColor: const Color(0xfff1f4f8),
                              isDense: false,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 130),
                    padding: const EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0x00000000),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Lampiran (file/gambar)",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                            Icon(
                              Icons.add_circle,
                              color: Color(0xff185dd5),
                              size: 24,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width,
                          height: 124,
                          decoration: BoxDecoration(
                            color: const Color(0x1f000000),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: const Color(0xffffffff), width: 1),
                          ),
                          child:

                              ///***If you have exported images you must have to copy those images in assets/images directory.
                              Image(
                            // children: <Widget>[
                            //   selectedImage == null
                            //       ? Text(
                            //           'Please Pick a image to Upload',
                            //         )
                            //       : Image.file(selectedImage),
                            //   TextButton(
                            //     child: Colors.green[300],
                            //     onPressed: onUploadImage,
                            //     child: Text(
                            //       "Upload",
                            //       style: TextStyle(color: Colors.white),
                            //     ),
                            //   ),
                            //   Text(resJson['message'])
                            // ],
                            image:
                                const AssetImage("assets/images/belajar.jpg"),
                            // height: 20,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                onPressed: () {
                  createJurnal();
                },
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
    );
  }
}

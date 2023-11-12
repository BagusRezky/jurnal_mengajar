///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../color/color.dart';

class AdminJurnalDetail extends StatefulWidget {
  // const AdminJurnalDetail({super.key});
  final Map<String, dynamic> jurnalData;
  final String jurnalId;
  final VoidCallback updateCallback;
  const AdminJurnalDetail(
      {Key? key,
      required this.jurnalData,
      required this.jurnalId,
      required this.updateCallback})
      : super(key: key);

  @override
  State<AdminJurnalDetail> createState() => _AdminJurnalDetailState();
}

class _AdminJurnalDetailState extends State<AdminJurnalDetail> {
  Uint8List? images;

  @override
  void initState() {
    super.initState();
    String fotoBase64 = widget.jurnalData['Foto'] ?? '';
    images = fotoBase64.isNotEmpty
        ? base64.decode(fotoBase64.split(',').last)
        : null;
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
            size: 26,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Icon(Icons.done, color: Color(0xffffffff), size: 30),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 90),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ///***If you have exported images you must have to copy those images in assets/images directory.
                    images != null
                        ? ClipRRect(
                            // borderRadius: BorderRadius.circular(100),
                            child: Image.memory(
                              images!,
                              height: 241,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/belajar.jpg',
                            height: 241,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 0, 0),
                      child: Text(
                        '${widget.jurnalData['Guru']}',
                        // '${widget.jurnalData['Guru']}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 5, 0, 0),
                      child: Text(
                        '${widget.jurnalData['Kelas']}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Color(0xff3560ab),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 5, 0, 0),
                      child: Text(
                        '${widget.jurnalData['Pelajaran']}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 25, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Color(0x00000000),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Icon(
                                    Icons.event,
                                    color: Color(0xff355fa9),
                                    size: 26,
                                  ),
                                ),
                                Text(
                                  '${widget.jurnalData['tgl_jadwal']}',
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16,
                                    color: Color(0xff000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Container(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              width: 70,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0x00000000),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.zero,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                    child: Icon(
                                      Icons.access_time,
                                      color: Color(0xff345ea9),
                                      size: 26,
                                    ),
                                  ),
                                  Text(
                                    '${widget.jurnalData['Pukul']}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 0, 11),
                      child: Text(
                        '${widget.jurnalData['Materi']}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Divider(
                        color: Color(0xffead7c6),
                        height: 16,
                        thickness: 0,
                        indent: 2,
                        endIndent: 0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 11, 20, 0),
                      child: Text(
                        '${widget.jurnalData['Catatan']}',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 17, 0),
                              padding: const EdgeInsets.all(0),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xffeddacb),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 13, 0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text(
                                      "Sakit",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    Text(
                                      '${widget.jurnalData['Absensi Sakit']}',
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 40,
                                        color: Color(0xff335ca4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 17, 0),
                              padding: const EdgeInsets.all(0),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xffedd9c8),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                                    child: Text(
                                      "Izin",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${widget.jurnalData['Absensi Izin']}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 40,
                                      color: Color(0xff325ca6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(0),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xffeddaca),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                                    child: Text(
                                      "Alpha",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${widget.jurnalData['Absensi Alpha']}',
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 40,
                                      color: Color(0xff335da8),
                                    ),
                                  ),
                                ],
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
                  onPressed: () {},
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
                          'Validasi',
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

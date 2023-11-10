import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../color/color.dart';
import 'calendar_controller.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarController calendarController = Get.put(CalendarController());
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text("Selected dAY = " + today.toString().split(" ")[0]),
        TableCalendar(
          locale: "en_US",
          focusedDay: today,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          onDaySelected: _onDaySelected,
          selectedDayPredicate: (day) => isSameDay(day, today),
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
          ),
        ),
      ],
    );
  }
}

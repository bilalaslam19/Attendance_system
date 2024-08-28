import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomCalender extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;

  const CustomCalender({super.key, required this.onDateSelected});

  @override
  State<CustomCalender> createState() => _CustomCalenderState();
}

class _CustomCalenderState extends State<CustomCalender> {
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_buildCalender(context)],
    );
  }

  Widget _buildCalender(BuildContext context) {
    final List<DateTime> dates = List.generate(360, (index) {
      DateTime now = DateTime.now();
      return DateTime(now.year, now.month, now.day + index);
    });

    return SizedBox(
      height: 130,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dates.length,
          itemBuilder: (context, index) {
            DateTime date = dates[index];
            String month = DateFormat.MMMM().format(date);
            String day = DateFormat.d().format(date);
            String dayOfMonth = DateFormat.E().format(date);
            bool isDateSelected = date == selectDate;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectDate = date;
                  widget.onDateSelected(date);
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: isDateSelected
                        ? Colors.deepPurple
                        : Colors.deepPurple[400],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      month,
                      style: TextStyle(
                          color: isDateSelected ? Colors.white : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: isDateSelected ? Colors.white : Colors.white,
                          borderRadius: BorderRadiusDirectional.circular(100)),
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                              color: isDateSelected
                                  ? Colors.redAccent
                                  : Colors.black,
                              fontSize: 24,
                              fontWeight: isDateSelected
                                  ? FontWeight.w300
                                  : FontWeight.w300),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      dayOfMonth,
                      style: TextStyle(
                          color: isDateSelected ? Colors.white : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

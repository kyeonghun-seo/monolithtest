import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monolithtest/model/Date.dart';
import 'package:monolithtest/theme/theme.dart';
import 'package:monolithtest/ui/common/TouchBox.dart';

class HorizontalScrollCalendar extends StatefulWidget {
  const HorizontalScrollCalendar({
    required this.dates,
    required this.onTapDate,
    this.selectedDate,
    Key? key,
  }) : super(key: key);

  final List<Date> dates;
  final Function(Date) onTapDate;
  final Date? selectedDate;

  @override
  State<HorizontalScrollCalendar> createState() =>
      _HorizontalScrollCalendarState();
}

class _HorizontalScrollCalendarState extends State<HorizontalScrollCalendar> {
  final ScrollController scrollController = ScrollController();
  final Rx<double> scrollOffset = Rx(0.0);
  late final monthList = [];

  @override
  void initState() {
    scrollController.addListener(() {
      scrollOffset(scrollController.offset);
    });
    initMonthList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HorizontalScrollCalendar oldWidget) {
    initMonthList();
    super.didUpdateWidget(oldWidget);
  }

  void initMonthList() {
    Date? tempDate;
    monthList.clear();
    for (final date in widget.dates) {
      if (tempDate == null ||
          tempDate.date.substring(5, 7) != date.date.substring(5, 7)) {
        monthList.add({
          'date': date.date,
          'startIndex': widget.dates.indexOf(date),
        });
        tempDate = date;
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  double caculateMonthPosition(double offset, dynamic month) {
    final position = (month['startIndex'] as int) * 50.0 - offset + 20;
    if (monthList.last == month) {
      return max(20.0, position);
    } else {
      final nextIndex = monthList.indexOf(month) + 1;
      final nextPosition =
          (monthList[nextIndex]['startIndex'] as int) * 50.0 - offset + 20;
      if(nextPosition < 100) {
        return nextPosition - 80;
      }else {
        return max(20.0, position);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      color: CupertinoColors.systemGrey6,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ObxValue<Rx<double>>((data) {
              final offset = scrollOffset();
              return Stack(
                children: [
                  ...monthList
                      .map((e) => Container(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..translate(
                                  caculateMonthPosition(offset, e), 7.0),
                            child: Text(
                              '${DateTime.parse(e['date']).month}월',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ))
                      .toList()
                ],
              );
            }, scrollOffset),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: widget.dates.length,
              itemBuilder: (context, index) {
                final date = widget.dates[index];
                final dateTime = DateTime.parse(date.date);
                return _CalendarDate(
                  date: date,
                  onTapDate: widget.onTapDate,
                  dateTime: DateTime.parse(date.date),
                  isSelected: widget.selectedDate?.date == date.date,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarDate extends StatelessWidget {
  const _CalendarDate({
    required this.date,
    required this.onTapDate,
    required this.dateTime,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  static final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final Date date;
  final Function(Date) onTapDate;
  final DateTime dateTime;
  final bool isSelected;

  bool get isSunday => dateTime.weekday == DateTime.sunday;

  Color get dateColor => isSelected
      ? Colors.blue
      : isSunday
          ? Colors.red
          : Colors.black;

  @override
  Widget build(BuildContext context) {
    return TouchBox(
      onTap: (box) {
        onTapDate(date);
      },
      child: SizedBox(
        width: 50,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.transparent,
              ),
              margin: const EdgeInsets.only(top: 12.0, bottom: 6.0),
              child: Center(
                child: Text(
                  dateTime.day.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: isSelected ? Colors.white : dateColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
                  ),
                ),
              ),
            ),
            Text(
              weekdays[dateTime.weekday - 1],
              style: smallTextStyle.copyWith(
                color: dateColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

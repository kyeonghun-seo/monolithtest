import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monolithtest/model/Date.dart';
import 'package:monolithtest/model/Ticket.dart';
import 'package:monolithtest/model/TicketTime.dart';

class ReservationContoller extends GetxController {
  static ReservationContoller get to => Get.find();

  List<Date> dates = [];
  Ticket? basicTicket;
  Ticket? sundayTicket;
  Ticket? selectedTicket;
  Date? selectedDate;
  TicketTime? selectedTicketTime;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchData() async {
    final basicString = await rootBundle.loadString('assets/datas/basic.json');
    final basicJson = json.decode(basicString);
    if (basicJson['code'] == 'EC200') {
      basicTicket = Ticket.fromJson(basicJson['data']);
    }

    final sundayString =
        await rootBundle.loadString('assets/datas/sunday.json');
    final sundayJson = json.decode(sundayString);
    if (sundayJson['code'] == 'EC200') {
      sundayTicket = Ticket.fromJson(sundayJson['data']);
    }

    final dateString = await rootBundle.loadString('assets/datas/date.json');
    final dateJson = json.decode(dateString);
    if (dateJson['code'] == 'EC200') {
      final dateDatas = dateJson['data'] as List<dynamic>;
      dates = dateDatas.map((e) => Date.fromJson(e)).toList();
    }

    if(dates.isNotEmpty) {
      selectDate(dates[0]);
    }else {
      update();
    }
  }

  Future<void> selectDate(Date date) async {
    selectedDate = date;
    if (DateTime.parse(date.date).weekday == DateTime.sunday) {
      selectedTicket = sundayTicket;
    } else {
      selectedTicket = basicTicket;
    }
    selectedTicketTime = null;
    update();
  }

  Future<void> selectTicketTime(TicketTime ticketTime) async {
    selectedTicketTime = ticketTime;
    update();
  }
}

import 'package:monolithtest/model/TicketTime.dart';

class Ticket {
  final double prdId;
  final String productName;
  final List<TicketTime> timeList;

  Ticket({
    required this.prdId,
    required this.productName,
    required this.timeList,
  });

  Ticket.fromJson(Map<String, dynamic> json)
      : prdId = json['prdId']?.toDouble() ?? 0,
        productName = json['productName']?.toString() ?? '',
        timeList = (json['timeList'] as List<dynamic>?)
                ?.map((e) => TicketTime.fromJson(e))
                .toList() ??
            [];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['prdId'] = prdId;
    data['productName'] = productName;
    data['timeList'] = timeList.map((e) => e.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return 'Product{prdId: $prdId, productName: $productName, timeList: $timeList}';
  }
}

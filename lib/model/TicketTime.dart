class TicketTime {
  final String timeSlot;
  final String stcDetailId;
  final bool stockUseYn;
  final bool enabled;
  final String stockStatusStr;

  TicketTime({
    required this.timeSlot,
    required this.stcDetailId,
    required this.stockUseYn,
    required this.enabled,
    required this.stockStatusStr,
  });

  TicketTime.fromJson(Map<String, dynamic> json) :
        timeSlot = json['timeSlot']?.toString() ?? '',
        stcDetailId = json['stcDetailId']?.toString() ?? '',
        stockUseYn = json['stockUseYn'] ?? false,
        enabled = json['enabled'] ?? false,
        stockStatusStr = json['stockStatusStr']?.toString() ?? '';

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['timeSlot'] = timeSlot;
    data['stcDetailId'] = stcDetailId;
    data['stockUseYn'] = stockUseYn;
    data['enabled'] = enabled;
    data['stockStatusStr'] = stockStatusStr;
    return data;
  }

  @override
  String toString() {
    return 'Item{timeSlot: $timeSlot, stcDetailId: $stcDetailId, stockUseYn: $stockUseYn, enabled: $enabled, stockStatusStr: $stockStatusStr}';
  }
}
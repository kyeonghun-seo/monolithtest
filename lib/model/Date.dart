class Date {
  final double dplId;
  final String date;
  final bool enabled;
  final bool holidayYn;

  Date({
    required this.dplId,
    required this.date,
    required this.enabled,
    required this.holidayYn,
  });

  Date.fromJson(Map<String, dynamic> json) :
    dplId = json['dplId']?.toDouble() ?? 0,
    date = json['date']?.toString() ?? '',
    enabled = json['enabled'] ?? false,
    holidayYn = json['holidayYn'] ?? false;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['dplId'] = dplId;
    data['date'] = date;
    data['enabled'] = enabled;
    data['holidayYn'] = holidayYn;
    return data;
  }

  @override
  String toString() {
    return 'Date{dplId: $dplId, date: $date, enabled: $enabled, holidayYn: $holidayYn}';
  }
}
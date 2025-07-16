class Holiday {
  final String id;
  final String title;
  final List<DateTime> dates;
  final String reason;

  Holiday({
    required this.id,
    required this.title,
    required this.dates,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dates': dates.map((d) => d.toIso8601String()).toList(),
      'reason': reason,
    };
  }

  factory Holiday.fromMap(Map<String, dynamic> map, String documentId) {
    return Holiday(
      id: documentId,
      title: map['title'] ?? '',
      dates: List<String>.from(map['dates'] ?? []).map((s) => DateTime.parse(s)).toList(),
      reason: map['reason'] ?? '',
    );
  }
}

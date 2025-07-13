class Holiday {

  final String title;
  final List<DateTime> dates;

  Holiday({
    required this.title,
    required this.dates
  });


  //Convert to Map (Firebase)

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dates': dates.map((d) => d.toIso8601String()).toList(),
    };
  }


// Create from Firestore Map
  factory Holiday.fromMap(Map<String, dynamic> map) {
    return Holiday(
      title: map['title'],
      dates: List<String>.from(map['dates'])
          .map((e) => DateTime.parse(e))
          .toList(),
    );
  }
}
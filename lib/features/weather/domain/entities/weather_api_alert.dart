class WeatherApiAlert {
  final String senderName;
  final String event;
  final int start;
  final int end;
  final String description;
  final List<String> tags;

  WeatherApiAlert({
    required this.senderName,
    required this.event,
    required this.start,
    required this.end,
    required this.description,
    required this.tags,
  });

  DateTime get startTime => DateTime.fromMillisecondsSinceEpoch(start * 1000);
  DateTime get endTime => DateTime.fromMillisecondsSinceEpoch(end * 1000);

  bool get isActive => DateTime.now().isBefore(endTime);
}

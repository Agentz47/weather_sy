class Forecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;

  Forecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
  });
}

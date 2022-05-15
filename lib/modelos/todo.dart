class Todo {
  Todo({required this.subtitle, required this.dateTime});

  Todo.fromJson(Map<String, dynamic> json)
      : subtitle = json['subtitle'],
        dateTime = DateTime.parse(json['datetime']);

  String subtitle;
  DateTime dateTime;

  toJson() {
    return {
      'subtitle': subtitle,
      'datetime': dateTime.toIso8601String(),
    };
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Exercise {
  String name;
  int repetitions;
  String imagePath;
  bool isTime;

  Exercise({required this.name, required this.repetitions, required this.imagePath, required this.isTime});

  Map<String, dynamic> toJson() => {
    'name': name,
    'repetitions': repetitions,
    'imagePath': imagePath,
    'isTime': isTime,
  };

  static Exercise fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    repetitions: json['repetitions'],
    imagePath: json['imagePath'],
    isTime: json['isTime'],
  );
}

const String prefSelectedTherapy = 'selectedTherapy';
const String therapyDefault = 'default';
const String therapyCustom = 'custom';

Future<void> saveExercises(List<Exercise> exercises) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonExercises = exercises.map((exercise) => json.encode(exercise.toJson())).toList();
  await prefs.setStringList('selectedExercises', jsonExercises);
}

Future<List<Exercise>> loadExercises() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonExercises = prefs.getStringList('selectedExercises') ?? [];
  return jsonExercises.map((jsonExercise) => Exercise.fromJson(json.decode(jsonExercise))).toList();
}

Future<void> saveDefaultExercises(List<Exercise> exercises) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonExercises = exercises.map((exercise) => json.encode(exercise.toJson())).toList();
  await prefs.setStringList('defaultExercises', jsonExercises);
}

Future<List<Exercise>> loadDefaultExercises() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> jsonExercises = prefs.getStringList('defaultExercises') ?? [];
  return jsonExercises.map((jsonExercise) => Exercise.fromJson(json.decode(jsonExercise))).toList();
}

List<Exercise> getDefaultExercises(int repetition) {
  return [
    Exercise(name: 'CalfRaises', repetitions: repetition, imagePath: 'lib/images/calfraises.png', isTime: false),
    Exercise(name: 'Time', repetitions: repetition * 3, imagePath: 'lib/images/time.png', isTime: true),
    Exercise(name: 'ToeCurls', repetitions: repetition, imagePath: 'lib/images/toecurls.png', isTime: false),
    Exercise(name: 'Time', repetitions: repetition * 3, imagePath: 'lib/images/time.png', isTime: true),
    Exercise(name: 'ToeStand', repetitions: repetition * 3, imagePath: 'lib/images/toestand.png', isTime: true),
  ];
}


Future<void> saveSelectedTherapy(String therapy) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(prefSelectedTherapy, therapy);
}

Future<String> loadSelectedTherapy() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(prefSelectedTherapy) ?? therapyDefault;
}
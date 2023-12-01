class Settings {
  final bool darkMode;

  Settings({required this.darkMode});

  // Convert a Settings instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
    };
  }

  // Construct a Settings instance from a Map
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      darkMode: json['darkMode'] as bool,
    );
  }
}

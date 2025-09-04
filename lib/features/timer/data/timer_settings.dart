class TimerSettings {
  final Duration pomodoroDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int longBreakInterval;

  const TimerSettings({
    required this.pomodoroDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.longBreakInterval,
  });

  factory TimerSettings.defaultSettings() {
    return const TimerSettings(
      pomodoroDuration: Duration(minutes: 25),
      shortBreakDuration: Duration(minutes: 5),
      longBreakDuration: Duration(minutes: 15),
      longBreakInterval: 4,
    );
  }

  TimerSettings copyWith({
    Duration? pomodoroDuration,
    Duration? shortBreakDuration,
    Duration? longBreakDuration,
    int? longBreakInterval,
  }) {
    return TimerSettings(
      pomodoroDuration: pomodoroDuration ?? this.pomodoroDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
    );
  }
}
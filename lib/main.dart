import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.redAccent,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent),
      ),
      home: const PomodoroScreen(),
    );
  }
}

enum PomodoroCycle {
  pomodoro,
  shortBreak,
  longBreak,
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  static const pomodoroDuration = Duration(minutes: 25);
  static const shortBreakDuration = Duration(minutes: 5);
  static const longBreakDuration = Duration(minutes: 15);

  late Duration currentDuration;
  late Duration remainingTime;
  Timer? timer;
  bool isRunning = false;
  int pomodoroCount = 0;
  PomodoroCycle _currentCycle = PomodoroCycle.pomodoro;

  @override
  void initState() {
    super.initState();
    currentDuration = pomodoroDuration;
    remainingTime = currentDuration;
  }

  void startTimer() {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime.inSeconds > 0) {
            remainingTime = remainingTime - const Duration(seconds: 1);
          } else {
            _handleTimerCompletion();
          }
        });
      });
    }
  }

  void pauseTimer() {
    if (isRunning) {
      setState(() {
        isRunning = false;
      });
      timer?.cancel();
    }
  }

  void resetTimer() {
    pauseTimer();
    setState(() {
      remainingTime = currentDuration;
    });
  }

  void _handleTimerCompletion() {
    pauseTimer();
    if (_currentCycle == PomodoroCycle.pomodoro) {
      pomodoroCount++;
      if (pomodoroCount % 4 == 0) {
        _setCycle(PomodoroCycle.longBreak);
      } else {
        _setCycle(PomodoroCycle.shortBreak);
      }
    } else {
      _setCycle(PomodoroCycle.pomodoro);
    }
    startTimer();
  }

  void _setCycle(PomodoroCycle cycle) {
    setState(() {
      _currentCycle = cycle;
      switch (cycle) {
        case PomodoroCycle.pomodoro:
          currentDuration = pomodoroDuration;
          break;
        case PomodoroCycle.shortBreak:
          currentDuration = shortBreakDuration;
          break;
        case PomodoroCycle.longBreak:
          currentDuration = longBreakDuration;
          break;
      }
      remainingTime = currentDuration;
    });
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        elevation: 0,
        backgroundColor: _getBackgroundColor(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: remainingTime.inSeconds / currentDuration.inSeconds,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(_getIndicatorColor()),
                  ),
                ),
                Text(
                  formatTime(remainingTime),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  text: isRunning ? 'Pause' : 'Start',
                  icon: isRunning ? Icons.pause : Icons.play_arrow,
                ),
                const SizedBox(width: 20),
                _buildControlButton(
                  onPressed: resetTimer,
                  text: 'Reset',
                  icon: Icons.refresh,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Pomodoro Sessions: $pomodoroCount',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({required VoidCallback onPressed, required String text, required IconData icon}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(text, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _getButtonColor(),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (_currentCycle) {
      case PomodoroCycle.pomodoro:
        return const Color(0xFF121212);
      case PomodoroCycle.shortBreak:
        return const Color(0xFF004D40);
      case PomodoroCycle.longBreak:
        return const Color(0xFF01579B);
    }
  }

  Color _getIndicatorColor() {
    switch (_currentCycle) {
      case PomodoroCycle.pomodoro:
        return Colors.redAccent;
      case PomodoroCycle.shortBreak:
        return Colors.tealAccent;
      case PomodoroCycle.longBreak:
        return Colors.lightBlueAccent;
    }
  }

  Color _getButtonColor() {
    switch (_currentCycle) {
      case PomodoroCycle.pomodoro:
        return Colors.redAccent;
      case PomodoroCycle.shortBreak:
        return Colors.teal;
      case PomodoroCycle.longBreak:
        return Colors.blue;
    }
  }

  String _getAppBarTitle() {
    switch (_currentCycle) {
      case PomodoroCycle.pomodoro:
        return 'Pomodoro';
      case PomodoroCycle.shortBreak:
        return 'Short Break';
      case PomodoroCycle.longBreak:
        return 'Long Break';
    }
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/animated_circular_progress.dart';
import '../data/timer_settings.dart';
import '../../settings/presentation/settings_screen.dart';

enum PomodoroCycle { pomodoro, shortBreak, longBreak }

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  late TimerSettings _settings;
  late Duration _currentDuration;
  late Duration _remainingTime;
  Timer? _timer;
  bool _isRunning = false;
  int _pomodoroCount = 0;
  PomodoroCycle _currentCycle = PomodoroCycle.pomodoro;

  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _settings = TimerSettings.defaultSettings();
    _updateCurrentDuration();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _scaleController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _updateCurrentDuration() {
    switch (_currentCycle) {
      case PomodoroCycle.pomodoro:
        _currentDuration = _settings.pomodoroDuration;
        break;
      case PomodoroCycle.shortBreak:
        _currentDuration = _settings.shortBreakDuration;
        break;
      case PomodoroCycle.longBreak:
        _currentDuration = _settings.longBreakDuration;
        break;
    }
    _remainingTime = _currentDuration;
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime.inSeconds > 0) {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
          } else {
            _handleTimerCompletion();
          }
        });
      });
    }
  }

  void _pauseTimer() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
      });
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    _pauseTimer();
    setState(() {
      _remainingTime = _currentDuration;
    });
    _scaleController.reset();
    _scaleController.forward();
  }

  void _handleTimerCompletion() {
    _pauseTimer();
    if (_currentCycle == PomodoroCycle.pomodoro) {
      _pomodoroCount++;
      if (_pomodoroCount % _settings.longBreakInterval == 0) {
        _setCycle(PomodoroCycle.longBreak);
      } else {
        _setCycle(PomodoroCycle.shortBreak);
      }
    } else {
      _setCycle(PomodoroCycle.pomodoro);
    }
    _startTimer();
  }

  void _setCycle(PomodoroCycle cycle) {
    _fadeController.reset();
    setState(() {
      _currentCycle = cycle;
      _updateCurrentDuration();
    });
    _fadeController.forward();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Color _getCycleColor() {
    switch (_currentCycle) {
      case PomodoroCycle.pomodoro:
        return AppTheme.getCycleColor('pomodoro');
      case PomodoroCycle.shortBreak:
        return AppTheme.getCycleColor('shortBreak');
      case PomodoroCycle.longBreak:
        return AppTheme.getCycleColor('longBreak');
    }
  }

  String _getCycleTitle() {
    switch (_currentCycle) {
      case PomodoroCycle.pomodoro:
        return 'Focus Time';
      case PomodoroCycle.shortBreak:
        return 'Short Break';
      case PomodoroCycle.longBreak:
        return 'Long Break';
    }
  }

  void _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          currentSettings: _settings,
          onSettingsChanged: (newSettings) {
            setState(() {
              _settings = newSettings;
              _updateCurrentDuration();
              _resetTimer();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _currentDuration.inSeconds > 0
        ? (_currentDuration.inSeconds - _remainingTime.inSeconds) / _currentDuration.inSeconds
        : 0.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_getCycleTitle()),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedCircularProgress(
                      progress: progress,
                      timeText: _formatTime(_remainingTime),
                      progressColor: _getCycleColor(),
                      backgroundColor: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 60),
                    _buildControlButtons(),
                    const SizedBox(height: 40),
                    _buildSessionInfo(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: _isRunning ? _pauseTimer : _startTimer,
          icon: Icon(_isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
          label: Text(_isRunning ? 'Pause' : 'Start'),
          style: FilledButton.styleFrom(
            backgroundColor: _getCycleColor(),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton.icon(
          onPressed: _resetTimer,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Reset'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _getCycleColor()),
            foregroundColor: _getCycleColor(),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: _getCycleColor(),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            'Sessions Completed: $_pomodoroCount',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
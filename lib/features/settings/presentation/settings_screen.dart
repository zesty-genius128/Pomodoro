import 'package:flutter/material.dart';
import '../../timer/data/timer_settings.dart';

class SettingsScreen extends StatefulWidget {
  final TimerSettings currentSettings;
  final Function(TimerSettings) onSettingsChanged;

  const SettingsScreen({
    super.key,
    required this.currentSettings,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late TimerSettings _settings;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _settings = widget.currentSettings;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Settings'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _settings = TimerSettings.defaultSettings();
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _animationController.value)),
            child: Opacity(
              opacity: _animationController.value,
              child: child,
            ),
          );
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTimerCard(
              'Pomodoro',
              _settings.pomodoroDuration,
              Colors.red,
              (duration) => _settings = _settings.copyWith(pomodoroDuration: duration),
            ),
            const SizedBox(height: 16),
            _buildTimerCard(
              'Short Break',
              _settings.shortBreakDuration,
              Colors.teal,
              (duration) => _settings = _settings.copyWith(shortBreakDuration: duration),
            ),
            const SizedBox(height: 16),
            _buildTimerCard(
              'Long Break',
              _settings.longBreakDuration,
              Colors.blue,
              (duration) => _settings = _settings.copyWith(longBreakDuration: duration),
            ),
            const SizedBox(height: 16),
            _buildIntervalCard(),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () {
                widget.onSettingsChanged(_settings);
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCard(
    String title,
    Duration duration,
    Color color,
    Function(Duration) onChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${duration.inMinutes} minutes',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: duration.inMinutes > 1
                          ? () {
                              setState(() {
                                onChanged(Duration(minutes: duration.inMinutes - 1));
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: color.withOpacity(0.1),
                        foregroundColor: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: duration.inMinutes < 60
                          ? () {
                              setState(() {
                                onChanged(Duration(minutes: duration.inMinutes + 1));
                              });
                            }
                          : null,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: color.withOpacity(0.1),
                        foregroundColor: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.repeat, color: Colors.orange),
                const SizedBox(width: 12),
                Text(
                  'Long Break Interval',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Take a long break after every ${_settings.longBreakInterval} pomodoros',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_settings.longBreakInterval} sessions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: _settings.longBreakInterval > 2
                          ? () {
                              setState(() {
                                _settings = _settings.copyWith(
                                  longBreakInterval: _settings.longBreakInterval - 1,
                                );
                              });
                            }
                          : null,
                      icon: const Icon(Icons.remove),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.orange.withOpacity(0.1),
                        foregroundColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _settings.longBreakInterval < 8
                          ? () {
                              setState(() {
                                _settings = _settings.copyWith(
                                  longBreakInterval: _settings.longBreakInterval + 1,
                                );
                              });
                            }
                          : null,
                      icon: const Icon(Icons.add),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.orange.withOpacity(0.1),
                        foregroundColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
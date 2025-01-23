import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(PomodoroTimerApp());

class PomodoroTimerApp extends StatelessWidget {
  const PomodoroTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PomodoroTimerScreen(),
    );
  }
}

class PomodoroTimerScreen extends StatefulWidget {
  const PomodoroTimerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PomodoroTimerScreenState createState() => _PomodoroTimerScreenState();
}

class _PomodoroTimerScreenState extends State<PomodoroTimerScreen> {
  int _selectedMinutes = 25;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _remainingSeconds = _selectedMinutes * 60;
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });
      }
    });
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _remainingSeconds = 0;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timeString = _remainingSeconds > 0
        ? _formatTime(_remainingSeconds)
        : _formatTime(_selectedMinutes * 60);

    final progress = _remainingSeconds > 0
        ? _remainingSeconds / (_selectedMinutes * 60)
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Pomodoro Timer'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
              Text(
                timeString,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          if (!_isRunning)
            Column(
              children: [
                Text(
                  'Select Timer Duration (minutes):',
                  style: TextStyle(fontSize: 16),
                ),
                Slider(
                  value: _selectedMinutes.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 59,
                  label: _selectedMinutes.toString(),
                  activeColor: Colors.purple,
                  onChanged: (value) {
                    setState(() {
                      _selectedMinutes = value.toInt();
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Start',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pauseTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Pause',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

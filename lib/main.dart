import 'package:flutter/material.dart';
import 'timer_state.dart';
import 'timer_screen.dart';

void main() {
  runApp(const TimelessApp());
}

class TimelessApp extends StatefulWidget {
  const TimelessApp({Key? key}) : super(key: key);

  @override
  State<TimelessApp> createState() => _TimelessAppState();
}

class _TimelessAppState extends State<TimelessApp> {
  final TimerState _timerState = TimerState();

  @override
  void dispose() {
    _timerState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timeless',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter', // Default clean font, works natively or falls back beautifully
      ),
      home: TimerScreen(state: _timerState),
    );
  }
}

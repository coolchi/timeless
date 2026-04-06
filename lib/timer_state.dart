import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerState extends ChangeNotifier {
  Timer? _timer;
  
  // High precision tracking
  DateTime? _lastTickTime;
  
  Duration _totalDuration = const Duration(minutes: 5);
  Duration _currentDuration = const Duration(minutes: 5);
  bool _isRunning = false;

  final List<Duration> presets = const [
    Duration(minutes: 1),
    Duration(minutes: 3),
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(minutes: 25),
    Duration(minutes: 60),
  ];

  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  bool get isRunning => _isRunning;
  
  double get progress => _totalDuration.inMilliseconds == 0 
      ? 0.0 
      : 1.0 - (_currentDuration.inMilliseconds / _totalDuration.inMilliseconds);

  void setPreset(Duration preset) {
    _timer?.cancel();
    _isRunning = false;
    _totalDuration = preset;
    _currentDuration = preset;
    notifyListeners();
  }

  void start() {
    if (_isRunning || _currentDuration.inMilliseconds <= 0) return;
    
    _isRunning = true;
    _lastTickTime = DateTime.now();
    _timer = Timer.periodic(const Duration(milliseconds: 16), _tick); // ~60fps smooth updates
    notifyListeners();
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    pause();
    _currentDuration = _totalDuration;
    notifyListeners();
  }

  void _tick(Timer timer) {
    final now = DateTime.now();
    final delta = now.difference(_lastTickTime!);
    _lastTickTime = now;

    if (_currentDuration - delta <= Duration.zero) {
      _currentDuration = Duration.zero;
      pause();
    } else {
      _currentDuration -= delta;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

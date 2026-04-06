import 'dart:math';
import 'package:flutter/material.dart';
import 'timer_state.dart';
import 'glass_card.dart';

class TimerScreen extends StatefulWidget {
  final TimerState state;

  const TimerScreen({Key? key, required this.state}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final millis = (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$millis';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback
      body: Stack(
        children: [
          const AnimatedMeshGradient(),
          SafeArea(
            child: AnimatedBuilder(
              animation: widget.state,
              builder: (context, _) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isPortrait = constraints.maxHeight > constraints.maxWidth;
                    
                    if (isPortrait) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildHeader(),
                          _buildTimerDisplay(),
                          _buildControls(),
                          _buildPresets(),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildHeader(),
                                SizedBox(height: 30),
                                _buildTimerDisplay(),
                                SizedBox(height: 40),
                                _buildControls(),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: _buildPresets(),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        'TIMELESS',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 8.0,
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: 300,
            height: 300,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 8,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          // Active ring
          SizedBox(
            width: 300,
            height: 300,
            child: CircularProgressIndicator(
              value: widget.state.progress,
              strokeWidth: 8,
              color: Colors.cyanAccent,
              backgroundColor: Colors.transparent,
            ),
          ),
          // Glass effect inner circle
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.2 * max(0, widget.state.progress)),
                  blurRadius: 50,
                  spreadRadius: 10,
                )
              ]
            ),
            child: GlassCard(
              borderRadius: BorderRadius.circular(150),
              padding: EdgeInsets.zero,
              child: Center(
                child: Text(
                  _formatDuration(widget.state.currentDuration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 54,
                    fontWeight: FontWeight.w200,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGlassButton(
          icon: Icons.refresh,
          onTap: widget.state.reset,
        ),
        const SizedBox(width: 32),
        _buildGlassButton(
          icon: widget.state.isRunning ? Icons.pause : Icons.play_arrow,
          onTap: widget.state.isRunning ? widget.state.pause : widget.state.start,
          isLarge: true,
        ),
      ],
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isLarge = false,
  }) {
    final size = isLarge ? 80.0 : 60.0;
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: BorderRadius.circular(size / 2),
        padding: EdgeInsets.zero,
        opacity: 0.15,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: Colors.white,
            size: isLarge ? 40 : 28,
          ),
        ),
      ),
    );
  }

  Widget _buildPresets() {
    return GlassCard(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'PRESETS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              letterSpacing: 4.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: widget.state.presets.map((preset) {
              final isSelected = widget.state.totalDuration == preset;
              return GestureDetector(
                onTap: () => widget.state.setPreset(preset),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.cyanAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.cyanAccent : Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    '${preset.inMinutes}m',
                    style: TextStyle(
                      color: isSelected ? Colors.cyanAccent : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

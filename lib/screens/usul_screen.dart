import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../models/usul_model.dart';
import '../widgets/usul_pattern_display.dart';

class UsulScreen extends StatefulWidget {
  const UsulScreen({super.key});

  @override
  State<UsulScreen> createState() => _UsulScreenState();
}

class _UsulScreenState extends State<UsulScreen> {
  int _selectedUsulIndex = 0;
  double _bpm = 90;
  bool _isPlaying = false;
  int _activeBeatIndex = -1;
  Timer? _timer;

  Usul get _currentUsul => usuller[_selectedUsulIndex];

  void _startMetronome() {
    _stopMetronome();
    setState(() { _isPlaying = true; _activeBeatIndex = 0; });

    final intervalMs = (60000 / _bpm).round();
    _triggerBeat(0);

    _timer = Timer.periodic(Duration(milliseconds: intervalMs), (timer) {
      if (!mounted) { timer.cancel(); return; }
      final nextBeat = (_activeBeatIndex + 1) % _currentUsul.pattern.length;
      _triggerBeat(nextBeat);
    });
  }

  void _triggerBeat(int index) {
    final beat = _currentUsul.pattern[index];
    if (beat.type == "dum") {
      HapticFeedback.heavyImpact();
    } else if (beat.type == "tek") {
      HapticFeedback.lightImpact();
    }
    if (mounted) setState(() => _activeBeatIndex = index);
  }

  void _stopMetronome() {
    _timer?.cancel();
    _timer = null;
    if (mounted) setState(() { _isPlaying = false; _activeBeatIndex = -1; });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Başlık ===
              const Text("USUL METRONOM", style: TextStyle(letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryText)),
              const SizedBox(height: 4),
              const Text("Klasik Türk müziği ritim kalıpları.", style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
              const SizedBox(height: 16),

              // === Usul Seçici ===
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: usuller.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedUsulIndex;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        _stopMetronome();
                        setState(() => _selectedUsulIndex = index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.usulDum.withOpacity(0.12) : AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isSelected ? AppColors.usulDum : AppColors.border),
                        ),
                        child: Text(
                          usuller[index].name,
                          style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppColors.usulDum : AppColors.primaryText),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // === Usul Bilgi Kartı ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.usulDum.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _currentUsul.timeSignature,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: AppColors.usulDum),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_currentUsul.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                          const SizedBox(height: 3),
                          Text(_currentUsul.description, style: const TextStyle(fontSize: 10.5, color: AppColors.secondaryText, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // === Vuruş Gösterimi ===
              Expanded(
                child: Center(
                  child: UsulPatternDisplay(
                    usul: _currentUsul,
                    activeBeatIndex: _activeBeatIndex,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // === BPM Kontrolü ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TEMPO", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.secondaryText)),
                        Text("${_bpm.toInt()} BPM", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w200, color: AppColors.primaryText)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.usulDum,
                        inactiveTrackColor: AppColors.borderLight,
                        thumbColor: AppColors.usulDum,
                        overlayColor: AppColors.usulDum.withOpacity(0.1),
                        trackHeight: 2,
                      ),
                      child: Slider(
                        value: _bpm,
                        min: 40,
                        max: 200,
                        divisions: 160,
                        onChanged: (v) {
                          setState(() => _bpm = v);
                          if (_isPlaying) _startMetronome();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("40", style: TextStyle(fontSize: 9, color: AppColors.tertiaryText)),
                        Row(
                          children: [
                            _tempoPreset("Ağır", 60),
                            const SizedBox(width: 8),
                            _tempoPreset("Orta", 90),
                            const SizedBox(width: 8),
                            _tempoPreset("Hızlı", 130),
                          ],
                        ),
                        Text("200", style: TextStyle(fontSize: 9, color: AppColors.tertiaryText)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // === Başlat / Durdur ===
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPlaying ? AppColors.warningRed.withOpacity(0.2) : AppColors.usulDum.withOpacity(0.15),
                    foregroundColor: _isPlaying ? AppColors.warningRed : AppColors.usulDum,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    _isPlaying ? _stopMetronome() : _startMetronome();
                  },
                  child: Text(
                    _isPlaying ? "DURDUR" : "BAŞLAT",
                    style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 2, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tempoPreset(String label, double bpm) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _bpm = bpm);
        if (_isPlaying) _startMetronome();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Text(label, style: const TextStyle(fontSize: 9, color: AppColors.secondaryText)),
      ),
    );
  }
}

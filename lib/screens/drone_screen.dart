import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/turkish_pitches.dart';

/// Taksim ve makam pratiği için sürekli karar sesi (drone/dem) üreten ekran.
/// NOT: Gerçek ses üretimi `just_audio` veya platform kanalı ile yapılır.
/// Bu aşamada UI tamamen fonksiyonel olup ses üretimi entegrasyona hazırdır.
class DroneScreen extends StatefulWidget {
  const DroneScreen({super.key});

  @override
  State<DroneScreen> createState() => _DroneScreenState();
}

class _DroneScreenState extends State<DroneScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPitchIndex = 0;
  bool _isPlaying = false;
  double _volume = 0.6;
  int _waveType = 0; // 0=Sinüs, 1=Üçgen, 2=Tanbur
  double _a4Freq = 440.0;

  late AnimationController _pulseController;

  final List<String> _waveLabels = ["Sinüs", "Üçgen", "Tanbur"];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  TurkishPitch get _currentPitch => dronePitches[_selectedPitchIndex];
  double get _currentFreq => _currentPitch.frequencyForA4(_a4Freq);

  void _toggleDrone() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _pulseController.repeat(reverse: true);
        // TODO: just_audio ile ses üretimi başlat
        // _audioPlayer.setFrequency(_currentFreq);
        // _audioPlayer.play();
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
        // TODO: just_audio ile ses üretimini durdur
        // _audioPlayer.stop();
      }
    });
  }

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
              const Text("DEM (DRONE)", style: TextStyle(letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryText)),
              const SizedBox(height: 4),
              const Text("Taksim ve makam pratiği için sürekli karar sesi.", style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
              const SizedBox(height: 20),

              // === Merkez: Perde Gösterimi ===
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dalga tipi seçici
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          final isSelected = i == _waveType;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () { HapticFeedback.selectionClick(); setState(() => _waveType = i); },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.dronePrimary.withOpacity(0.15) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: isSelected ? AppColors.dronePrimary : AppColors.border),
                                ),
                                child: Text(_waveLabels[i], style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppColors.droneWave : AppColors.secondaryText)),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 32),

                      // Ana drone butonu / perde gösterimi
                      GestureDetector(
                        onTap: _toggleDrone,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final pulseScale = _isPlaying ? 1.0 + (_pulseController.value * 0.08) : 1.0;
                            final glowOpacity = _isPlaying ? 0.15 + (_pulseController.value * 0.15) : 0.0;

                            return Transform.scale(
                              scale: pulseScale,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.surface,
                                  border: Border.all(
                                    color: _isPlaying ? AppColors.droneWave : AppColors.borderLight,
                                    width: _isPlaying ? 2.5 : 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.droneWave.withOpacity(glowOpacity),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentPitch.name,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w300,
                                        color: _isPlaying ? AppColors.droneWave : AppColors.primaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentPitch.westernApprox,
                                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${_currentFreq.toStringAsFixed(1)} Hz",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _isPlaying ? AppColors.droneWave : AppColors.accentAmber,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Icon(
                                      _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                                      size: 28,
                                      color: _isPlaying ? AppColors.droneWave : AppColors.secondaryText,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isPlaying ? "Dokunarak durdurun" : "Dokunarak başlatın",
                        style: TextStyle(fontSize: 10, color: AppColors.tertiaryText),
                      ),
                    ],
                  ),
                ),
              ),

              // === Volüm Kontrolü ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.volume_down_rounded, size: 18, color: AppColors.tertiaryText),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.dronePrimary,
                          inactiveTrackColor: AppColors.borderLight,
                          thumbColor: AppColors.droneWave,
                          overlayColor: AppColors.droneWave.withOpacity(0.1),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: _volume,
                          min: 0,
                          max: 1,
                          onChanged: (v) => setState(() => _volume = v),
                        ),
                      ),
                    ),
                    Icon(Icons.volume_up_rounded, size: 18, color: AppColors.secondaryText),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // === Perde Seçici ===
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(dronePitches.length, (i) {
                    final isSelected = i == _selectedPitchIndex;
                    final pitch = dronePitches[i];
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedPitchIndex = i);
                        // TODO: Drone çalıyorsa frekansı güncelle
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.dronePrimary.withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSelected ? AppColors.droneWave : Colors.transparent, width: isSelected ? 1.5 : 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(pitch.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? AppColors.primaryText : AppColors.secondaryText)),
                            const SizedBox(height: 2),
                            Text(pitch.frequencyForA4(_a4Freq).toStringAsFixed(0), style: TextStyle(fontSize: 8, color: isSelected ? AppColors.droneWave : AppColors.tertiaryText)),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

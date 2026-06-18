import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector_dart.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/oud_frequencies.dart';
import '../core/utils/cents_calculator.dart';
import '../widgets/needle_gauge.dart';
import '../widgets/wave_visualizer.dart';

class TunerScreen extends StatefulWidget {
  const TunerScreen({super.key});

  @override
  State<TunerScreen> createState() => _TunerScreenState();
}

class _TunerScreenState extends State<TunerScreen> {
  final _audioCapture = FlutterAudioCapture();
  late PitchDetector _pitchDetector;

  bool _isRecording = false;
  double _currentFrequency = 0.0;
  double _amplitude = 0.0;
  String _statusMessage = "Mikrofon başlatılıyor...";

  OudString? _detectedString;
  double _centsDeviation = 0.0;
  bool _isInTune = false;
  bool _autoMode = true;
  OudString _selectedManualString = bolahenk[0];

  // A4 Kalibrasyonu ve Âhenk
  double _a4Freq = 440.0;
  int _selectedAhenkIndex = 0; // 0 = Bolahenk

  bool _hapticTriggered = false;

  @override
  void initState() {
    super.initState();
    _pitchDetector = PitchDetector(44100, 2048);
    _initTuner();
  }

  Ahenk get _currentAhenk => ahenkler[_selectedAhenkIndex];

  /// Seçili âhenk ve A4 kalibrasyonuna göre aktif hedef frekansları hesaplar.
  List<double> get _activeFrequencies => calculateFrequencies(_currentAhenk, _a4Freq);

  Future<void> _initTuner() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      _startTuner();
    } else {
      setState(() => _statusMessage = "Akort yapmak için mikrofon izni gereklidir.");
    }
  }

  void _startTuner() async {
    try {
      await _audioCapture.start(_onAudioData, _onAudioError, sampleRate: 44100, bufferSize: 2048);
      setState(() {
        _isRecording = true;
        _statusMessage = "Dinleniyor...";
      });
    } catch (e) {
      setState(() => _statusMessage = "Ses yakalama başlatılamadı.");
    }
  }

  void _onAudioData(dynamic audioData) {
    final List<double> buffer = List<double>.from(audioData);

    // Amplitude hesabı (ses şiddeti göstergesi için)
    double maxVal = 0;
    for (final s in buffer) {
      if (s.abs() > maxVal) maxVal = s.abs();
    }

    final result = _pitchDetector.detectPitch(buffer);
    if (result.pitched && result.pitch > 50.0 && result.pitch < 400.0) {
      _processPitch(result.pitch, maxVal.clamp(0.0, 1.0));
    } else {
      if (mounted) setState(() => _amplitude = maxVal.clamp(0.0, 1.0) * 0.3);
    }
  }

  void _onAudioError(Object error) => debugPrint("Ses hatası: $error");

  void _processPitch(double pitch, double amp) {
    final freqs = _activeFrequencies;

    OudString closest;
    double targetFreq;

    if (_autoMode) {
      int closestIdx = 0;
      double minDist = double.infinity;
      for (int i = 0; i < bolahenk.length; i++) {
        final dist = (pitch - freqs[i]).abs();
        if (dist < minDist) {
          minDist = dist;
          closestIdx = i;
        }
      }
      closest = bolahenk[closestIdx];
      targetFreq = freqs[closestIdx];
    } else {
      closest = _selectedManualString;
      targetFreq = _currentAhenk.transpose(closest.frequencyForA4(_a4Freq));
    }

    final cents = CentsCalculator.calculateCents(pitch, targetFreq);
    final inTune = cents.abs() <= 3.0;

    if (inTune && !_hapticTriggered) {
      HapticFeedback.mediumImpact();
      _hapticTriggered = true;
    } else if (!inTune) {
      _hapticTriggered = false;
    }

    if (mounted) {
      setState(() {
        _currentFrequency = pitch;
        _detectedString = closest;
        _centsDeviation = cents.clamp(-50.0, 50.0);
        _isInTune = inTune;
        _amplitude = amp;
      });
    }
  }

  void _stopTuner() async {
    await _audioCapture.stop();
    if (mounted) setState(() { _isRecording = false; _statusMessage = "Durduruldu"; });
  }

  @override
  void dispose() { _stopTuner(); super.dispose(); }

  void _showA4Dialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        double tempA4 = _a4Freq;
        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 20),
                const Text("A4 KALİBRASYONU", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.primaryText)),
                const SizedBox(height: 8),
                Text("${tempA4.toStringAsFixed(1)} Hz", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w200, color: AppColors.accentAmber)),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.accentAmber,
                    inactiveTrackColor: AppColors.borderLight,
                    thumbColor: AppColors.accentAmber,
                    overlayColor: AppColors.accentAmber.withOpacity(0.1),
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: tempA4,
                    min: 428.0,
                    max: 452.0,
                    divisions: 48,
                    onChanged: (v) => setSheetState(() => tempA4 = v),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("428 Hz", style: TextStyle(fontSize: 10, color: AppColors.tertiaryText)),
                    TextButton(
                      onPressed: () => setSheetState(() => tempA4 = 440.0),
                      child: const Text("440 Hz (Standart)", style: TextStyle(fontSize: 10, color: AppColors.accentAmber)),
                    ),
                    Text("452 Hz", style: TextStyle(fontSize: 10, color: AppColors.tertiaryText)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentAmber.withOpacity(0.15),
                      foregroundColor: AppColors.accentAmber,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      setState(() => _a4Freq = tempA4);
                      Navigator.pop(context);
                    },
                    child: const Text("UYGULA", style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final freqs = _activeFrequencies;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // === Üst Çubuk: Başlık + Mod + A4 ===
              Row(
                children: [
                  const Text("UD AKORT", style: TextStyle(letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryText)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () { HapticFeedback.selectionClick(); setState(() => _autoMode = !_autoMode); },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
                      child: Text(_autoMode ? "OTO" : "MANUEL", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1, color: AppColors.accentAmber)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: _showA4Dialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
                      child: Text("A4: ${_a4Freq.toStringAsFixed(0)}", style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.secondaryText)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // === Âhenk Seçici ===
              SizedBox(
                height: 32,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ahenkler.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedAhenkIndex;
                    return GestureDetector(
                      onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedAhenkIndex = index); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accentAmber.withOpacity(0.12) : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSelected ? AppColors.accentAmber : AppColors.border),
                        ),
                        child: Text(ahenkler[index].name, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppColors.accentAmber : AppColors.secondaryText)),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(flex: 2),

              // === İbre Kadranı ===
              SizedBox(
                height: 200,
                width: double.infinity,
                child: CustomPaint(
                  painter: NeedleGaugePainter(centsDeviation: _centsDeviation, isInTune: _isInTune),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 36),
                        // Glow efekti
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: _isInTune ? BoxDecoration(
                            boxShadow: [BoxShadow(color: AppColors.accentOlive.withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                          ) : null,
                          child: Text(
                            _detectedString?.noteName ?? "--",
                            style: TextStyle(fontSize: 52, fontWeight: FontWeight.w300, color: _isInTune ? AppColors.accentOlive : AppColors.primaryText),
                          ),
                        ),
                        Text(
                          _detectedString != null ? "${_detectedString!.westernNote}  |  ${_currentFrequency.toStringAsFixed(1)} Hz" : "-- Hz",
                          style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                        ),
                        const SizedBox(height: 6),
                        if (_detectedString != null)
                          Text(
                            _isInTune ? "MÜKEMMEL" : "${_centsDeviation > 0 ? "+" : ""}${_centsDeviation.toStringAsFixed(0)} cent",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: _isInTune ? AppColors.accentOlive : AppColors.accentAmber),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),

              // === Dalga Gösterimi ===
              WaveVisualizer(amplitude: _amplitude, isActive: _isRecording, color: _isInTune ? AppColors.accentOlive : AppColors.accentAmber),
              const SizedBox(height: 16),

              // === Tel Seçici ===
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(bolahenk.length, (i) {
                    final string = bolahenk[i];
                    final isSelected = _autoMode ? _detectedString?.index == string.index : _selectedManualString.index == string.index;
                    final targetHz = freqs[i];

                    return GestureDetector(
                      onTap: () {
                        if (!_autoMode) {
                          HapticFeedback.selectionClick();
                          setState(() { _selectedManualString = string; _detectedString = string; _centsDeviation = 0; _isInTune = false; });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 62,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (_isInTune ? AppColors.accentOlive.withOpacity(0.15) : AppColors.accentAmber.withOpacity(0.1))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? (_isInTune ? AppColors.accentOlive : AppColors.accentAmber) : Colors.transparent,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(string.noteName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? AppColors.primaryText : AppColors.secondaryText)),
                            const SizedBox(height: 2),
                            Text(targetHz.toStringAsFixed(0), style: TextStyle(fontSize: 8, color: isSelected ? AppColors.accentAmber : AppColors.tertiaryText)),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
              // Durum
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: _isRecording ? AppColors.accentOlive : AppColors.warningRed),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${_currentAhenk.name} · $_statusMessage",
                    style: const TextStyle(fontSize: 10, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

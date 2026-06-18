import 'dart:math';

/// AEU (Arel-Ezgi-Uzdilek) sistemiyle bir oktavda 24 ana perde.
/// Her perde Rast'tan itibaren koma cinsinden ofseti ve A4=440 Hz Bolahenk
/// düzeninde duyulan referans frekansı ile tanımlanır.
class TurkishPitch {
  final String name;           // Geleneksel perde adı
  final String westernApprox;  // Yaklaşık batı karşılığı
  final int commaFromRast;     // Rast perdesinden itibaren koma ofseti (0-53)
  final double baseFrequency;  // A4=440, Bolahenk düzeninde referans frekansı (Hz)

  const TurkishPitch({
    required this.name,
    required this.westernApprox,
    required this.commaFromRast,
    required this.baseFrequency,
  });

  /// Frekansı A4 kalibrasyonuna göre ölçekler.
  double frequencyForA4(double a4Freq) => baseFrequency * (a4Freq / 440.0);
}

/// Bir tam oktav (Rast → Gerdaniye) 24 AEU perdesi.
/// Frekanslar Rast = ~293.66 Hz (D4, Bolahenk) üzerinden hesaplanır.
const List<TurkishPitch> aeuPitches = [
  TurkishPitch(name: "Rast",        westernApprox: "Sol / G",    commaFromRast: 0,  baseFrequency: 293.66),
  TurkishPitch(name: "Şuri",        westernApprox: "Sol# ↓ / G#↓", commaFromRast: 1, baseFrequency: 297.50),
  TurkishPitch(name: "Zengüle",     westernApprox: "La♭ ↓ / A♭↓", commaFromRast: 4,  baseFrequency: 308.40),
  TurkishPitch(name: "Dügâh",       westernApprox: "La / A",     commaFromRast: 9,  baseFrequency: 329.63),
  TurkishPitch(name: "Kürdî",       westernApprox: "Si♭ / B♭",   commaFromRast: 13, baseFrequency: 341.20),
  TurkishPitch(name: "Segâh",       westernApprox: "Si ↓ / B↓",  commaFromRast: 17, baseFrequency: 352.40),
  TurkishPitch(name: "Buselik",     westernApprox: "Si / B",     commaFromRast: 18, baseFrequency: 356.00),
  TurkishPitch(name: "Çârgâh",      westernApprox: "Do / C",     commaFromRast: 22, baseFrequency: 369.99),
  TurkishPitch(name: "Nim Hicaz",   westernApprox: "Do# / C#",   commaFromRast: 26, baseFrequency: 384.87),
  TurkishPitch(name: "Hicaz",       westernApprox: "Re♭ ↑ / D♭↑",commaFromRast: 27, baseFrequency: 388.50),
  TurkishPitch(name: "Sabâ",        westernApprox: "Re ↓ / D↓",  commaFromRast: 30, baseFrequency: 403.00),
  TurkishPitch(name: "Nevâ",        westernApprox: "Re / D",     commaFromRast: 31, baseFrequency: 440.00),
  TurkishPitch(name: "Bayâtî",      westernApprox: "Mi♭ ↓ / E♭↓",commaFromRast: 35, baseFrequency: 457.69),
  TurkishPitch(name: "Hisar",       westernApprox: "Mi♭ / E♭",   commaFromRast: 36, baseFrequency: 462.50),
  TurkishPitch(name: "Hüseynî",     westernApprox: "Mi / E",     commaFromRast: 40, baseFrequency: 493.88),
  TurkishPitch(name: "Acem",        westernApprox: "Fa / F",     commaFromRast: 44, baseFrequency: 523.25),
  TurkishPitch(name: "Dik Acem",    westernApprox: "Fa# ↓ / F#↓",commaFromRast: 48, baseFrequency: 544.20),
  TurkishPitch(name: "Eviç",        westernApprox: "Fa# / F#",   commaFromRast: 49, baseFrequency: 548.80),
  TurkishPitch(name: "Mâhur",       westernApprox: "Sol♭ / G♭",  commaFromRast: 50, baseFrequency: 553.40),
  TurkishPitch(name: "Gerdaniye",   westernApprox: "Sol / G",    commaFromRast: 53, baseFrequency: 587.33),
];

/// Drone için kullanılabilecek temel karar perdeleri (en yaygın 6 perde).
const List<TurkishPitch> dronePitches = [
  TurkishPitch(name: "Rast",    westernApprox: "Sol / G",  commaFromRast: 0,  baseFrequency: 293.66),
  TurkishPitch(name: "Dügâh",   westernApprox: "La / A",   commaFromRast: 9,  baseFrequency: 329.63),
  TurkishPitch(name: "Segâh",   westernApprox: "Si↓ / B↓", commaFromRast: 17, baseFrequency: 352.40),
  TurkishPitch(name: "Çârgâh",  westernApprox: "Do / C",   commaFromRast: 22, baseFrequency: 369.99),
  TurkishPitch(name: "Nevâ",    westernApprox: "Re / D",   commaFromRast: 31, baseFrequency: 440.00),
  TurkishPitch(name: "Hüseynî", westernApprox: "Mi / E",   commaFromRast: 40, baseFrequency: 493.88),
];

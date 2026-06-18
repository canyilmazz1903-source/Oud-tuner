import 'dart:math';

class OudString {
  final int index;
  final String noteName;
  final String westernNote;
  final double baseFrequency; // Bolahenk, A4=440 referanslı baz frekans

  const OudString({
    required this.index,
    required this.noteName,
    required this.westernNote,
    required this.baseFrequency,
  });

  /// A4 kalibrasyonuna göre dinamik frekans hesabı.
  /// [a4Freq]: Kullanıcının ayarladığı A4 referans frekansı (varsayılan 440 Hz).
  /// Formül: f_new = f_base * (a4Freq / 440.0)
  double frequencyForA4(double a4Freq) {
    return baseFrequency * (a4Freq / 440.0);
  }
}

/// Bolahenk düzeni (Standart Türk Ud Akordu) — A4 = 440 Hz baz alınarak.
const List<OudString> bolahenk = [
  OudString(index: 1, noteName: "Sol", westernNote: "D4", baseFrequency: 293.66),
  OudString(index: 2, noteName: "Re", westernNote: "A3", baseFrequency: 220.00),
  OudString(index: 3, noteName: "La", westernNote: "E3", baseFrequency: 164.81),
  OudString(index: 4, noteName: "Mi", westernNote: "B2", baseFrequency: 123.47),
  OudString(index: 5, noteName: "Si", westernNote: "F#2", baseFrequency: 92.50),
  OudString(index: 6, noteName: "Fa#", westernNote: "C#2", baseFrequency: 69.30),
];

/// Âhenk (Transpozisyon) Sistemleri
/// Her âhenk, Bolahenk frekanslarına uygulanan bir yarım-ton ofseti olarak tanımlanır.
class Ahenk {
  final String name;
  final String description;
  final int semitoneOffset; // Bolahenk'e göre yarım ton farkı

  const Ahenk({
    required this.name,
    required this.description,
    required this.semitoneOffset,
  });

  /// Bir baz frekansı bu âhenk'e göre transpoze eder.
  double transpose(double baseFreq) {
    return baseFreq * pow(2, semitoneOffset / 12.0);
  }
}

const List<Ahenk> ahenkler = [
  Ahenk(name: "Bolahenk", description: "Standart akort — Ana âhenk", semitoneOffset: 0),
  Ahenk(name: "Süpürde", description: "Bolahenk'ten 2 yarım ton tiz", semitoneOffset: 2),
  Ahenk(name: "Mansur", description: "Bolahenk'ten 3 yarım ton pes", semitoneOffset: -3),
  Ahenk(name: "Kız", description: "Bolahenk'ten 5 yarım ton tiz", semitoneOffset: 5),
  Ahenk(name: "Yıldız", description: "Bolahenk'ten 1 yarım ton pes", semitoneOffset: -1),
];

/// Verilen âhenk ve A4 kalibrasyonuna göre tüm ud tellerinin frekanslarını hesaplar.
List<double> calculateFrequencies(Ahenk ahenk, double a4Freq) {
  return bolahenk.map((s) => ahenk.transpose(s.frequencyForA4(a4Freq))).toList();
}

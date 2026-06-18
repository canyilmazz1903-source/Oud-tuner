/// Usul (Türk müziği ritim kalıbı) veri modeli.
class UsulBeat {
  final String type; // "dum", "tek", "ka", "rest"
  final bool isAccented;

  const UsulBeat({required this.type, this.isAccented = false});
}

class Usul {
  final String name;
  final String timeSignature; // "4/4", "9/8" vb.
  final int beatCount;
  final String description;
  final List<UsulBeat> pattern;

  const Usul({
    required this.name,
    required this.timeSignature,
    required this.beatCount,
    required this.description,
    required this.pattern,
  });
}

/// 8 temel usul kalıbı.
const List<Usul> usuller = [
  Usul(
    name: "Nim Sofyan",
    timeSignature: "2/4",
    beatCount: 2,
    description: "En küçük usul. Şarkı ve türkülerde yaygındır.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
    ],
  ),
  Usul(
    name: "Sofyan",
    timeSignature: "4/4",
    beatCount: 4,
    description: "En yaygın usuldür. İlahilerde ve şarkılarda kullanılır.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
    ],
  ),
  Usul(
    name: "Türk Aksağı",
    timeSignature: "5/8",
    beatCount: 5,
    description: "Aksak yapıda, zeybek ve oyun havalarında görülür.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
    ],
  ),
  Usul(
    name: "Yürük Semai",
    timeSignature: "6/8",
    beatCount: 6,
    description: "Hızlı semai formu. Fasılların son bölümünde icra edilir.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
    ],
  ),
  Usul(
    name: "Devr-i Hindi",
    timeSignature: "7/8",
    beatCount: 7,
    description: "Hint ritim etkili, mistik ve akıcı bir yapıdadır.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
    ],
  ),
  Usul(
    name: "Düyek",
    timeSignature: "8/8",
    beatCount: 8,
    description: "İki Sofyan'ın birleşimidir. İlahilerde çok yaygındır.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "rest"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "rest"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "rest"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "rest"),
    ],
  ),
  Usul(
    name: "Aksak",
    timeSignature: "9/8",
    beatCount: 9,
    description: "Aksak yapıda, zengin ve karmaşık bir ritimdir.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
    ],
  ),
  Usul(
    name: "Aksak Semai",
    timeSignature: "10/8",
    beatCount: 10,
    description: "Saz Semaisi formunun usulüdür. Enstrümantal eserlerde kullanılır.",
    pattern: [
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
      UsulBeat(type: "tek"),
      UsulBeat(type: "dum", isAccented: true),
      UsulBeat(type: "tek"),
    ],
  ),
];

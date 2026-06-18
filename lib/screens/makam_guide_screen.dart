import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../widgets/makam_staff.dart';

class MakamDetail {
  final String name;
  final String description;
  final String keyNotes;
  final String seyir;
  final String family;
  final Color familyColor;
  final String dortlu;
  final String besli;
  final String yeden;
  final String genisleme;
  final String karakterHissi;
  final List<MakamNote> scaleNotes;
  final List<String> notes;
  final List<int> commas;

  MakamDetail({
    required this.name,
    required this.description,
    required this.keyNotes,
    required this.seyir,
    required this.family,
    required this.familyColor,
    required this.dortlu,
    required this.besli,
    required this.yeden,
    required this.genisleme,
    required this.karakterHissi,
    required this.scaleNotes,
    required this.notes,
    required this.commas,
  });
}

class MakamGuideScreen extends StatefulWidget {
  const MakamGuideScreen({super.key});

  @override
  State<MakamGuideScreen> createState() => _MakamGuideScreenState();
}

class _MakamGuideScreenState extends State<MakamGuideScreen> {
  int _selectedMakamIndex = 0;
  String _selectedFamily = "Tümü";
  final Map<int, int> _selectedNoteIndices = {};

  static final List<String> families = ["Tümü", "Rast", "Hicaz", "Uşşak", "Hüseynî", "Diğer"];

  static final List<MakamDetail> makamlar = [
    // === RAST AİLESİ ===
    MakamDetail(
      name: "Rast", description: "Türk müziğinin en temel, parlak ve asil makamıdır. Neşe, huzur ve ihtişam duygusu verir.",
      keyNotes: "Durak: Rast (Sol)  |  Güçlü: Nevâ (Re)", seyir: "Çıkıcı",
      family: "Rast", familyColor: AppColors.familyRast,
      dortlu: "Çârgâh dörtlüsü [9-8-5]", besli: "Rast beşlisi [9-9-8-5]",
      yeden: "Irak (Fa#)", genisleme: "Yegâh bölgesine iniş",
      karakterHissi: "Neşe ve asalet",
      notes: ["Sol", "La", "Si↓", "Do", "Re", "Mi", "Fa#↓", "Sol"], commas: [9, 8, 5, 9, 9, 8, 5],
      scaleNotes: [
        MakamNote(traditionalName: "Rast", standardName: "Sol", accidental: "none", frequency: 293.66, staffIndex: -5),
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Eviç", standardName: "Fa#↓", accidental: "koma_sharp", frequency: 519.30, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
      ],
    ),
    MakamDetail(
      name: "Mahur", description: "Rast makamının majör gamına en yakın halidir. Neşeli, parlak ve güçlü bir tınıya sahiptir.",
      keyNotes: "Durak: Rast (Sol)  |  Güçlü: Nevâ (Re)", seyir: "Çıkıcı",
      family: "Rast", familyColor: AppColors.familyRast,
      dortlu: "Çârgâh dörtlüsü [9-9-4]", besli: "Mahur beşlisi [9-9-9-4]",
      yeden: "Irak (Fa#)", genisleme: "Tiz bölgeye çıkış",
      karakterHissi: "Parlaklık ve zafer",
      notes: ["Sol", "La", "Si", "Do", "Re", "Mi", "Fa#", "Sol"], commas: [9, 9, 4, 9, 9, 9, 4],
      scaleNotes: [
        MakamNote(traditionalName: "Rast", standardName: "Sol", accidental: "none", frequency: 293.66, staffIndex: -5),
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Buselik", standardName: "Si", accidental: "none", frequency: 356.00, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Mâhur", standardName: "Fa#", accidental: "sharp", frequency: 553.40, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
      ],
    ),
    MakamDetail(
      name: "Nihavend", description: "Batı minör gamına en yakın makamdır. Romantik, melankolik ve zarif bir havası vardır.",
      keyNotes: "Durak: Rast (Sol)  |  Güçlü: Nevâ (Re)", seyir: "İnici-Çıkıcı",
      family: "Rast", familyColor: AppColors.familyRast,
      dortlu: "Buselik dörtlüsü [9-5-8]", besli: "Buselik beşlisi [9-5-9-9]",
      yeden: "Irak (Fa#)", genisleme: "Yegâh bölgesine iniş",
      karakterHissi: "Romantik melankoli",
      notes: ["Sol", "La", "Si♭", "Do", "Re", "Mi♭", "Fa", "Sol"], commas: [9, 5, 8, 9, 5, 9, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Rast", standardName: "Sol", accidental: "none", frequency: 293.66, staffIndex: -5),
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Kürdî", standardName: "Si♭", accidental: "flat", frequency: 341.20, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hisar", standardName: "Mi♭", accidental: "flat", frequency: 466.16, staffIndex: 0),
        MakamNote(traditionalName: "Acem", standardName: "Fa", accidental: "none", frequency: 523.25, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
      ],
    ),
    // === HİCAZ AİLESİ ===
    MakamDetail(
      name: "Hicaz", description: "Hüznü, sıcaklığı ve tasavvufi derinliği yansıtan, karakteristik geniş aralığıyla tanınan makamdır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Nevâ (Re)", seyir: "İnici-Çıkıcı",
      family: "Hicaz", familyColor: AppColors.familyHicaz,
      dortlu: "Hicaz dörtlüsü [5-12-5]", besli: "Rast beşlisi [9-8-5-9]",
      yeden: "Rast (Sol)", genisleme: "Rast bölgesine iniş",
      karakterHissi: "Derin hüzün ve sıcaklık",
      notes: ["La", "Si♭", "Do#", "Re", "Mi", "Fa", "Sol", "La"], commas: [5, 12, 5, 9, 5, 9, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Kürdî", standardName: "Si♭", accidental: "flat", frequency: 341.20, staffIndex: -3),
        MakamNote(traditionalName: "Nim Hicaz", standardName: "Do#", accidental: "sharp", frequency: 411.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Acem", standardName: "Fa", accidental: "none", frequency: 523.25, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    MakamDetail(
      name: "Hümâyun", description: "Hicaz ailesinin en dramatik makamıdır. Acı, isyan ve kader duygusu barındırır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Nevâ (Re)", seyir: "İnici",
      family: "Hicaz", familyColor: AppColors.familyHicaz,
      dortlu: "Hicaz dörtlüsü [5-12-5]", besli: "Buselik beşlisi [9-5-9-9]",
      yeden: "Rast (Sol)", genisleme: "Rast bölgesine iniş",
      karakterHissi: "Acı ve dramatik",
      notes: ["La", "Si♭", "Do#", "Re", "Mi♭", "Fa", "Sol", "La"], commas: [5, 12, 5, 5, 9, 9, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Kürdî", standardName: "Si♭", accidental: "flat", frequency: 341.20, staffIndex: -3),
        MakamNote(traditionalName: "Nim Hicaz", standardName: "Do#", accidental: "sharp", frequency: 411.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hisar", standardName: "Mi♭", accidental: "flat", frequency: 466.16, staffIndex: 0),
        MakamNote(traditionalName: "Acem", standardName: "Fa", accidental: "none", frequency: 523.25, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    // === UŞŞAK AİLESİ ===
    MakamDetail(
      name: "Uşşak", description: "Aşk, mistik derinlik ve içli duyguları yansıtan, halk müziğinde de çok yaygın bir makamdır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Nevâ (Re)", seyir: "Çıkıcı",
      family: "Uşşak", familyColor: AppColors.familyUssak,
      dortlu: "Uşşak dörtlüsü [8-5-9]", besli: "Buselik beşlisi [9-5-9-9]",
      yeden: "Rast (Sol)", genisleme: "Rast bölgesine iniş",
      karakterHissi: "İçli ve mistik",
      notes: ["La", "Si↓", "Do", "Re", "Mi", "Fa", "Sol", "La"], commas: [8, 5, 9, 9, 5, 9, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Acem", standardName: "Fa", accidental: "none", frequency: 523.25, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    MakamDetail(
      name: "Beyâtî", description: "Uşşak'a çok yakındır. Daha olgun, sakin ve dingin bir havaya sahiptir. Türkülerde çok görülür.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Nevâ (Re)", seyir: "İnici-Çıkıcı",
      family: "Uşşak", familyColor: AppColors.familyUssak,
      dortlu: "Uşşak dörtlüsü [8-5-9]", besli: "Buselik beşlisi [9-5-9-9]",
      yeden: "Rast (Sol)", genisleme: "Rast ve Yegâh bölgesi",
      karakterHissi: "Olgun hüzün",
      notes: ["La", "Si↓", "Do", "Re", "Mi", "Fa", "Sol", "La"], commas: [8, 5, 9, 9, 5, 9, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Acem", standardName: "Fa", accidental: "none", frequency: 523.25, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    // === HÜSEYNİ AİLESİ ===
    MakamDetail(
      name: "Hüseynî", description: "Anadolu bozlaklarının ve türkülerin en popüler makamıdır. Güçlü ve coşkulu bir ifade taşır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Hüseynî (Mi)", seyir: "İnici-Çıkıcı",
      family: "Hüseynî", familyColor: AppColors.familyHuseyni,
      dortlu: "Uşşak dörtlüsü [8-5-9]", besli: "Hüseynî beşlisi [9-8-5-9]",
      yeden: "Rast (Sol)", genisleme: "Tiz bölge ve Rast altı",
      karakterHissi: "Coşku ve güç",
      notes: ["La", "Si↓", "Do", "Re", "Mi", "Fa#↓", "Sol", "La"], commas: [8, 5, 9, 9, 8, 5, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Eviç", standardName: "Fa#↓", accidental: "koma_sharp", frequency: 519.30, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    MakamDetail(
      name: "Muhayyer", description: "Hüseynî ailesinden, inici karakterli, ağırbaşlı ve vakur bir makamdır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Muhayyer (La tiz)", seyir: "İnici",
      family: "Hüseynî", familyColor: AppColors.familyHuseyni,
      dortlu: "Uşşak dörtlüsü [8-5-9]", besli: "Hüseynî beşlisi [9-8-5-9]",
      yeden: "Rast (Sol)", genisleme: "Tiz Muhayyer'den iniş",
      karakterHissi: "Ağırbaşlılık ve vakar",
      notes: ["La", "Si↓", "Do", "Re", "Mi", "Fa#↓", "Sol", "La"], commas: [8, 5, 9, 9, 8, 5, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Eviç", standardName: "Fa#↓", accidental: "koma_sharp", frequency: 519.30, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    // === DİĞER / BAĞIMSIZ ===
    MakamDetail(
      name: "Segâh", description: "Uhrevi, mistik ve manevi derinliği olan makamdır. Ezan ve ilahilerde sıkça duyulur.",
      keyNotes: "Durak: Segâh (Si↓)  |  Güçlü: Hüseynî (Mi)", seyir: "Çıkıcı",
      family: "Diğer", familyColor: AppColors.familySegah,
      dortlu: "Segâh dörtlüsü [5-9-9]", besli: "Rast beşlisi [9-8-5-9]",
      yeden: "Dügâh (La)", genisleme: "Rast altı bölge",
      karakterHissi: "Uhrevi ve manevi",
      notes: ["Si↓", "Do", "Re", "Mi", "Fa#↓", "Sol", "La", "Si↓"], commas: [5, 9, 9, 8, 5, 9, 8],
      scaleNotes: [
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Eviç", standardName: "Fa#↓", accidental: "koma_sharp", frequency: 519.30, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
        MakamNote(traditionalName: "T. Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 693.00, staffIndex: 4),
      ],
    ),
    MakamDetail(
      name: "Saba", description: "Sabah ezanının makamıdır. Teslimiyet, hüzün ve derin bir ruhani his taşır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Çârgâh (Do)", seyir: "Çıkıcı",
      family: "Diğer", familyColor: AppColors.familyOther,
      dortlu: "Saba dörtlüsü [8-5-5]", besli: "Hicaz beşlisi [12-5-9-5]",
      yeden: "Rast (Sol)", genisleme: "Saba bölgesi genişlemesi",
      karakterHissi: "Teslimiyet ve maneviyat",
      notes: ["La", "Si↓", "Do", "Re↓", "Mi♭", "Fa", "Sol", "La"], commas: [8, 5, 5, 9, 5, 9, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Saba", standardName: "Re↓", accidental: "koma_flat", frequency: 415.00, staffIndex: -1),
        MakamNote(traditionalName: "Hisar", standardName: "Mi♭", accidental: "flat", frequency: 466.16, staffIndex: 0),
        MakamNote(traditionalName: "Acem", standardName: "Fa", accidental: "none", frequency: 523.25, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    MakamDetail(
      name: "Kürdi", description: "Batı minör moduna yakın, sade ve doğrudan bir hüzün ifadesi taşıyan bir makamdır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Nevâ (Re)", seyir: "Çıkıcı",
      family: "Diğer", familyColor: AppColors.familyOther,
      dortlu: "Kürdî dörtlüsü [5-9-8]", besli: "Buselik beşlisi [9-5-9-9]",
      yeden: "Rast (Sol)", genisleme: "Rast bölgesine iniş",
      karakterHissi: "Sade hüzün",
      notes: ["La", "Si♭", "Do", "Re", "Mi", "Fa", "Sol", "La"], commas: [5, 9, 8, 9, 5, 9, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Kürdî", standardName: "Si♭", accidental: "flat", frequency: 341.20, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hüseynî", standardName: "Mi", accidental: "none", frequency: 493.88, staffIndex: 0),
        MakamNote(traditionalName: "Acem", standardName: "Fa", accidental: "none", frequency: 523.25, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
    MakamDetail(
      name: "Karcığar", description: "Akşam serinliğini ve bir parça hüznü çağrıştıran, popüler şarkılarda sıkça kullanılan bir makamdır.",
      keyNotes: "Durak: Dügâh (La)  |  Güçlü: Nevâ (Re)", seyir: "İnici-Çıkıcı",
      family: "Diğer", familyColor: AppColors.familyOther,
      dortlu: "Uşşak dörtlüsü [8-5-9]", besli: "Hicaz beşlisi [5-12-5-9]",
      yeden: "Rast (Sol)", genisleme: "Hicaz bölgesi genişlemesi",
      karakterHissi: "Akşam hüznü",
      notes: ["La", "Si↓", "Do", "Re", "Mi♭", "Fa#", "Sol", "La"], commas: [8, 5, 9, 5, 12, 5, 9],
      scaleNotes: [
        MakamNote(traditionalName: "Dügâh", standardName: "La", accidental: "none", frequency: 329.63, staffIndex: -4),
        MakamNote(traditionalName: "Segâh", standardName: "Si↓", accidental: "koma_flat", frequency: 346.50, staffIndex: -3),
        MakamNote(traditionalName: "Çârgâh", standardName: "Do", accidental: "none", frequency: 392.00, staffIndex: -2),
        MakamNote(traditionalName: "Nevâ", standardName: "Re", accidental: "none", frequency: 440.00, staffIndex: -1),
        MakamNote(traditionalName: "Hisar", standardName: "Mi♭", accidental: "flat", frequency: 466.16, staffIndex: 0),
        MakamNote(traditionalName: "Dik Acem", standardName: "Fa#", accidental: "sharp", frequency: 553.40, staffIndex: 1),
        MakamNote(traditionalName: "Gerdaniye", standardName: "Sol", accidental: "none", frequency: 587.33, staffIndex: 2),
        MakamNote(traditionalName: "Muhayyer", standardName: "La", accidental: "none", frequency: 659.26, staffIndex: 3),
      ],
    ),
  ];

  List<MakamDetail> get _filteredMakamlar {
    if (_selectedFamily == "Tümü") return makamlar;
    return makamlar.where((m) => m.family == _selectedFamily).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredMakamlar;
    final safeIndex = _selectedMakamIndex.clamp(0, filtered.length - 1);
    final makam = filtered[safeIndex];
    final int activeNoteIndex = _selectedNoteIndices[makamlar.indexOf(makam)] ?? 0;
    final activeNote = makam.scaleNotes[activeNoteIndex.clamp(0, makam.scaleNotes.length - 1)];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MAKAM REHBERİ", style: TextStyle(letterSpacing: 2, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.primaryText)),
              const SizedBox(height: 4),
              Text("${makamlar.length} makam · Aileler, dörtlü/beşli yapılar ve interaktif porte.", style: const TextStyle(fontSize: 10, color: AppColors.secondaryText)),
              const SizedBox(height: 12),

              // === Aile Filtresi ===
              SizedBox(
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: families.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (ctx, i) {
                    final f = families[i];
                    final isSel = f == _selectedFamily;
                    return GestureDetector(
                      onTap: () { HapticFeedback.selectionClick(); setState(() { _selectedFamily = f; _selectedMakamIndex = 0; }); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.accentAmber.withOpacity(0.12) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSel ? AppColors.accentAmber : AppColors.border),
                        ),
                        child: Text(f, style: TextStyle(fontSize: 10, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: isSel ? AppColors.accentAmber : AppColors.secondaryText)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              // === Makam Seçici ===
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (ctx, i) {
                    final isSel = i == safeIndex;
                    final m = filtered[i];
                    return GestureDetector(
                      onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedMakamIndex = i); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSel ? m.familyColor.withOpacity(0.12) : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isSel ? m.familyColor : AppColors.border),
                        ),
                        child: Text(m.name, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: isSel ? m.familyColor : AppColors.primaryText)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // === İçerik ===
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bilgi kartı
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Expanded(child: Text(makam.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: makam.familyColor))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: makam.familyColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                                child: Text(makam.karakterHissi, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: makam.familyColor)),
                              ),
                            ]),
                            const SizedBox(height: 6),
                            Text(makam.description, style: const TextStyle(fontSize: 11.5, height: 1.4, color: AppColors.primaryText)),
                            const SizedBox(height: 10),
                            // Aile + Seyir
                            Row(children: [
                              _infoChip("${makam.family} Ailesi", makam.familyColor),
                              const SizedBox(width: 6),
                              _infoChip(makam.seyir, AppColors.secondaryText),
                            ]),
                            const SizedBox(height: 8),
                            Text(makam.keyNotes, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accentAmber)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Dörtlü + Beşli yapı
                      Row(children: [
                        Expanded(child: _structureBox("DÖRTLÜ (Cins)", makam.dortlu)),
                        const SizedBox(width: 8),
                        Expanded(child: _structureBox("BEŞLİ (Cins)", makam.besli)),
                      ]),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: _structureBox("YEDEN", makam.yeden)),
                        const SizedBox(width: 8),
                        Expanded(child: _structureBox("GENİŞLEME", makam.genisleme)),
                      ]),
                      const SizedBox(height: 14),

                      // Dizek
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("DİZEK / SOLFEJ", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.secondaryText)),
                        Text("Notalara dokunun", style: TextStyle(fontSize: 8, color: AppColors.accentAmber.withOpacity(0.7))),
                      ]),
                      const SizedBox(height: 6),
                      MakamStaff(
                        notes: makam.scaleNotes,
                        selectedNoteIndex: activeNoteIndex.clamp(0, makam.scaleNotes.length - 1),
                        onNoteTapped: (idx) { HapticFeedback.selectionClick(); setState(() => _selectedNoteIndices[makamlar.indexOf(makam)] = idx); },
                      ),
                      const SizedBox(height: 8),

                      // Nota detay
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F0F11), borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.accentOlive.withOpacity(0.25)),
                        ),
                        child: Row(children: [
                          Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.accentOlive.withOpacity(0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.music_note_rounded, color: AppColors.accentOlive, size: 18)),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("${activeNote.traditionalName} Perdesi", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                            Text("${activeNote.standardName}  |  ${activeNote.frequency.toStringAsFixed(1)} Hz", style: const TextStyle(fontSize: 10, color: AppColors.secondaryText)),
                          ])),
                        ]),
                      ),
                      const SizedBox(height: 14),

                      // Koma diyagramı
                      const Text("KOMA ARALIĞI DİYAGRAMI", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: AppColors.secondaryText)),
                      const SizedBox(height: 6),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal, physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(makam.notes.length, (nI) {
                            final hasC = nI < makam.commas.length;
                            return Row(children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderLight)),
                                child: Text(makam.notes[nI], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryText)),
                              ),
                              if (hasC) Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: Row(children: [
                                  Container(width: 12, height: 1, color: AppColors.accentAmber.withOpacity(0.2)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(color: AppColors.accentAmber.withOpacity(0.06), borderRadius: BorderRadius.circular(4)),
                                    child: Text("${makam.commas[nI]}", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.accentAmber)),
                                  ),
                                  Container(width: 12, height: 1, color: AppColors.accentAmber.withOpacity(0.2)),
                                ]),
                              ),
                            ]);
                          }),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.2))),
      child: Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _structureBox(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: AppColors.tertiaryText)),
        const SizedBox(height: 4),
        Text(content, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryText, height: 1.3)),
      ]),
    );
  }
}

# Ud Tuner & Makam Rehberi Mobil Uygulaması (PRD)

## 1. Proje Özeti
Bu proje, Klasik Türk Müziği icracıları ve öğrencileri için özel olarak tasarlanmış, yüksek hassasiyetli bir Ud Akort ve Makam Rehberi uygulamasıdır. Google'ın mobil geliştirme teknolojileri kullanılarak iOS (App Store) için geliştirilecek olan bu uygulama; modern, minimalist ve karanlık tema (dark mode) odaklı bir arayüze sahip olacaktır. 

## 2. Temel Özellikler (Core Features)

### 2.1. Klasik Türk Müziği Ud Akordu (Ana Ekran)
Uygulamanın merkezinde yer alan kromatik ve enstrümana özel akort motoru. Sizin belirttiğiniz frekans standartlarına tam uyum sağlayacak şekilde kalibre edilecektir:

* **1. Tel (En alt):** Sol (D4) - `293.66 Hz`
* **2. Tel:** Re (A3) - `220.00 Hz`
* **3. Tel:** La (E3) - `164.81 Hz`
* **4. Tel:** Mi (B2) - `123.47 Hz`
* **5. Tel:** Si (F#2) - `92.50 Hz`
* **6. Tel (Bam):** Fa# - `69.30 Hz`

**Fonksiyonlar:**
* Otomatik tel algılama sistemi.
* Frekans (Hz) ve Sent (Cent) sapmalarının anlık, gecikmesiz görselleştirilmesi.
* Doğru akorda ulaşıldığında haptik geri bildirim (titreşim) ve net bir görsel onay.

### 2.2. Makam Rehberi (Bilgi Sekmesi)
Kullanıcıların pratik yaparken veya taksim çalışırken başvurabilecekleri interaktif bir Türk Müziği teorisi rehberi.
* **Popüler Makamlar:** Rast, Uşşak, Hicaz, Nihavend, Segâh, Hüseyni vb. makamların temel dizileri.
* **Koma Yapıları:** Batı müziği notasyonundan farklı olarak Türk müziğine özgü koma (aralık) değerlerinin (koma bemolü, bakiye diyezi vb.) temiz görsel diyagramlarla gösterimi.
* **Seyir Özetleri:** Makamların çıkıcı/inici özellikleri ve durak/güçlü sesleri hakkında hızlıca okunabilen hap bilgiler.

## 3. UI/UX Tasarım Dili (Arayüz ve Kullanıcı Deneyimi)
Tasarım, görsel karmaşadan uzak, odaklanmayı artıran **minimalist ve atmosferik (gölge konseptli)** bir yapıda kurgulanacaktır:

* **Renk Paleti:** Derin koyu gri ve mat siyah arka planlar. Aktif tel ve doğru frekans eşleşmeleri için dikkati yormayan zarif vurgu renkleri (örn: koyu zeytin yeşili veya amber).
* **Tipografi:** Temiz, sans-serif fontlar (Inter veya Roboto) ile sahne ve stüdyo ortamında yüksek okunabilirlik.
* **Animasyonlar:** Ses frekansına duyarlı, akıcı dalga (wave) animasyonları veya minimal akort ibresi.
* **Navigasyon:** Alt navigasyon çubuğu (Bottom Navigation Bar) ile "Tuner" ve "Makamlar" arasında tek dokunuşla geçiş.

## 4. Teknik Altyapı
Projeyi App Store'a modern ve yüksek performanslı bir şekilde çıkarmak için Google'ın native derlenen mobil framework'ü **Flutter** kullanılacaktır. *(Not: "Google Antigravity" geliştirici topluluklarında bazen esprili bir tabir veya farklı araçların kod adı olarak geçse de, Google'ın Apple App Store ve Google Play için sunduğu resmi, modern ve pürüzsüz arayüzler çıkaran teknoloji Flutter'dır).*

* **Framework:** Flutter (Dart dili ile yazılır, iOS için yüksek performanslı ve modern animasyonlara sahip çıktılar üretir).
* **Ses Motoru (Audio Engine):** Hızlı fourier dönüşümü (FFT) ve pitch detection algoritmaları için optimize edilmiş kütüphaneler (`fftea` veya `pitch_detector_dart`).
* **Veri Yapısı:** Makam rehberi için cihazda yerel olarak çalışan hafif ve hızlı bir JSON veritabanı.

## 5. Geliştirme ve Yayın Süreci (Yol Haritası)
1.  **Tasarım ve Prototipleme:** Ekran tasarımlarının oluşturulması.
2.  **Akort Algoritmasının Geliştirilmesi:** Mikrofondan alınan verinin Hz cinsinden doğru ayrıştırılması ve hedef frekanslarla (293.66 Hz vb.) gerçek zamanlı eşleştirilmesi.
3.  **Arayüz Kodlaması:** Makam sekmesinin ve tuner animasyonlarının Flutter ile entegre edilmesi.
4.  **Test Süreci:** Uygulamanın gürültülü ortamlarda (prova odaları, stüdyolar) hassasiyetinin test edilmesi.
5.  **App Store Yayını:** Apple onay süreçlerine uygun şekilde uygulamanın iOS platformuna yüklenmesi.

Not: Bu klasör, ilerleyen aşamalarda bir modüle dönüştürülerek proje içindeki yapıları makale formatında sunabilecek hale getirilecek. Böylece insanlar buradan kolayca erişip okuyabilecek. Şu an için ise içerikler **README.md** dosyaları şeklinde olacak.

# Headlights

## Concurrency
- Actor

# Architecture
- VIPER
- Coordinator Pattern
- Observation Pattern

# Modular
- Module Interface Pattern (Feature) 
- Circular Dependency
- Dependency Container Property Wrapper

# 📌 Her Mobil Uygulamada Bulunması Gereken Modüller

Bu modüller, uygulamanın temel işleyişini sağlayan ve her türlü mobil uygulamada kullanılabilecek yapılardır.

1️⃣ IRBase
Uygulamanın base yapı taşlarını bu modül içerir.

1️⃣ IRCore
Uygulamanın temel bileşenlerini içerir.
Coordinator Pattern, Dependency Injection ve App Lifecycle yönetimi buradadır.

2️⃣ IRNetworking
API çağrıları için merkezi bir ağ katmanı sağlar.
REST, GraphQL, WebSocket gibi teknolojilere destek verebilir.

3️⃣ IRDatabase
CoreData, Realm, SQLite gibi lokal veri saklama işlemlerini yönetir.
Offline destek sunmak için kullanılabilir.

4️⃣ IRAuth
Kullanıcı oturum yönetimi, giriş ve çıkış işlemlerini kapsar.
JWT, OAuth, Apple Sign-In, Firebase Auth gibi kimlik doğrulama yöntemlerini destekler.

5️⃣ IRStyleKit
Uygulamada tekrar kullanılabilir UI bileşenlerini içerir.
Özel butonlar, input alanları, modallar gibi UI öğelerini barındırır.

5️⃣ IRBaseUI
Uygulamanın BaseUI'larının yönetildiği yapıdır.

6️⃣ IRAssets
Tüm renk, font, ikon ve görselleri merkezi bir noktada toplar.
Temalar ve localizable string yönetimini kapsar.

7️⃣ IRCommon
Genel yardımcı fonksiyonları, extension’ları ve typealias’leri içerir.
Tarih, String, JSON formatlama gibi işlemler burada bulunur.

8️⃣ IRLaunch
Uygulama başlatıldığında hangi ekranın gösterileceğini yönetir.
Oturum durumuna göre kullanıcıyı yönlendirir.

9️⃣ IRLogin
Kullanıcı giriş ve kayıt işlemlerini yönetir.
Apple, Google gibi giriş yöntemlerini içerir.

🔟 IROnboarding
Yeni kullanıcılar için uygulamayı tanıtan rehber ekranlarını içerir.
İlk açılışta izin isteme işlemlerini yönetir.

1️⃣1️⃣ IRDashboard
Uygulamanın ana sayfasını yönetir (genellikle bir TabBar içerir).
Ana ekranı, favoriler, bildirimler ve profil gibi temel sayfalara yönlendirir.

1️⃣2️⃣ IRSearch
Genel arama fonksiyonlarını ve filtreleme işlemlerini kapsar.
Autocomplete, önerilen aramalar ve geçmiş sorgular desteği içerir.

1️⃣3️⃣ IRNotifications
Push Notification ve Local Notification yönetimini içerir.
Bildirim merkezi gibi özellikler barındırabilir.

1️⃣4️⃣ IRLogging
Hata ayıklama ve hata raporlamayı yönetir.
Firebase Crashlytics, OSLog gibi loglama sistemleriyle entegre olabilir.

1️⃣5️⃣ IRAnalytics
Kullanıcı aksiyonlarını takip eder ve analitik servislerle veri paylaşır.
Firebase Analytics, Mixpanel gibi araçlarla entegre olabilir.

1️⃣6️⃣ IRPermissions
Kamera, mikrofon, konum, bildirim gibi izinleri yönetir.
İzinlerin durumunu kontrol eder ve kullanıcıya izin diyaloglarını sunar.

1️⃣7️⃣ IRFeatureFlags
Yeni özellikleri A/B test yöntemiyle yönetmek için kullanılır.
Firebase Remote Config veya JSON tabanlı bir yapı ile entegre edilebilir.

1️⃣8️⃣ IRStorage
UserDefaults, Keychain, FileManager gibi veri saklama yöntemlerini soyutlar.
Önemli kullanıcı bilgilerini güvenli bir şekilde saklar.

# 🛒 E-Ticaret / Market Uygulamaları İçin Modüller

1️⃣9️⃣ IRCart
Sepete eklenen ürünlerin yönetimini sağlar.
Fiyat hesaplamaları ve kupon entegrasyonu içerir.

2️⃣0️⃣ IRCheckout
Ödeme işlemlerini yönetir.
Kredi kartı, havale, kapıda ödeme gibi seçenekler sunar.

2️⃣1️⃣ IROrders
Geçmiş siparişleri ve kargo takip bilgilerini yönetir.

2️⃣2️⃣ IRProduct
Ürün detay sayfalarını yönetir.
Ürün açıklamaları, yorumlar ve stok bilgilerini içerir.

# 🎬 İçerik Tabanlı Uygulamalar (YouTube, Netflix, Spotify) İçin Modüller

2️⃣3️⃣ IRMedia
Video, ses veya görsel içerik yönetimi yapar.
Streaming servisleriyle entegre edilebilir.

2️⃣4️⃣ IRSubscriptions
Premium abonelik sistemlerini yönetir.
Apple’ın abonelik API’leri ile entegre çalışabilir.

# 📍 Harita & Navigasyon Uygulamaları İçin Modüller

2️⃣5️⃣ IRMap
Harita tabanlı servisleri yönetir (Google Maps, MapKit vb.)
Konum bazlı filtreleme ve rota çizimi desteği sunar. Community noktalarını vs. vurgulayacak.
2️⃣6️⃣ IRLocation
Kullanıcının konumunu takip eder ve günceller.
Arka planda konum servisleriyle çalışabilir.

# 🗣️ Sosyal Medya / Topluluk Uygulamaları İçin Modüller

2️⃣7️⃣ IRChatBot
Canlı sohbet ve mesajlaşma işlemlerini yönetir. Bir chatbot ile AI sorular sorup cevapların çok hızlı bir şekilde alınabileceği bir sohbet botu tasarımı olacak. Burada maksat ekranda açık olan bilginin efektif kodunu yönetecek.

2️⃣8️⃣ IRCommunity
Forum, kullanıcı yorumları ve topluluk bazlı içerikleri yönetir.

2️⃣9️⃣ IRReferrals
Arkadaşını davet et & ödül kazan sistemleri içerir.


# 📌 Modüller Arasındaki İletişimi Profesyonel Bir Şekilde Yönetme Yöntemleri

✅ Hedefimiz:

Loose Coupling (Düşük Bağımlılık): Modüller birbirine doğrudan bağımlı olmamalı.
Test Edilebilirlik: Mock edilebilir ve bağımsız testler yazılabilir olmalı.
Genişletilebilirlik: Yeni özellikler eklenirken mevcut modüllere zarar vermemeli.

1️⃣ Dependency Injection (DI) ile Bağımlılık Yönetimi

✅ Ne yapar?

Bağımlılığı doğrudan modül içine gömmek yerine, dışarıdan geçerek daha esnek bir yapı kurarız.
Mocking ve unit test yazılmasını kolaylaştırır.
Circular dependency sorunlarını önler.

2️⃣ Protocol-Based Communication (Arayüz ile İletişim)

✅ Ne yapar?

Modüller birbirine doğrudan bağlı olmak yerine, protokoller üzerinden iletişim kurar.
Bir modülü değiştirdiğimizde, diğer modülleri etkilemeden çalışabiliriz.

3️⃣ Notification Center / Combine ile Modüller Arası Haberleşme

✅ Ne yapar?

Bir modülün diğer modülleri etkilemeden bir olay yayınlamasını ve başka bir modülün bunu dinlemesini sağlar.
Olay bazlı (event-driven) iletişim sağlar.

4️⃣ Event Bus (Shared Event Manager) ile Yönetim

✅ Ne yapar?

Notification Center gibi ama daha merkezi ve yönetilebilir bir yapı kurar.

# 📌 Super App Yapısında Yönetim Nasıl Olmalı?

Super App mimarisi, birden fazla uygulamayı tek bir çatı altında toplamak anlamına gelir.
Bu yapıyı profesyonelce yönetmek için 3 temel konuya odaklanmalıyız:

✅ Bağımsız Mini-App’ler (Micro-App Architecture) → Super App içinde bağımsız çalışan uygulamalar
✅ Mini-App’lerin Yüklenmesi ve Yönetimi → Hangi mini-app’lerin yükleneceğini ve çalıştırılacağını belirleme
✅ Ortak Bileşenler ve Veri Paylaşımı → Mini-app’lerin Super App ile veri paylaşımı

1️⃣ Bağımsız Mini-App’ler (Micro-App Architecture)

Super App içindeki her mini-app bağımsız bir modül olmalı. Ana uygulamaya direkt bağımlı olmamalı ve bağımsız olarak test edilebilir, yönetilebilir olmalı.

🔹 Super App: Çekirdek uygulama (Ana yönlendirme, menü, login, bildirimler, ortak servisler)
🔹 Mini-App’ler: Super App içinde çalışan bağımsız uygulamalar


📌 Interface Modülleri Ne İşe Yarar?

1️⃣ Bağımlılıkları azaltır → Modüller arası direkt bağımlılık yerine sadece protokol ile iletişim kurulur.
2️⃣ Bağımsız geliştirme sağlar → Bir ekibin IRDashboardInterface, başka bir ekibin IRDashboard üzerinde çalışmasını sağlar.
3️⃣ Mock ve test kolaylığı sunar → UI veya iş mantığı modüllerini mock’lamak kolaylaşır.

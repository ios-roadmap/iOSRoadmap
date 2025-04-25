# UI Design

![JPHApp](https://github.com/user-attachments/assets/4ad59b97-36e7-4ffd-9d10-54843dfcf170)

# UX Design

### 🎯 **1. Akıllı Swipe Actions (Kontext-Aware)**  
- **Swipe aksiyonları dinamik olmalı.**
  - Kullanıcıda e-posta varsa `Message`, yoksa çıkmaz.
  - `Call` sadece numarası olanlarda aktif olur.
- **Haptic Feedback** eklenmeli (iPhone’larda çok fark yaratır).
- Kısa swipe: quick action  
  Uzun swipe: detay ekranına geçiş

---

### 🗂 **2. Smart Grouping & Sections**
- Contacts’i:
  - **Alphabetical**
  - **Tags (Work, Family, Friends)**
  - **Last Contacted**
  - **Nearby (konum bazlı)** gibi bölümlere ayır.
- Her grup collapsible olmalı.

---

### 💬 **3. Inline Presence & Status**
- Kişi online mı? En son ne zaman erişildi?
  - "Online", "Last seen 3h ago", "Do not disturb"
- Bu, “WhatsApp” ya da “Messenger” tarzı bir katman getirir.

---

### 🧭 **4. Deep Link Destekli Quick Actions**
- Uzun basıldığında:
  - `3D Touch / Context Menu` ile:
    - 📞 Arama
    - 💬 Mesaj
    - 📍 Yol Tarifi
    - 📇 Kişiyi Paylaş

---

### 🔍 **5. Powerful Search & Filter**
- Arama:
  - İsim
  - @username
  - Etiket
  - Şirket ismi
- Akıllı filtreler:
  - “Only with phone number”
  - “Has email”
  - “Recently contacted”
  - “Job title contains ‘Manager’”

---

### 🧩 **6. Contact Preview & Peek (PreviewController)**
- Liste ekranında cell'e hafifçe basınca (peek) kişi detayı görünür.
- Yukarı sürüklenince `Quick Actions` çıkar (call, message, edit gibi).
- iOS’in native preview controller mimarisiyle %100 uyumlu olur.

---

### 👤 **7. Editable Tags ve Notes Alanı**
- Kişiye özel etiketler: `#VIP`, `#UXMentor`, `#Sponsorship`
- Not bırakılabilir: “Bu kişiyle son etkinlikte tanıştım”
- Hızlı erişim için filtrelenebilir olmalı

---

### 📁 **8. Smart Sync & Merge**
- Aynı numaralı iki kişiyi tespit edebilir.
- Çakışan kişileri “Merge Suggestion” olarak sunar.
- iCloud ve diğer kaynaklarla senkron kontrolü (Google, Outlook).

---

### 🧠 **9. Siri Shortcuts + Spotlight Integration**
- “Hey Siri, message Leanne” veya “Call my manager”
- iOS Spotlight’ta kişi ismiyle arama → uygulamaya deep link

---

### 🧱 **10. Modular Component-based UX**
- Tüm kartlar, detay bileşenleri `Reusable Components` olmalı.
- Bu sayede farklı ekranlarda, örneğin grup listesi vs, yeniden kullanılabilir.
- `Dark`, `Light`, `Accessibility` modlarına otomatik uyum sağlar.

---

### 🎨 **11. Accessibility + Dynamic Type**
- VoiceOver destekli açıklayıcı metinler
- `UIFontMetrics` ile Dynamic Type uyumu
- Kontrast kontrolleri → `UIColor.label`, `UIColor.secondaryLabel` kullanımı

---

### 🧭 **12. Map Deep Link & Nearby UX**
- Adres alanına tıklanınca Apple Maps veya Google Maps’e yönlendir
- Kişilerin konumunu gösteren mini harita ekranı (e.g. `Nearby Contacts`)
- Örnek: “Show people near me”

---

### 🔐 **13. Privacy Layer**
- Telefon numarasını gizle (Face ID ile açılabilir)
- Notlar ya da özel etiketler sadece güvenli modda görünür
- Paylaşıldığında hangi alanların görünür olduğunu seçebilme

---

### 📊 **14. Contact Insights**
- En sık aranan kişiler
- Haftalık iletişim istatistikleri
- Kimle ne zaman en son mesajlaştın

---

### 🖼 **15. Rich Contact View**
- Kişi için kapak görseli, varsa profil fotoğrafı
- LinkedIn ya da Twitter linkleri eklenebilecek alanlar
- `Add to Calendar`, `Create Reminder` gibi aksiyonlar

---

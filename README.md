# iOS Roadmap  

## Branch Yapısı  

Branch yönetimini düzenli ve temiz tutmak için aşağıdaki yapıyı takip edeceğiz:  

**feature/xxx** → **feature-release/xxx (bugfix/xxx)** → **development** → **release/rc-xx (hotfix/xxx)** → **master (prod)**  

## Önemli Notlar  

- Şu an bu branch yapısına tam olarak geçilmiş değil. Şimdilik **feature-release** üzerinden **master**'a PR açılabiliyor. Ancak ilerleyen süreçte yukarıdaki yapıya tam uyum sağlanacak.  
- **Doğrudan master'a PR açmak yasak!**  
- **feature/xxx'ten doğrudan master'a PR açamazsınız.**  
- **feature/xxx'ten feature-release/xxx'e PR açmak zorunlu.** PR, review sürecinden geçtikten sonra ancak master'a merge edilebilir.  
- DevOps süreci ilerledikçe daha sıkı kurallar getirilecek, hazırlıklı olun!  

---  

# Proje Notları  

- Harici kütüphaneleri kullanmaktan mümkün olduğunca kaçınmalıyız. Ancak belirli durumlarda, **geçici olarak** bazı kütüphaneleri projeye entegre edebiliriz.  
- Amaç, kütüphaneyi bağımlılık haline getirmek değil, içindeki işe yarar kısımları projeye kazandırmak olmalı.  
- **Şu an için projede kullanımı onaylanan tek harici kütüphane:**  
  - **SnapKit**

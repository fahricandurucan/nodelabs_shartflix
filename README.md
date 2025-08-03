# 🎬 ShartFlix

ShartFlix, modern bir film keşif ve favori film yönetim uygulamasıdır. Kullanıcılar filmleri keşfedebilir, favorilerine ekleyebilir ve kişiselleştirilmiş bir deneyim yaşayabilirler.

## ✨ Özellikler

- 🎭 **Film Keşfi**: Popüler filmleri keşfedin
- ❤️ **Favori Filmler**: Beğendiğiniz filmleri favorilerinize ekleyin
- 👤 **Profil Yönetimi**: Kişisel profil bilgilerinizi yönetin
- 📸 **Fotoğraf Yükleme**: Profil fotoğrafınızı yükleyin
- 🌍 **Çoklu Dil Desteği**: Türkçe ve İngilizce dil desteği
- 🔐 **Güvenli Kimlik Doğrulama**: Güvenli giriş ve kayıt sistemi
- 📱 **Modern UI/UX**: Netflix benzeri modern arayüz

## 🛠️ Teknoloji Stack'i

### Flutter & Dart
- **Flutter Version**: 3.24.4
- **Dart Version**: ^3.5.4
- **Platform**: iOS, Android

### State Management

### Navigation

### Network & API

### Local Storage

### UI Components



## 🚀 Kurulum

### Gereksinimler

- **Flutter SDK**: 3.24.4
- **Dart SDK**: ^3.5.4
- **Android Studio** veya **VS Code**
- **Git**

### Adım 1: Flutter Kurulumu

```bash


cd nodelabs_shartflix

fvm install 3.24.4
fvm use 3.24.4
```

### Adım 2: Bağımlılıkları Yükle

```bash
# Flutter bağımlılıklarını yükle
fvm flutter pub get

# Code generation için
fvm flutter packages pub run build_runner build
```

### Adım 3: Uygulamayı Çalıştır

```bash
# iOS Simulator için
fvm flutter run -d ios

# Android Emulator için
fvm flutter run -d android

# Web için
fvm flutter run -d chrome
```

## 📁 Proje Yapısı

```
lib/
├── core/                          # Core utilities
│   ├── constants/                 # App constants
│   ├── routes/                    # App routing
│   ├── services/                  # API services
│   └── widgets/                   # Shared widgets
├── features/                      # Feature modules
│   ├── auth/                      # Authentication
│   │   ├── data/                  # Data layer
│   │   ├── domain/                # Business logic
│   │   └── presentation/          # UI layer
│   ├── home/                      # Home screen
│   ├── movies/                    # Movies feature
│   └── profile/                   # Profile management
└── main.dart                      # App entry point
```

### Feature Modülleri

#### 🔐 Auth Module
- Giriş/Kayıt işlemleri
- Profil fotoğrafı yükleme
- Çoklu dil desteği
- BLoC pattern ile state management

#### 🎬 Movies Module
- Film listesi görüntüleme
- Favori film yönetimi
- Film detayları
- Arama ve filtreleme

#### 👤 Profile Module
- Kullanıcı profil yönetimi
- Fotoğraf yükleme
- Ayarlar ve tercihler

#### 🏠 Home Module
- Ana sayfa
- Keşif özellikleri
- Navigasyon

## 🌍 Çoklu Dil Desteği

Uygulama Türkçe ve İngilizce dillerini destekler:

```
assets/lang/
├── tr-TR.json     # Türkçe çeviriler
└── en-US.json     # İngilizce çeviriler
```

### Yeni Çeviri Ekleme

```json
// tr-TR.json
{
  "key_name": "Türkçe metin"
}

// en-US.json
{
  "key_name": "English text"
}
```

## 🔧 Geliştirme

### Code Generation

```bash
# Model sınıfları için
fvm flutter packages pub run build_runner build


```


## 🎨 UI/UX Özellikleri

- **Netflix benzeri tasarım**
- **Dark theme**
- **Responsive layout**
- **Smooth animations**
- **Loading states**
- **Error handling**

## 🔐 Güvenlik

- **JWT token authentication**
- **Secure API communication**
- **Local data encryption**
- **Input validation**

## 📦 Build & Deploy

### Android

```bash
# Release build
fvm flutter build apk --release

# App bundle
fvm flutter build appbundle --release
```

### iOS

```bash
# Release build
fvm flutter build ios --release
```
 

# 🔐 Vault App - خزنة الملفات الآمنة

تطبيق Android لإخفاء الصور والفيديوهات والملفات بشكل آمن داخل جهازك.

## ✨ المميزات

- 🔒 **حماية مزدوجة** — بصمة الإصبع + PIN من 4 أرقام
- 🖼️ **صور وفيديو** — عرض بشاشة كاملة مع تكبير/تصغير
- 📁 **كل أنواع الملفات** — PDF، صوت، مستندات، وغيرها
- 👁️ **إخفاء فوري** — الملفات تختفي من الجاليري فور إضافتها
- ♻️ **استعادة سهلة** — رجّع أي ملف لمكانه الأصلي بضغطة
- 🎭 **تمويه** — اسم التطبيق "Calculator" في الشاشة الرئيسية
- 🚫 **مش بيظهر في الـ Recents** — خصوصية إضافية

## 🏗️ التقنيات

| التقنية | الاستخدام |
|---------|-----------|
| Flutter | إطار العمل الأساسي |
| local_auth | البصمة وأمان الجهاز |
| flutter_secure_storage | تخزين PIN مشفر |
| photo_view | عرض الصور بشاشة كاملة |
| chewie + video_player | تشغيل الفيديو |
| file_picker | اختيار الملفات |
| path_provider | إدارة مسارات التخزين |

## 🚀 تشغيل المشروع محلياً

```bash
# 1. Clone الريبو
git clone https://github.com/YOUR_USERNAME/vault_app.git
cd vault_app

# 2. تثبيت الـ dependencies
flutter pub get

# 3. تشغيل على جهاز/محاكي
flutter run
```

## 📦 بناء APK

```bash
# APK عادي للتجربة
flutter build apk --debug

# APK نهائي
flutter build apk --release --obfuscate --split-debug-info=build/symbols
```

## ⚙️ CodeMagic Setup

1. ارفع الكود على GitHub
2. ادخل على [codemagic.io](https://codemagic.io) وربط الريبو
3. الـ `codemagic.yaml` موجود وجاهز — CodeMagic هيلاقيه تلقائياً
4. غير الإيميل في `codemagic.yaml` لإيميلك
5. ابدأ البناء!

## 📂 هيكل المشروع

```
lib/
├── main.dart                 # نقطة البداية والـ theme
├── models/
│   └── vault_file.dart       # موديل الملف المخفي
├── services/
│   ├── vault_service.dart    # منطق الإخفاء والاستعادة
│   └── auth_service.dart     # البصمة والـ PIN
└── screens/
    ├── auth_screen.dart      # شاشة الدخول
    ├── setup_pin_screen.dart # إعداد PIN أول مرة
    ├── home_screen.dart      # الشاشة الرئيسية
    ├── gallery_screen.dart   # عرض الصور/الفيديوهات
    ├── viewer_screen.dart    # عارض الشاشة الكاملة
    └── files_screen.dart     # قائمة الملفات
```

## 🔐 كيف يعمل الإخفاء؟

1. الملف بيتنقل لمجلد مخفي داخل بيانات التطبيق الخاصة
2. بيتسمى بـ UUID عشوائي وامتداد `.vault` — مش قابل للفتح من برا
3. ملف `.nomedia` بيمنع الجاليري من مسحه
4. الأندرويد مش بيديك وصول للمجلد ده من غير روت

## ⚠️ ملاحظات

- الملفات بتتحذف من مكانها الأصلي لما تتضاف للخزنة
- لو مسحت التطبيق، الملفات المخفية هتتحذف معاه
- اعمل backup دايماً لملفاتك المهمة

---

Made with ❤️ using Flutter

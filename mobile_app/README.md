# تطبيق توثيق أشجار لبنه بارشيد

تشغيل محلي:
1. ثبت Flutter: https://flutter.dev/docs/get-started/install
2. افتح الطرفية داخل مجلد المشروع:
   cd mobile_app
3. احصل على الحزم:
   flutter pub get
4. شغّل التطبيق على جهاز أو محاكي:
   flutter run

بناء APK محليًا:
flutter build apk --debug
الملف الناتج:
mobile_app/build/app/outputs/flutter-apk/app-debug.apk

ملاحظة: أضفت GitHub Actions لبناء APK عند كل push إلى main.

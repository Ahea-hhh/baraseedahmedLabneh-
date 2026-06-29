import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class TreeItem {
  final String name;
  final String imagePath;
  TreeItem({required this.name, required this.imagePath});

  Map<String, dynamic> toJson() => {'name': name, 'imagePath': imagePath};
  static TreeItem fromJson(Map<String, dynamic> j) => TreeItem(
        name: j['name'] as String,
        imagePath: j['imagePath'] as String,
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دليل لبنه بارشيد - الأشجار',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage>Storage() async {
    appDir = await getApplicationDocumentsDirectory();
    await _loadTrees();
  }

  Future<File> get _storageFile async {
    return File('${appDir.path}/$storageFileName');
  }

  Future<void> _loadTrees() async {
    try {
      final f = await _storageFile;
      if (await f.exists()) {
        final content = await f.readAsString();
        final List<dynamic> data = jsonDecode(content);
        setState(() {
          trees = data.map((e) => TreeItem.fromJson(e as Map<String, dynamic>)).toList();
        });
      }
    } catch (e) {
      // ignore read errors
    }
  }

  Future<void> _saveTrees() async {
    final f = await _storageFile;
    final encoded = jsonEncode(trees.map((t) => t.toJson()).toList());
    await f.writeAsString(encoded);
  }

  Future<void> _addTree() async {
    String name = '';
    XFile? picked;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          Future<void> _pickImage() async {
            final XFile? image = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
            setDialogState
mkdir -p .github/workflows
cat > .github/workflows/build_apk.yml <<'EOF'
name: Build APK

on:
  push:
    branches: [ main ]

jobs:
  build-apk:
    runs-on: ubuntu-latest
    env:
      JAVA_HOME: /usr/lib/jvm/java-11-openjdk-amd64
      ANDROID_HOME: ${{ runner.temp }}/android-sdk
      ANDROID_SDK_ROOT: ${{ runner.temp }}/android-sdk

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Java 11
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '11'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'

      - name: Install Android commandline tools
        run: |
          sudo apt-get update
          sudo apt-get install -y unzip wget
          mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
          wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline.zip
          unzip -q cmdline.zip -d $ANDROID_SDK_ROOT/cmdline-tools
          mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest
          export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
          yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses || true
          sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platform-tools" "platforms;android-33" "build-tools;33.0.0"

      - name: Flutter pub get
        run: flutter pub get
        working-directory: mobile_app

      - name: Build debug APK
        run: flutter build apk --debug
        working-directory: mobile_app

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: lbna_parshid-apk
          path: mobile_app/build/app/outputs/flutter-apk/app-debug.apk

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:gallery_picker/gallery_picker.dart';

class ScanPickerScreeen extends StatefulWidget {
  const ScanPickerScreeen({super.key});

  @override
  State<ScanPickerScreeen> createState() => _ScanPickerScreeenState();
}

class _ScanPickerScreeenState extends State<ScanPickerScreeen> {
  File? selectedFile;
  final picker = ImagePicker();
  String? money;

  void pickImage() async {
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      selectedFile = File(pickerFile.path);
      final data = await extractFile(selectedFile!);
      setState(() {
        money = data;
      });
    }
  }

  Future<String> extractFile(File file) async {
    final textRecornized = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecornized.processImage(inputImage);
    String text = recognizedText.text;
    log("Text: $text");
    return extractAmountFromText(text) ?? "";
  }

  String? extractAmountFromText(String text) {
    final regex = RegExp(r'(\d{1,3}(?:,\d{3})*)\s*VND');
    final match = regex.firstMatch(text);

    if (match != null) {
      String amountStr = match.group(1)!.replaceAll(',', '');
      return amountStr;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Text"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickImage();
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: selectedFile == null
                ? Text("No Image")
                : SizedBox(
                    height: 500,
                    width: 300,
                    child: Image.file(selectedFile!),
                  ),
          ),
          Text(money != null ? money! : "")
        ],
      ),
    );
  }
}

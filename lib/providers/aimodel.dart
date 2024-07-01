import 'dart:ui';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mad_project/models/file_object.dart';
import 'dart:io';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:syncfusion_flutter_pdf/pdf.dart';

const apiKey = "AIzaSyAx5PgOrh-LaE1_1iXx9YmCKrOrEem-sLE";

class Model {
  final FileObject? file;
  final List<FileObject>? fileList;
  Model({this.file, this.fileList});

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  void generateSummaryforText() async {
    final prompt =
        TextPart('Can you summarise this given text and what it says?');

    final pdfFile = File(file!.filePath);

    final PdfDocument document =
        PdfDocument(inputBytes: pdfFile.readAsBytesSync());

    final TextPart text = TextPart(PdfTextExtractor(document).extractText());

    final content = Content.multi([prompt, text]);
    final response = await model.generateContent([content]);

    print(response.text);
  }

  void generateSummaryforImages() async {
    final prompt =
        TextPart('Can you summarise this given text and what it says?');
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer
        .processImage(InputImage.fromFilePath(file!.filePath));
    final TextPart text = TextPart(recognizedText.text.toString());

    final content = Content.multi([prompt, text]);
    final response = await model.generateContent([content]);

    print(response.text);
  }

  void generateSummaryforImageList() async {
    final prompt = TextPart(
        'Can you summarise this text that has been extracted from multiple images? Use that context to interpret what the text within the images are saying');
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    const List<TextPart> ls = [];
    for (var f in fileList!) {
      final RecognizedText recognizedText = await textRecognizer
          .processImage(InputImage.fromFilePath(f!.filePath));
      ls.add(TextPart(recognizedText.text.toString()));
    }

    final content = Content.multi([prompt, ...ls]);
    final response = await model.generateContent([content]);

    print(response.text);
  }
}

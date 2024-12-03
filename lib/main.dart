import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mobile.dart' if (dart.library.html) 'web.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _createPdf(),
          child: Text("Create"),
        ),
      ),
    );
  }

  Future<void> _createPdf() async {
    if (kDebugMode) print('create');

    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    

    // page.graphics.drawString(
    //       'Hello world!',
    //       PdfStandardFont(PdfFontFamily.helvetica, 12,
    //           style: PdfFontStyle.bold),
    //       bounds: Rect.fromLTWH(0, 0, 200, 50),
    //       brush: PdfBrushes.red,
    //       pen: PdfPens.blue,
    //       format: PdfStringFormat(alignment: PdfTextAlignment.left));

    page.graphics.drawString("hello world", PdfStandardFont(PdfFontFamily.helvetica, 24));

    page.graphics.drawImage(PdfBitmap(await readImageData('IMG_5504.jpeg')), Rect.fromLTWH(0, 50, 450, 550));

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 2, right: 2, top: 2, bottom: 2),
      // cellSpacing: 2,
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'ID';
    header.cells[1].value = 'Name';
    header.cells[2].value = 'Designation';

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'E01';
    row.cells[1].value = 'Clay';
    row.cells[2].value = 'Developer';

    row = grid.rows.add();
    row.cells[0].value = 'E02';
    row.cells[1].value = 'John';
    row.cells[2].value = 'Tester';

    // grid.draw(page: page, bounds: Rect.fromLTWH(0, 600, 450, 100));
    grid.draw(page: document.pages.add(), bounds: Rect.fromLTWH(0, 0, 0, 0));

    
    List<int> bytes = await document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'Output.pdf');
  }

  Future<Uint8List>  readImageData(String name) async {
    final data = await rootBundle.load('images/$name');
    return data.buffer.asUint8List();
  }
}

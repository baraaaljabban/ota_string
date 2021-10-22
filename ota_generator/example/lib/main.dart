import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'ota_string_bloc.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _otaStringBloc = OtaStringBloc();

  var txtStyle = TextStyle(
    fontSize: 45,
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white,
  );

  var txtAltStyle = TextStyle(
    fontSize: 20,
    foreground: Paint()
      ..strokeWidth = 1
      ..color = Colors.white,
  );

  var boxDecorationBg = BoxDecoration(
    border: Border.symmetric(horizontal: BorderSide(color: Colors.white60)),
    boxShadow: [
      BoxShadow(
        color: Colors.black45,
        blurRadius: 10.0,
        spreadRadius: 0.0,
      ),
    ],
    color: Colors.black38,
  );

  var btnStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.black26),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.network(
                'https://picsum.photos/id/257/960/1440',
                fit: BoxFit.cover,
              )
          ),
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<String>(
                stream: _otaStringBloc.stringObservable,
                builder: (context, AsyncSnapshot<String> snapshot){
                  if(snapshot.hasData){
                    return Container(
                      width: double.infinity,
                      decoration: boxDecorationBg,
                      child: Text(
                        snapshot.data!,
                        textAlign: TextAlign.center,
                        style: txtStyle,
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  // defaultColumnWidth: [1,1],
                  columnWidths: {
                    0: FixedColumnWidth(100),
                    1: FlexColumnWidth(),
                  }, children: [
                  _buildPrintTextSection(),
                  _buildSetLanguageSection(),
                  _buildUpdateTranslationSection()
                ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildSetLanguageSection() {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text('Set Lang',  style: txtAltStyle,)
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _otaStringBloc.loadEn();
                },
                style: btnStyle,
                child: Text('Eng'),
              ),
            ),
            SizedBox(width: 4,),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _otaStringBloc.loadKlingon();
                },
                style: btnStyle,
                child: Text('Klingon'),
              ),
            ),
            SizedBox(width: 4,),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _otaStringBloc.loadZh();
                },
                style: btnStyle,
                child: Text('Zh'),
              ),
            ),
          ],
        ),
      ),
    ]
    );
  }

  TableRow _buildPrintTextSection() {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text('Print Text',  style: txtAltStyle,)
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _otaStringBloc.getHiString();
                },
                style: btnStyle,
                child: Text('Greeting'),
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _otaStringBloc.getIntroductionString();
                },
                style: btnStyle,
                child: Text('Introduction'),
              ),
            ),
          ],
        ),
      ),
    ]
    );
  }

  TableRow _buildUpdateTranslationSection() {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text('Update',  style: txtAltStyle,)
      ),
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                _otaStringBloc.updateData();
              },
              style: btnStyle,
              child: Text('Update String'),
            ),
          ],
        ),
      ),
    ]
    );
  }
}

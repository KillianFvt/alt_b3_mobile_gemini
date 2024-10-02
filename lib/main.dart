import 'package:atl_b3_mobile/sections/chat.dart';
import 'package:atl_b3_mobile/sections/chat_stream.dart';
import 'package:atl_b3_mobile/sections/embed_batch_contents.dart';
import 'package:atl_b3_mobile/sections/embed_content.dart';
import 'package:atl_b3_mobile/sections/response_widget_stream.dart';
import 'package:atl_b3_mobile/sections/stream.dart';
import 'package:atl_b3_mobile/sections/text_and_image.dart';
import 'package:atl_b3_mobile/sections/text_only.dart';
import 'package:atl_b3_mobile/widgets/gemini_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  /// flutter run --dart-define=apiKey='Your Api Key'
  Gemini.init(
      apiKey: const String.fromEnvironment('apiKey'), enableDebugging: true);

  // Gemini.reInitialize(apiKey: "new api key", enableDebugging: false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Gemini',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          cardTheme: CardTheme(color: Colors.blue.shade900)),
      home: const MyHomePage(),
    );
  }
}

class SectionItem {
  final int index;
  final String title;
  final Widget widget;

  SectionItem(this.index, this.title, this.widget);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedItem = 3;

  final _sections = <SectionItem>[
    SectionItem(0, 'Stream text', const SectionTextStreamInput()),
    SectionItem(1, 'textAndImage', const SectionTextAndImageInput()),
    SectionItem(2, 'chat', const SectionChat()),
    SectionItem(3, 'Gemini 1.2', const SectionStreamChat()),
    SectionItem(4, 'text', const SectionTextInput()),
    SectionItem(5, 'embedContent', const SectionEmbedContent()),
    SectionItem(6, 'batchEmbedContents', const SectionBatchEmbedContents()),
    SectionItem(
        7, 'response without setState()', const ResponseWidgetSection()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeminiAppBar(
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(_selectedItem == 0 ?
            'Flutter Gemini' : _sections[_selectedItem].title,
            style: const TextStyle(
                fontSize: 24.0, fontWeight: FontWeight.w500, color: Colors.white
            )
          ),
          // actions: [
          //   PopupMenuButton<int>(
          //     initialValue: _selectedItem,
          //     onSelected: (value) => setState(() => _selectedItem = value),
          //     itemBuilder: (context) => _sections.map((e) {
          //       return PopupMenuItem<int>(value: e.index, child: Text(e.title));
          //     }).toList(),
          //     child: const Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Icon(
          //         Icons.more_vert_rounded,
          //         color: Colors.white,
          //       ),
          //     ),
          //   )
          // ],
        ),
      ),

      body: IndexedStack(
        index: _selectedItem,
        children: _sections.map((e) => e.widget).toList(),
      ),
    );
  }
}

import 'package:atl_b3_mobile/widgets/chat_input_box.dart';
import 'package:atl_b3_mobile/widgets/chat_suggestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';

import '../colors.dart';

class SectionTextInput extends StatefulWidget {
  const SectionTextInput({super.key});

  @override
  State<SectionTextInput> createState() => _SectionTextInputState();
}

class _SectionTextInputState extends State<SectionTextInput> {
  final TextEditingController controller = TextEditingController();
  final Gemini gemini = Gemini.instance;
  String? searchedText, result;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (searchedText != null) MaterialButton(
              color: Colors.blue.shade700,
              onPressed: () {
                setState(() {
                  searchedText = null;
                  result = null;
                });
              },
              child: Text('search: $searchedText')
        ),

        Expanded(
            child: loading ? Lottie.asset('assets/lottie/ai.json')
                : result != null ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Markdown(data: result!),
            ) : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: geminiGradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Text(
                                'Hello there!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: '\n'),
                          const TextSpan(
                            text: 'How can I help you?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            )
        ),
        ChatInputBox(
          controller: controller,
          onSend: () {
            if (controller.text.isNotEmpty) {
              searchedText = controller.text;
              controller.clear();
              loading = true;

              gemini.text(searchedText!).then((value) {
                result = value?.content?.parts?.last.text;
                loading = false;
              });
            }
          },
        ),
      ],
    );
  }
}

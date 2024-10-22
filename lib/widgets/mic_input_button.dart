import 'package:atl_b3_mobile/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicInputButton extends StatefulWidget {
  const MicInputButton({super.key});

  @override
  State<MicInputButton> createState() => _MicInputButtonState();
}

class _MicInputButtonState extends State<MicInputButton> {

  late final ChatProvider _chatProvider = Provider.of<ChatProvider>(context, listen: false);

  bool _isListening = false;
  bool _loading = false;
  late stt.SpeechToText _speech;
  String _text = '';
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    PermissionStatus status = await Permission.microphone.request();

    if (status.isGranted) {
      if (!_isListening) {
        setState(() => _loading = true);
        bool available = await _speech.initialize(
          onStatus: (val) {
            print('onStatus: $val');
            if (val == 'notListening') {
              setState(() => _isListening = false);
            }
          },
          onError: (val) {
            print('onError: $val');
            setState(() => _isListening = false);
          },
        );
        setState(() => _loading = false);
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            localeId: 'fr_FR',
            onResult: (val) => setState(() {
              _text = val.recognizedWords;
              _chatProvider.controller.text = _text;
            }),
            onSoundLevelChange: (level) => setState(() {
              _volume = level;
            }),
          );
        }
      } else {
        setState(() => _isListening = false);
        _speech.stop();
      }
    } else {
      print('Permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: MaterialButton(
        onPressed: _listen,
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        color: Colors.transparent,
        splashColor: Colors.red,
        elevation: 0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: _isListening ? (_volume * 5).clamp(25, double.infinity) : 40,
          height: _isListening ? (_volume * 5).clamp(25, double.infinity) : 40,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _isListening ? const Color(0xFF0D47A1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3.5,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                  : Icon(_isListening ? Icons.mic_off_rounded : Icons.mic_rounded),
            ),
          ),
        ),

      ),
    );
  }
}
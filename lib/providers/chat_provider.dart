import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatProvider extends ChangeNotifier {
  final List<Content> _chats = [];
  final _controller = TextEditingController();
  final _gemini = Gemini.instance;
  final FocusNode _focusNode = FocusNode();

  bool _loading = false;
  int? _updatingIndex;

  List<Content> get chats => _chats;
  TextEditingController get controller => _controller;
  bool get loading => _loading;
  FocusNode get focusNode => _focusNode;
  int? get updatingIndex => _updatingIndex;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set updatingIndex(int? newIndex) {
    _updatingIndex = newIndex;
    notifyListeners();
  }

  void sendChat() {
  if (_controller.text.isNotEmpty) {
    final searchedText = _controller.text;

    if (_updatingIndex != null) {
      _chats[_updatingIndex!] = Content(
        role: 'user',
        parts: [Parts(text: searchedText)],
      );
    } else {
      _chats.add(Content(
        role: 'user',
        parts: [Parts(text: searchedText)],
      ));
      // Add an empty Content object for the model's response
      _chats.add(Content(
        role: 'model',
        parts: [Parts(text: '')],
      ));
    }
    notifyListeners();

    _controller.clear();
    _loading = true;
    notifyListeners();

    if (_updatingIndex != null) {
      _chats[_updatingIndex! + 1].parts!.last.text = '';
      notifyListeners();
    }

    _gemini.streamChat((_updatingIndex != null) ?
      [Content(role: 'user', parts: [Parts(text: searchedText)])] : _chats,
    ).listen((value) {
      if (kDebugMode) {
        print("-------------------------------");
        print(value.output);
      }
      _loading = false;
      notifyListeners();
      if (_updatingIndex != null && _updatingIndex! + 1 < _chats.length) {
        _chats[_updatingIndex! + 1].parts!.last.text =
        '${_chats[_updatingIndex! + 1].parts!.last.text}${value.output}';
      } else if (chats.isNotEmpty && chats.last.role == value.content?.role) {
        chats.last.parts!.last.text =
        '${chats.last.parts!.last.text}${value.output}';
      } else {
        chats.add(Content(
          role: 'model',
          parts: [Parts(text: value.output)],
        ));
      }
      _updatingIndex = null;
      notifyListeners();
    });
  }
}
}
import 'package:atl_b3_mobile/widgets/mic_input_button.dart';
import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';

import '../colors.dart';

class ChatInputBox extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend, onClickCamera;
  final FocusNode? focusNode;

  const ChatInputBox({
    super.key,
    this.controller,
    this.onSend,
    this.onClickCamera,
    this.focusNode,
  });

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}

class _ChatInputBoxState extends State<ChatInputBox> {

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF141218),
        border: Border(
          top: BorderSide(
            color: Color(0xFF2D2A2E),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.onClickCamera != null)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                  onPressed: widget.onClickCamera,
                  color: Theme.of(context).colorScheme.onSecondary,
                  icon: const Icon(Icons.file_copy_rounded)
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  minLines: 1,
                  maxLines: 6,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
            ),
          ),

          const MicInputButton(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: AnimatedGradientBorder(
              borderRadius: BorderRadius.circular(15),
              gradientColors: geminiGradientColors,

              glowSize: 2,
              borderSize: 0,

              child: FloatingActionButton.small(
                backgroundColor: const Color(0xFF141218),
                onPressed: widget.onSend,
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

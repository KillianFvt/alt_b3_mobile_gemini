import 'package:atl_b3_mobile/providers/chat_provider.dart';
import 'package:atl_b3_mobile/widgets/loading_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {

  late final ChatProvider _chatProvider = Provider.of<ChatProvider>(context, listen: false);

  @override
  void initState() {
    _chatProvider.controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Content content = _chatProvider.chats[widget.index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: content.role == 'model' ?
            const LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xFF1E3C72),
                Color(0xFF2A5298),
              ],
            ) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: content.role == 'model'
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.end,
                  children: [
                    if (content.role == 'model') SvgPicture.asset(
                      'assets/icons/icon_ai.svg',
                      width: 16,
                      height: 16,
                    ),

                    if (content.role == 'model') const SizedBox(width: 8),

                    if (content.role != 'model') IconButton(
                      icon: Icon(
                        (_chatProvider.updatingIndex != null &&
                        _chatProvider.updatingIndex == widget.index) ?
                          Icons.cancel_rounded : Icons.edit_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      iconSize: 18,

                      onPressed: () {

                        if (_chatProvider.updatingIndex != null) {
                          _chatProvider.updatingIndex = null;
                          _chatProvider.controller.clear();
                          _chatProvider.focusNode.unfocus();
                        } else {
                          _chatProvider.controller.text = content.parts?.lastOrNull?.text ?? '';
                          _chatProvider.updatingIndex = widget.index;
                          _chatProvider.focusNode.requestFocus();
                        }


                      },
                    ),

                    if (content.role != 'model') const Spacer(),

                    Text(
                        content.role == 'model' ? 'Gemini' : 'You',
                        textAlign: content.role == 'model'
                            ? TextAlign.left
                            : TextAlign.right,
                        style: content.role == 'model' ? const TextStyle(
                            color: Colors.white
                        ) : TextStyle(
                            color: Colors.blue.shade800
                        )
                    ),


                    if (content.role != 'model') const SizedBox(width: 8),

                    if (content.role != 'model') CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue.shade800,
                      child: const Text('Y'),
                    ),
                  ],
                ),

                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  clipBehavior: Clip.antiAlias,
                  curve: Curves.easeInOut,
                  child: (content.parts?.lastOrNull?.text != null &&
                      content.parts!.lastOrNull!.text!.isNotEmpty
                  ) ? Markdown(
                      shrinkWrap: true,
                      selectable: true,
                      physics: const NeverScrollableScrollPhysics(),
                      data: (_chatProvider.updatingIndex != null &&
                          _chatProvider.updatingIndex == widget.index) ?
                      _chatProvider.controller.text :
                      content.parts?.lastOrNull?.text ?? 'cannot generate data!'
                  ) : const LoadingResponse(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return _chatProvider.chats[widget.index].parts?.lastOrNull?.text ?? 'cannot generate data!';
  }
}

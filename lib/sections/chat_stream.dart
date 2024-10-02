import 'package:atl_b3_mobile/providers/chat_provider.dart';
import 'package:atl_b3_mobile/widgets/chat_input_box.dart';
import 'package:atl_b3_mobile/widgets/chat_item.dart';
import 'package:atl_b3_mobile/widgets/hello_there_text.dart';
import 'package:atl_b3_mobile/widgets/loading_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chat_suggestions.dart';

class SectionStreamChat extends StatefulWidget {
  const SectionStreamChat({super.key});

  @override
  State<SectionStreamChat> createState() => _SectionStreamChatState();
}

class _SectionStreamChatState extends State<SectionStreamChat> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ChatProvider(),
        builder: (context, child) {
          return Consumer<ChatProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    Expanded(
                        child: provider.chats.isNotEmpty ? Align(
                          alignment: Alignment.bottomCenter,
                          child: SingleChildScrollView(
                            reverse: true,
                            child: ListView.builder(
                              itemBuilder: chatItem,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.chats.length,
                              reverse: false,
                            ),
                          ),
                        ) : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HelloThereText(),

                                SizedBox(height: 16),

                                ChatSuggestions(),
                              ],
                            )
                        )
                    ),
                    ChatInputBox(
                      controller: provider.controller,
                      onSend: provider.sendChat,
                      focusNode: provider.focusNode,
                    ),
                  ],
                );
              },
          );
        }
    );
  }

  Widget chatItem(BuildContext context, int index) {
    return ChatItem(index: index);
  }
}

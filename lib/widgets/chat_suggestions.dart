import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';

class ChatSuggestions extends StatefulWidget {
  const ChatSuggestions({
    super.key,
  });

  @override
  State<ChatSuggestions> createState() => _ChatSuggestionsState();
}

class _ChatSuggestionsState extends State<ChatSuggestions> {

  late final ChatProvider _chatProvider = Provider.of<ChatProvider>(context, listen: false);

  final List<String> suggestions = [
    'Donnes-moi la recette de la tarte aux pommes.',
    'Comment fabriquer un porte-clé en macramé ?',
    'Quelle est la capitale de la France ?',
    'Liste-moi les ingrédients pour une carbonara.',
    'Quelle est la date de la fête des mères ?',
    'Comment faire un noeud de cravate ?',
    'Quelle est la différence entre un crocodile et un alligator ?',
    'Qu\'est-ce que la photosynthèse ?',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 150, // Adjust the width as needed
              child: Card(
                child: InkWell(
                  onTap: () {
                    _chatProvider.controller.text = suggestions[index];
                    _chatProvider.sendChat();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      suggestions[index],
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
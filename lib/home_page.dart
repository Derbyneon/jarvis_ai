import 'package:flutter/material.dart';
import 'package:jarvis_ai/current_discussion_provider.dart';
import 'package:jarvis_ai/discussion_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'main1.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Jarvis AI powered by Gemini'),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0063ff), // Bleu très pâle en hexadécimal
                Color(0xFF0063ff), // Bleu ciel en hexadécimal
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<DiscussionProvider>(
        builder: (context, discussionProvider, child) {
          final discussions = discussionProvider.discussions;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB3E5FC), // Bleu très pâle en hexadécimal
                  Color(0xFF0063ff), // Bleu ciel en hexadécimal
                ], // Dégradé de bleu très pâle à bleu ciel
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16), // Marge autour de l'image
                  width: 300, // Largeur spécifique
                  height: 300, // Hauteur spécifique
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), // Bords arrondis
                    image: DecorationImage(
                      image: AssetImage('assets/logo_ai.jpeg'),
                      fit: BoxFit
                          .cover, // Ajuster l'image pour remplir le container
                    ),
                  ),
                ),
                Expanded(
                  child: discussions.isEmpty
                      ? Center(
                          child: Text('Pas encore d\'historique'),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: discussions.length,
                          itemBuilder: (context, index) {
                            final discussion = discussions[index];
                            return DiscussionCard(
                              discussion: discussion,
                              onDelete: () {
                                // Supprimer la discussion de la liste
                                discussionProvider.removeDiscussion(index);
                              },
                              onTap: () {
                                // Naviguer vers l'historique de la discussion
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DiscussionPage(discussion),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    final uuid = Uuid();
                    final newDiscussionId1 = uuid.v4(); // Génère un UID unique
                    final discussionProvider =
                        Provider.of<DiscussionProvider>(context, listen: false);
                    discussionProvider.addDiscussion(newDiscussionId1);

                    final currentDiscussionIdProvider =
                        Provider.of<CurrentDiscussionIdProvider>(context,
                            listen: false);
                    final newDiscussionId =
                        discussionProvider.discussions.last.id;
                    currentDiscussionIdProvider
                        .setCurrentDiscussionId(newDiscussionId);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GenerativeAISample()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(top: 20, bottom: 60),
 // Marge en bas
                    width: 110, // Largeur spécifique
                    height: 130, // Hauteur spécifique
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12), // Bords arrondis
                    ),
                    child: Center(
                      child: Text(
                        'Démarrer une nouvelle discussion',
                        textAlign: TextAlign.center, // Centrer le texte
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DiscussionCard extends StatelessWidget {
  final Discussion discussion;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  DiscussionCard({
    required this.discussion,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0063ff), // Bleu très pâle en hexadécimal
                    Color(0xFF0063ff), // Bleu ciel en hexadécimal
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(discussion.dateTime),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                  Text(
                    discussion.title,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class DiscussionPage extends StatelessWidget {
  final Discussion discussion;

  DiscussionPage(this.discussion);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Discussion du ${DateFormat('dd/MM/yyyy HH:mm').format(discussion.dateTime)}'),
      ),
      body: ListView.builder(
        itemCount: discussion.messages.length,
        itemBuilder: (context, index) {
          final message = discussion.messages[index];
          return MessageBubble(
            message: message.content,
            isUser: message.isUser,
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  MessageBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _inputController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    String email = _inputController.text;

    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Affiche un message de succès ou redirige l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email de réinitialisation envoyé à $email')),
      );
    } catch (e) {
      // Gérer les erreurs d'envoi de l'email
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Mot de passe oublié'),
        ),
        automaticallyImplyLeading: true,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC), // Bleu très pâle en hexadécimal
              Color(0xFF0063ff), // Bleu ciel en hexadécimal
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _inputController,
                  decoration: InputDecoration(
                    labelText: 'Adresse email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _resetPassword,
                  child: Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0063ff), // Couleur du bouton
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

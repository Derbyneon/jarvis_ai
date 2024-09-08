import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart'; // Assurez-vous que ce fichier existe

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> _signup() async {
    setState(() {
      _emailError = _isValidEmail(_emailController.text) ? null : 'Adresse email invalide';
      _passwordError = _isValidPassword(_passwordController.text) ? null : 'Le mot de passe doit contenir au moins 6 caractères';
      _confirmPasswordError = _passwordController.text == _confirmPasswordController.text ? null : 'Les mots de passe ne correspondent pas';
    });

    if (_emailError == null && _passwordError == null && _confirmPasswordError == null) {
      try {
        // Créer l'utilisateur avec email et mot de passe
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Ajouter l'utilisateur à la collection 'users' dans Firestore
        String uid = userCredential.user!.uid; // Obtenir l'UID de l'utilisateur
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': _emailController.text,
          'nom': '', // Vous pouvez ajouter plus de champs si nécessaire
          'telephone': '', // Ajoutez des champs supplémentaires ici si nécessaire
        });

        // Rediriger vers la page de connexion après inscription
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

      } catch (e) {
        // Gérer les erreurs d'inscription
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Inscription'),
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Adresse email',
                    border: OutlineInputBorder(),
                    errorText: _emailError,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    errorText: _passwordError,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    border: OutlineInputBorder(),
                    errorText: _confirmPasswordError,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text('S\'inscrire'),
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

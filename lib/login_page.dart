import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ai/home_page.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart'; // Assurez-vous que ce fichier existe

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedType = 'Email';
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // Affiche les valeurs dans la console et navigue vers la page d'accueil
    print('Type: $_selectedType');
    print('Input: ${_inputController.text}');
    print('Password: ${_passwordController.text}');
    try {
      if (_selectedType == "Email") {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _inputController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          Fluttertoast.showToast(msg: "Connexion réussie via l'email");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print("afficher le e qui est $e\n le message qui est " + e.code + "\n");
      // Si la connexion échoue, affichez un message d'erreur
      if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(msg: 'Adresse email ou mot de passe incorrect ');
      } else if (e.code == 'invalid-crdential') {
        Fluttertoast.showToast(
            msg: 'Mot de passe incorrect pour cet utilisateur.');
      }
    } catch (e) {
      // Imprimez toutes les autres erreurs dans la console
      print('Une erreur s\'est produite : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Connexion'),
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
                    labelText: _selectedType,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Connexion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0063ff), // Couleur du bouton
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text('Mot de passe oublié'),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text('S\'inscrire'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // Couleur du texte du bouton
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

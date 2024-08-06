import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gojo/firebase_options.dart';

class MyColors {
  Color color1 = const Color(0xFF0a0d16);
  Color color2 = const Color(0xFFABD98B);
  Color color3 = const Color(0xFF84BF5A);
  Color color4 = const Color(0xFF55A603);
  Color color5 = const Color(0xFF18181A);
  Color color6 = const Color(0xF2F2F2F2);
  Color color7 = const Color(0xF25CCC60);
  Color color8 = const Color(0xF23D3F3D);
  Color color9 = const Color(0xF255A603);
  Color color10 = const Color(0xF200EC6D);
  Color color11 = const Color(0xF2999494);
  Color color12 = const Color(0xF2F3EEEE);
}

/* Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = _auth.currentUser;

  runApp(GojoApp(initialPage: user == null ? LoginPage() : HomePage()));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (const Scaffold(
      body: Center(
        child: Text('homee'),
      ),
    ));
  }
}

class GojoApp extends StatelessWidget {
  final Widget initialPage;

  const GojoApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      title: 'Gojo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialPage,
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to the next page on successful login
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

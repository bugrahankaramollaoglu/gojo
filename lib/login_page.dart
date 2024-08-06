import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gojo/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } else {
      print('aa: not worked');
    }
  } catch (e) {
    print('aa: Error: $e');
  }
}

/* Future<void> _signInWithEmailAndPassword(BuildContext context) async {
  try {
    await Auth().signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  } on FirebaseAuthException {
    /*  setState(() {
        errorMessage = e.message;
      }); */
  }
} */

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
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Center(
            child: Text(
              'Gojo, a simple way to\nremember',
              textAlign: TextAlign.center, // Aligns text horizontally
              style: GoogleFonts.kreon(
                textStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Login to your account',
              textAlign: TextAlign.center, // Aligns text horizontally
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 101, 100, 100),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Image.asset('assets/login_photo.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              onPressed: () {
                signInWithGoogle(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/google.png',
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Sign in with Google',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          signinField(
              image: Image.asset(
                'assets/apple.png',
                width: 25,
                height: 25,
              ),
              text: 'Sign in with Apple',
              onPressed: () {}),
          signinField(
            image: Image.asset(
              'assets/email.png',
              width: 25,
              height: 25,
            ),
            text: 'Sign in with email',
            onPressed: () {},
          ),
          SizedBox(height: 40),
          Divider(
            color: Color.fromARGB(255, 187, 190, 191),
            thickness: 1,
            indent: 70,
            endIndent: 70,
          ),
          SizedBox(height: 20),
          Text(
            '\"Şifâhi olmayın, not alın.\"',
            style: GoogleFonts.kreon(
              textStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 213, 217, 218),
              ),
            ),
          ),
          Text(
            'A. Süheyl Ünver',
            style: GoogleFonts.kreon(
              textStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 213, 217, 218),
              ),
            ),
          ),

          // if (_errorMessage != null)
          //   Text(
          //     _errorMessage!,
          //     style: TextStyle(color: Colors.red),
          //   ),
          /* TextField(
            controller: _emailController,
             flutter pub add icons_plus decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ), */
          /* _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ), */
        ],
      ),
    );
  }
}

Widget signinField({
  required Image image,
  required String text,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

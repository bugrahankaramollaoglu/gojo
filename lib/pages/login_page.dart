import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gojo/main.dart';
import 'package:gojo/pages/main_page.dart';
import 'package:gojo/login_forms/register_form.dart';
import 'package:gojo/riverpod_providers.dart';
import 'package:gojo/login_forms/signin_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

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
            MaterialPageRoute(builder: (context) => const MainPage()),
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } finally {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var isShowEmail = ref.watch(showEmailForm);
    var isShowRegister = ref.watch(showRegisterForm);

    Widget currentView;
    if (isShowRegister) {
      currentView = RegisterForm(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
      );
    } else if (isShowEmail) {
      currentView = SignInForm(screenWidth, screenHeight);
    } else {
      currentView = LoginForm(context, ref, screenWidth, screenHeight);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors().color2,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: currentView,
      ),
    );
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (route) => false,
        );
      }
    } else {
      print('Sign in with Google was cancelled or failed.');
    }
  } catch (e) {
    print('Error during Google sign-in: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing in with Google: $e'),
      ),
    );
  }
}

Widget LoginForm(BuildContext context, WidgetRef ref, double screenWidth,
    double screenHeight) {
  return Column(
    children: [
      SizedBox(height: screenHeight / 12),
      Center(
        child: Text(
          'Gojo, a simple way to\nremember',
          textAlign: TextAlign.center,
          style: GoogleFonts.kreon(
            textStyle: TextStyle(
              fontSize: screenWidth / 15,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: Image.asset('assets/login_photo.png'),
        ),
      ),
      signinField(
        image: Image.asset(
          'assets/google.png',
          width: screenWidth / 16,
          height: screenWidth / 16,
        ),
        text: 'Sign in with Google',
        onPressed: () {
          signInWithGoogle(context);
        },
        screenWidth: screenWidth,
      ),
      signinField(
        image: Image.asset(
          'assets/apple.png',
          width: screenWidth / 16,
          height: screenWidth / 16,
        ),
        text: 'Sign in with Apple',
        onPressed: () {},
        screenWidth: screenWidth,
      ),
      signinField(
        image: Image.asset(
          'assets/email.png',
          width: screenWidth / 16,
          height: screenWidth / 16,
        ),
        text: 'Sign in with email',
        onPressed: () {
          ref.read(showEmailForm.notifier).state = !ref.read(showEmailForm);
        },
        screenWidth: screenWidth,
      ),
      SizedBox(height: screenHeight / 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No account? ',
            style: GoogleFonts.lato(
              color: Colors.white54,
              fontSize: screenWidth / 23,
            ),
          ),
          GestureDetector(
            onTap: () {
              ref.read(showRegisterForm.notifier).state =
                  !ref.read(showRegisterForm);
            },
            child: ShimmerEffect(
              baseColor: const Color.fromARGB(255, 82, 135, 179),
              highlightColor: Colors.white70,
              duration: const Duration(milliseconds: 1500),
              child: Text(
                'Sign up',
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 82, 135, 179),
                  fontSize: screenWidth / 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: screenHeight / 30),
      Divider(
        color: Color.fromARGB(255, 187, 190, 191),
        thickness: 1,
        indent: 70,
        endIndent: 70,
      ),
      SizedBox(height: screenHeight / 30),
      Text(
        '"Şifâhi olmayın, not alın."',
        style: GoogleFonts.kreon(
          textStyle: TextStyle(
            fontSize: screenWidth / 21,
            color: Color.fromARGB(255, 213, 217, 218),
          ),
        ),
      ),
      Text(
        'A. Süheyl Ünver',
        style: GoogleFonts.kreon(
          textStyle: TextStyle(
            fontSize: screenWidth / 21,
            color: Color.fromARGB(255, 213, 217, 218),
          ),
        ),
      ),
      SizedBox(height: screenHeight / 30),
    ],
  );
}

Widget signinField({
  required Image image,
  required String text,
  required VoidCallback onPressed,
  required double screenWidth,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image,
            SizedBox(width: screenWidth / 30),
            Text(
              text,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: screenWidth / 25,
                  color: Colors.white70,
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gojo/home_page.dart';
import 'package:gojo/register_form.dart';
import 'package:gojo/riverpod_providers.dart';
import 'package:gojo/signin_form.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    // setState(() {
    //   _isLoading = true;
    //   _errorMessage = null;
    // });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException {
      // setState(() {
      //   _errorMessage = e.message;
      // });
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var isShowEmail = ref.watch(showEmailForm);
    var isShowRegister = ref.watch(showRegisterForm);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: isShowEmail
          ? SignInForm()
          : isShowRegister
              ? RegisterForm()
              : LoginForm(context, ref),
    );
  }
}

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  try {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      // Check if the user is signed in
      if (userCredential.user != null) {
        // Navigate to the home page or another page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Replace HomePage with your actual home page widget
          (route) => false,
        );
      }
    } else {
      // Handle the case where Google Sign-In fails or is cancelled
      print('Sign in with Google was cancelled or failed.');
    }
  } catch (e) {
    // Handle any errors that occur during the sign-in process
    print('Error during Google sign-in: $e');
    // Optionally, show an error message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing in with Google: $e'),
      ),
    );
  }
}

Widget LoginForm(BuildContext context, WidgetRef ref) {
  return Column(
    children: [
      const SizedBox(height: 80),
      Center(
        child: Text(
          'Gojo, a simple way to\nremember',
          textAlign: TextAlign.center,
          style: GoogleFonts.kreon(
            textStyle: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: Text(
          'Login to your account',
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 101, 100, 100),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Image.asset('assets/login_photo.png'),
        ),
      ),
      signinField(
        image: Image.asset(
          'assets/google.png',
          width: 25,
          height: 25,
        ),
        text: 'Sign in with Google',
        onPressed: () {
          signInWithGoogle(context);
        },
      ),
      signinField(
        image: Image.asset(
          'assets/apple.png',
          width: 25,
          height: 25,
        ),
        text: 'Sign in with Apple',
        onPressed: () {},
      ),
      signinField(
        image: Image.asset(
          'assets/email.png',
          width: 25,
          height: 25,
        ),
        text: 'Sign in with email',
        onPressed: () {
          /* navigateWithFadeTransition(
            context,
            SignInEmailPage(), // Replace with the actual page you want to navigate to
          ); */
          ref.read(showEmailForm.notifier).state = !ref.read(showEmailForm);
        },
      ),
      const SizedBox(height: 20),
      RichText(
        text: TextSpan(
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 18,
          ),
          children: <TextSpan>[
            TextSpan(text: 'No account? '),
            TextSpan(
              text: 'Sign up',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors
                    .blue, // Optional: Change color to indicate it's clickable
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Handle the click event here
                  print('Sign up clicked');
                  ref.read(showRegisterForm.notifier).state =
                      !ref.read(showRegisterForm);
                  // Navigate to the sign-up page or show a dialog, etc.
                },
            ),
          ],
        ),
      ),
      const SizedBox(height: 25),
      const Divider(
        color: Color.fromARGB(255, 187, 190, 191),
        thickness: 1,
        indent: 70,
        endIndent: 70,
      ),
      const SizedBox(height: 20),
      Text(
        '"Şifâhi olmayın, not alın."',
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
    ],
  );
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
            const SizedBox(width: 10),
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

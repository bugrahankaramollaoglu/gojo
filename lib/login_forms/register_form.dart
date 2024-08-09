import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gojo/riverpod_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class RegisterForm extends ConsumerStatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const RegisterForm({
    required this.screenWidth,
    required this.screenHeight,
    super.key,
  });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  late final double screenWidth;
  late final double screenHeight;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    screenWidth = widget.screenWidth;
    screenHeight = widget.screenHeight;
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          flex: 2,
          child: Positioned(
            child: Image.asset('assets/lambs.png'),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, screenHeight * 0.3, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.white38,
                        style: const TextStyle(color: Colors.white60),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.transparent,
                          filled: true,
                          labelStyle: TextStyle(color: Colors.white54),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white38),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please enter your email')),
                            );
                            // return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please enter a valid email address')),
                            );
                            // return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight / 40),
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: Colors.white38,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          fillColor: Colors.transparent,
                          filled: true,
                          labelStyle: const TextStyle(color: Colors.white54),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white38),
                          ),
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Icon(
                                _obscureText
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                color: Colors.white54,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white60),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please enter your password')),
                            );
                            return null;
                          }

                          final hasDigit = RegExp(r'\d').hasMatch(value);
                          final isValidLength = value.length >= 8;

                          if (!hasDigit) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Password must contain at least one digit')),
                            );
                            // return 'Password must contain at least one digit';
                          }
                          if (!isValidLength) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Password must be at least 8 characters long')),
                            );
                            // return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight / 40),
                      TextFormField(
                        controller: _confirmPasswordController,
                        cursorColor: Colors.white38,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          fillColor: Colors.transparent,
                          filled: true,
                          labelStyle: const TextStyle(color: Colors.white54),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white70),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white38),
                          ),
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: Icon(
                                _obscureText
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                color: Colors.white54,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(color: Colors.white60),
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Please confirm your password')),
                            );
                            // return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Passwords do not match')),
                            );
                            // return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight / 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.lato(
                              color: Colors.white54,
                              fontSize: screenWidth / 27,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ref.read(showRegisterForm.notifier).state =
                                  !ref.read(showRegisterForm);
                            },
                            child: ShimmerEffect(
                              baseColor:
                                  const Color.fromARGB(255, 82, 135, 179),
                              highlightColor: Colors.white70,
                              duration: const Duration(milliseconds: 1500),
                              child: Text(
                                'Sign in',
                                style: GoogleFonts.lato(
                                  color:
                                      const Color.fromARGB(255, 82, 135, 179),
                                  fontSize: screenWidth / 27,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight / 50),
                      const Divider(
                        color: Colors.white24,
                        thickness: 1,
                        endIndent: 30,
                        indent: 30,
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          minimumSize: const Size(250, 45),
                        ),
                        onPressed: _register,
                        child: Text(
                          'Register',
                          style: GoogleFonts.kreon(
                            fontSize: screenWidth / 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 80),
                      OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          minimumSize: const Size(250, 45),
                        ),
                        onPressed: () {
                          ref.read(showRegisterForm.notifier).state =
                              !ref.read(showRegisterForm);
                        },
                        child: Text(
                          'Go back',
                          style: GoogleFonts.kreon(
                            fontSize: screenWidth / 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight / 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

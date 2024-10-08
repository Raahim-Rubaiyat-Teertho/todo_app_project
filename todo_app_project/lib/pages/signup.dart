import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_project/main.dart';
import 'package:todo_app_project/pages/login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (passwordMatches()) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String userId = userCredential.user!.uid;

        await addUserDetails(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
            _emailController.text.trim(),
            int.parse(_ageController.text.trim()),
            userId);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User created successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        _errorMessage = "The passwords do not match";
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool passwordMatches() {
    return _passwordController.text.trim() ==
        _confirmPasswordController.text.trim();
  }

  Future addUserDetails(String firstName, String lastName, String email,
      int age, String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'age': age,
      'todo': [],
      'done': [],
      'dailys': []
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/images/layered-waves-haikei.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SIGNUP',
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            hintText: 'First Name',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            hintText: 'Last Name',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            hintText: 'Age',
                            border: OutlineInputBorder(),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: const OutlineInputBorder(),
                            hintStyle: const TextStyle(color: Colors.white),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            border: const OutlineInputBorder(),
                            hintStyle: const TextStyle(color: Colors.white),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.white),
                          ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (_emailController.text.isNotEmpty &&
                                      _passwordController.text.isNotEmpty) {
                                    await signUp();
                                  } else {
                                    setState(() {
                                      _errorMessage = 'Please enter all fields';
                                    });
                                  }
                                },
                                child: const Text('Signup'),
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already a member?",
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

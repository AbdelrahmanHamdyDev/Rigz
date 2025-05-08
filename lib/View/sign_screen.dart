import 'package:flutter/material.dart';
import 'package:rigz/ViewModel/sign_ViewModel.dart';

class signScreen extends StatefulWidget {
  const signScreen({super.key, required this.type});

  final String type;

  @override
  State<signScreen> createState() => _signScreenState();
}

class _signScreenState extends State<signScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  bool _obscurePassword = true; // Not visible
  var supabase_Auth = SignViewmodel();
  bool is_SignIn = true;

  @override
  void initState() {
    super.initState();
    is_SignIn = widget.type == "i";
  }

  void _sign(bool SignIn) async {
    if (_formKey.currentState!.validate()) {
      final userEmail = _emailController.text;
      final userPassword = _passwordController.text;
      final userName = _userNameController.text;

      bool response = false;

      if (SignIn) {
        response = await supabase_Auth.signInWithEmailAndPassword(
          userEmail,
          userPassword,
        );
      } else {
        response = await supabase_Auth.signUpWithEmailAndPassword(
          userEmail,
          userPassword,
          userName,
        );
      }

      if (response) {
        //TODO: change the signin condition in the statemanagment (bloc)
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Error")));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (is_SignIn) ? const Text("SignIn") : const Text("SignUp"),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!is_SignIn)
                      TextFormField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                          labelText: 'UserName',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                      onPressed: () {
                        _sign(is_SignIn);
                      },
                      child: Text(is_SignIn ? "Enter" : "Register"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          is_SignIn = !is_SignIn;
                        });
                      },
                      child:
                          (is_SignIn)
                              ? const Text("Create new account?")
                              : const Text("Have an email?"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

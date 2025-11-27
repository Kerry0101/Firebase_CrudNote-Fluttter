import 'package:flutter/material.dart';
import 'package:firebase_crudnote/auth_service.dart';
import 'package:firebase_crudnote/login.dart';

class RegisterPage extends StatefulWidget {

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final AuthService auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12,),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12,),
              ElevatedButton(
                child: loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Register"),
                  onPressed: () async {
                    if(emailController.text.isEmpty || passwordController.text.isEmpty) return;
                    setState(() => loading = true);

                    final user = await auth.registerWithEmail(
                      emailController.text, passwordController.text);

                      setState(()=> loading = false);
                      
                      if (user != null){
                          if (!user.emailVerified){
                            await user.sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Verification email sent. Please check your inbox or spam.")),

                            );
                          }
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (_) => LoginPage()),
                            );
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Registration failed."))
                        );
                      }
                  },
              ),
            ],
          ),
        )
      )
    );
  }
}
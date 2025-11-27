import 'register.dart';
import 'home_page.dart';
import 'package:firebase_crudnote/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService auth = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false; 


  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column (
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
                  : Text ("Login with Email"),
                  onPressed: () async {
                    setState(() => loading = true);
                    final user = await auth.signInWithEmail(
                      emailController.text, passwordController.text);
                      setState(()=> loading = false);

                      if (user != null){
                        if (!user.emailVerified){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please verify your email before logging in."),
                            ),
                          );
                        }else{
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_)=> HomePage()),
                            );
                        }
                      }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid email or password")),
                        );
                      }
                  },
              ),
              SizedBox(height: 24,),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 24,),
              ElevatedButton.icon(icon: Icon(Icons.login_rounded),
              label: Text("Sign in with Google"),
                onPressed:() async{
                  setState(() => loading = true);
                  final user = await auth.signInWithGoogle();
                  setState(()=> loading = false);
                  if (user != null){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_)=> HomePage()),
                      );
                  }
                }
              ),
              SizedBox(height: 12,),
              TextButton(
                child: Text("Don't have an account? Register"),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute (builder: (_)=> RegisterPage()),
                  );
                },
              )
            ],
          )
        )
      ),
    );
  }
}
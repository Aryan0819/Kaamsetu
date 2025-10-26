import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'employer_home_page.dart';
import 'worker_home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _skillsCtrl = TextEditingController();
  String _role = 'user';
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Use 'localhost' for cross-platform compatibility for web requests
    final url = Uri.parse('http://localhost:8000/register');
    final body = json.encode({
      'username': _usernameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'phone': _phoneCtrl.text.trim(),
      'skills': _skillsCtrl.text.trim(),
      'role': _role
    });

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      debugPrint('REGISTER status=${res.statusCode} body=${res.body}');

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        if (_role == 'employer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const EmployerHomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WorkerHomePage()),
          );
        }
      } else {
        final err = json.decode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${err['detail'] ?? res.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height:12),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v)=>v==null||!v.contains('@')?'Invalid email':null,
              ),
              const SizedBox(height:12),
              TextFormField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (v)=>v==null||v.length<6?'Min 6 chars':null,
              ),
              const SizedBox(height:12),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone (optional)'),
              ),
              const SizedBox(height:12),
              TextFormField(
                controller: _skillsCtrl,
                decoration: const InputDecoration(labelText: 'Skills (comma-separated)'),
                validator: (v)=>v==null||v.isEmpty?'Required':null,
              ),
              const SizedBox(height:16),
              DropdownButtonFormField<String>(
                initialValue: _role,
                items: const [
                  DropdownMenuItem(value:'user',child:Text('Job Seeker')),
                  DropdownMenuItem(value:'employer',child:Text('Employer')),
                ],
                onChanged:(v)=>_role=v!,
                decoration:const InputDecoration(labelText:'Register as'),
              ),
              const SizedBox(height:24),
              SizedBox(
                width:double.infinity,
                child:ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator(color:Colors.white)
                      : const Text('Create Account'),
                ),
              ),
              const SizedBox(height:12),
              TextButton(
                onPressed:(){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder:(_)=>const LoginPage()),
                  );
                },
                child:const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

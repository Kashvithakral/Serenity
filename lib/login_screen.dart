import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'theme.dart';
import 'auth_service.dart'; // Import AuthService

class LoginScreen extends StatefulWidget { // Changed to StatefulWidget
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService(); // AuthService instance
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Show error message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    // Attempt to sign in
    dynamic result = await _authService.signIn(email, password);

    if (result == null) {
      // Navigate to signup screen if login fails
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
    } else {
      // Navigate to home screen or show success message
      print('Signed in: ${result.uid}');
      // The AuthWrapper in main.dart will handle navigation to HomeScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primary,
              AppTheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: GoogleFonts.nunito(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 48),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                _buildLoginButton(),
                const SizedBox(height: 16),
                Text(
                  'Forgot Password?',
                  style: GoogleFonts.openSans(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 48),
                _buildSocialLogin(),
                const SizedBox(height: 32),
                _buildSignupLink(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, // Added controller
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller, // Assign controller
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppTheme.accent,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _login, // Call _login method
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.accent,
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: AppTheme.accent.withOpacity(0.5),
      ),
      child: Text(
        'Sign In',
        style: GoogleFonts.openSans(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Removed Google sign-in button
        // _buildSocialButton(FontAwesomeIcons.google),
        const SizedBox(width: 16),
        _buildSocialButton(Icons.apple), // Changed to Icons.apple for simplicity
      ],
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return IconButton(
      onPressed: () {
        // Removed Google sign-in logic
        // if (icon == FontAwesomeIcons.google) {
        //   _signInWithGoogle(); // Call Google sign-in
        // }
        // TODO: Implement Apple sign-in
      },
      icon: Icon(icon), // Changed to Icon for simplicity
      iconSize: 32,
      color: Colors.black54,
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to signup screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      child: Text.rich(
        TextSpan(
          text: "Don't have an account? ",
          style: GoogleFonts.openSans(
            color: Colors.black54,
          ),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: GoogleFonts.openSans(
                color: AppTheme.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

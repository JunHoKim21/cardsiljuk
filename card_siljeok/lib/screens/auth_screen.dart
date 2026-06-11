import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import 'package:card_siljeok/features/main/screens/main_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() {
    if (_authService.currentUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateHome();
      });
    } else {
      _attemptBiometric(); // Option: try biometric if available
    }
  }

  Future<void> _attemptBiometric() async {
    final hasBio = await _authService.hasBiometrics();
    if (!hasBio) return;

    setState(() => _isLoading = true);
    final success = await _authService.authenticate();
    setState(() => _isLoading = false);
    if (success) {
      // Note: Biometrics alone doesn't sign into Firebase.
      // Usually, we'd need a saved Firebase token.
      // For now, if biometric succeeds, we just let them in (if we support local-only mode).
      // But Firebase requires a User. 
      // We will just show the login screen if there's no Firebase user.
    }
  }

  void _navigateHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  Future<void> _signInWithEmail() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (user != null) {
      await SyncService().migrateLocalDataToFirestore();
    }
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (user != null) {
      _navigateHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 실패. 이메일과 비밀번호를 확인하세요.')),
      );
    }
  }

  Future<void> _signUpWithEmail() async {
    setState(() => _isLoading = true);
    final user = await _authService.signUpWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (user != null) {
      _navigateHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 실패.')),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    if (user != null) {
      await SyncService().migrateLocalDataToFirestore();
    }
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (user != null) {
      _navigateHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('구글 로그인 실패.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('로그인 / 가입')), 
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.credit_card, size: 80, color: cs.primary),
                    const SizedBox(height: 24),
                    const Text('카드 실적 메이트', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: '이메일',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '비밀번호',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _signInWithEmail,
                            child: const Text('로그인'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _signUpWithEmail,
                            child: const Text('회원가입'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Google 계정으로 로그인'),
                        onPressed: _signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.secondaryContainer,
                          foregroundColor: cs.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

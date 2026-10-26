import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/responsive_utils.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      DialogUtils.showSuccessSnackBar(context, '登录成功！');
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        context.go('/home');
      }
    } else {
      DialogUtils.showErrorSnackBar(
        context,
        authProvider.error ?? '登录失败，请稍后重试',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(isMobile),
                  SizedBox(height: isMobile ? 32 : 48),
                  _buildLoginCard(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(bool isMobile) {
    return Column(
      children: [
        Container(
          width: isMobile ? 72.0 : 96.0,
          height: isMobile ? 72.0 : 96.0,
          decoration: BoxDecoration(
            gradient: AppColors.blueGradient,
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            boxShadow: AppColors.elevation2Shadow,
          ),
          child: Icon(
            Icons.favorite_rounded,
            size: isMobile ? 40.0 : 52.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isMobile ? 16.0 : 24.0),
        Text(
          '安行伴',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '子女端',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLoginCard(bool isMobile) {
    return Card(
      elevation: isMobile ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 20.0 : 28.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('登录', style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: isMobile ? 20.0 : 28.0),
              CustomTextField(
                controller: _phoneController,
                label: '手机号',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.validatePhone,
              ),
              SizedBox(height: isMobile ? 16.0 : 20.0),
              CustomTextField(
                controller: _passwordController,
                label: '密码',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                validator: Validators.validatePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              SizedBox(height: isMobile ? 24.0 : 32.0),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return FilledButton(
                    onPressed: authProvider.isLoading ? null : _handleLogin,
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('登录'),
                  );
                },
              ),
              SizedBox(height: isMobile ? 16.0 : 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('还没有账号？', style: Theme.of(context).textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text('立即注册'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

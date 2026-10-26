import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/theme/app_theme.dart';
import '../../core/api/api_client.dart';

class SOSScreen extends StatefulWidget {
  final Function(String) onNavigate;

  const SOSScreen({super.key, required this.onNavigate});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen>
    with SingleTickerProviderStateMixin {
  bool _isTriggering = false;
  late AnimationController _pulseController;
  final _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        title: const Text('紧急求助'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.onNavigate('home'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              _buildSOSButton(),
              const SizedBox(height: 32),
              Text(
                '按下按钮将立即通知您的紧急联系人',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _buildInfoCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 240 + _pulseController.value * 20,
              height: 240 + _pulseController.value * 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.dangerColor.withValues(
                  alpha: 0.1 * (1 - _pulseController.value),
                ),
              ),
            ),
            GestureDetector(
              onTap: _isTriggering ? null : _handleSOS,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.dangerColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.dangerColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: _isTriggering
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'SOS',
                            style: AppTheme.heading1.copyWith(
                              color: Colors.white,
                              fontSize: 36,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        children: [
          _buildInfoRow(Icons.phone_outlined, '紧急联系人', '138****0000'),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.location_on_outlined, '当前位置', '获取中...'),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.network_check, '网络状态', '正常'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Text(label, style: AppTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Future<void> _handleSOS() async {
    setState(() => _isTriggering = true);

    try {
      Position? position;
      String locationStr = '未获取';

      try {
        position = await _getCurrentPosition();
        locationStr = '${position.latitude},${position.longitude}';
      } catch (e) {
        debugPrint('Location error: $e');
      }

      final sosData = {
        'profile_id': 1, // TODO: 使用实际档案ID
        'location': locationStr,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _apiClient.triggerSOS(sosData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('紧急求助信号已发送！子女已收到通知'),
            backgroundColor: AppTheme.dangerColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('发送失败：${e.toString()}'),
            backgroundColor: AppTheme.dangerColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTriggering = false);
      }
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}

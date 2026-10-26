import 'package:flutter/material.dart';

// Google Material Design 页面转场动画
class PageTransitions {
  // 标准转场 - 从右到左滑动
  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // 淡入转场
  static Route<T> fadeIn<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  // 缩放转场 - Google 风格
  static Route<T> scaleIn<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;
        var scaleTween = Tween(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: curve));
        var fadeTween = Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }

  // 共享轴转场 - Material Design 推荐
  static Route<T> sharedAxis<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        // Outgoing page
        var outgoingTween = Tween(
          begin: Offset.zero,
          end: const Offset(-0.3, 0.0),
        ).chain(CurveTween(curve: curve));

        // Incoming page
        var incomingTween = Tween(
          begin: const Offset(0.3, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(incomingTween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Container Transform - 容器变换
  static Route<T> containerTransform<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        var scaleTween = Tween(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: curve));
        var fadeTween = Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

// 滚动动画 - Google 风格
class ScrollAnimations {
  // 列表项交错动画
  static Widget staggeredList({
    required int index,
    required Widget child,
    Duration? duration,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration ?? Duration(milliseconds: 200 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: child,
    );
  }

  // 淡入滚动
  static Widget fadeInOnScroll({
    required Widget child,
    required AnimationController controller,
  }) {
    return FadeTransition(opacity: controller, child: child);
  }
}

// 微交互动画
class MicroAnimations {
  // 按钮点击缩放
  static Widget buttonScale({
    required Widget child,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 100),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTapDown: (_) {
          // Scale down animation would be triggered here
        },
        onTapUp: (_) {
          onTap();
        },
        child: child,
      ),
    );
  }

  // 卡片悬浮效果
  static Widget cardHover({required Widget child, bool isHovered = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
      transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
      child: child,
    );
  }

  // 涟漪效果
  static Widget ripple({
    required Widget child,
    required VoidCallback onTap,
    Color? splashColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}

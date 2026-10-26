import 'package:flutter/material.dart';

// Google Material Design 响应式断点
class ResponsiveUtils {
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 840;
  static const double desktopBreakpoint = 1200;

  // 获取设备类型
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // 检查是否是移动设备
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // 检查是否是平板
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  // 检查是否是桌面
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  // 获取响应式值
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  // 获取内容最大宽度
  static double getContentMaxWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width;
    } else if (width < tabletBreakpoint) {
      return 600;
    } else if (width < desktopBreakpoint) {
      return 840;
    } else {
      return 1200;
    }
  }

  // 获取水平边距
  static double getHorizontalPadding(BuildContext context) {
    return responsive<double>(
      context: context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
    );
  }

  // 获取垂直边距
  static double getVerticalPadding(BuildContext context) {
    return responsive<double>(
      context: context,
      mobile: 16,
      tablet: 24,
      desktop: 32,
    );
  }

  // 获取卡片宽度
  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return width - 32; // 移动端留16px边距
    } else if (width < tabletBreakpoint) {
      return 480; // 平板固定宽度
    } else {
      return 520; // 桌面固定宽度
    }
  }

  // 获取字体缩放因子
  static double getFontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return 1.0;
    } else if (width < tabletBreakpoint) {
      return 1.1;
    } else {
      return 1.2;
    }
  }
}

enum DeviceType { mobile, tablet, desktop }

// 响应式布局构建器
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = ResponsiveUtils.getDeviceType(context);
        return builder(context, deviceType);
      },
    );
  }
}

// 响应式容器
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveContainer({super.key, required this.child, this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? ResponsiveUtils.getContentMaxWidth(context),
        ),
        child: child,
      ),
    );
  }
}

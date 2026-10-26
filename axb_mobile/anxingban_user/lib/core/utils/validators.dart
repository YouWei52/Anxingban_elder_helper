class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号';
    }
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
      return '请输入正确的手机号';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 8) {
      return '密码至少8个字符';
    }
    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$',
    ).hasMatch(value)) {
      return '密码需包含大小写字母、数字和特殊字符';
    }
    return null;
  }

  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入昵称';
    }
    if (value.length < 2) {
      return '昵称至少2个字符';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '请输入$fieldName';
    }
    return null;
  }
}

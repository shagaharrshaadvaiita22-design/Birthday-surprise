import 'package:shared_preferences/shared_preferences.dart';

class BirthdayConfig {
  String girlName;
  String password;
  String customMessage;
  String nickname;
  String birthDate;

  BirthdayConfig({
    required this.girlName,
    required this.password,
    required this.customMessage,
    required this.nickname,
    required this.birthDate,
  });

  static Future<BirthdayConfig> load() async {
    final prefs = await SharedPreferences.getInstance();
    return BirthdayConfig(
      girlName: prefs.getString('girlName') ?? 'Likitha',
      password: prefs.getString('password') ?? '22092005',
      customMessage: prefs.getString('customMessage') ??
          'May your day be filled with endless joy, laughter, love, and all the magical moments your heart desires. You deserve the world and more! Happy Birthday! ✨💖',
      nickname: prefs.getString('nickname') ?? 'Liki',
      birthDate: prefs.getString('birthDate') ?? '22-09-2005',
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('girlName', girlName);
    await prefs.setString('password', password);
    await prefs.setString('customMessage', customMessage);
    await prefs.setString('nickname', nickname);
    await prefs.setString('birthDate', birthDate);
  }
}

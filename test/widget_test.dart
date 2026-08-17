import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surprise/main.dart';
import 'package:surprise/models/birthday_config.dart';

void main() {
  testWidgets('Birthday surprise app launches smoke test', (WidgetTester tester) async {
    final config = BirthdayConfig(
      girlName: 'Princess_Likitha',
      password: '22092005',
      customMessage: 'Happy Birthday!',
      nickname: 'Liki',
      birthDate: '22-09-2005',
    );

    await tester.pumpWidget(BirthdaySurpriseApp(config: config));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Birthday Portal'), findsOneWidget);
    expect(find.text('Birthday Girl Name'), findsOneWidget);
    expect(find.text('Hint 💡'), findsOneWidget);
    expect(find.text('Forgot Password? 🔑'), findsOneWidget);

    // Clean up repeating animations before test exit
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Hint button displays catch hint message on tap', (WidgetTester tester) async {
    final config = BirthdayConfig(
      girlName: 'Princess_Likitha',
      password: '22-09-2026',
      customMessage: 'Happy Birthday!',
      nickname: 'Liki',
      birthDate: '22-09-2026',
    );

    await tester.pumpWidget(BirthdaySurpriseApp(config: config));
    await tester.pump(const Duration(milliseconds: 100));

    final hintButton = find.text('Hint 💡');
    expect(hintButton, findsOneWidget);
    await tester.tap(hintButton, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('u should catch for the hint 😜'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Forgot password button displays playful biryani message without showing password', (WidgetTester tester) async {
    final config = BirthdayConfig(
      girlName: 'Princess_Likitha',
      password: 'SECRET_PASSWORD_123',
      customMessage: 'Happy Birthday!',
      nickname: 'Liki',
      birthDate: '22-09-2026',
    );

    await tester.pumpWidget(BirthdaySurpriseApp(config: config));
    // Pump animation forward so floating hint button moves away from the form center
    await tester.pump(const Duration(seconds: 2));

    final forgotBtn = find.text('Forgot Password? 🔑');
    expect(forgotBtn, findsOneWidget);
    await tester.tap(forgotBtn, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('u seriously dont know the password'), findsOneWidget);
    expect(find.textContaining('chicken biryani for password!'), findsOneWidget);
    expect(find.text('SECRET_PASSWORD_123'), findsNothing);

    await tester.pumpWidget(const SizedBox());
  });
}



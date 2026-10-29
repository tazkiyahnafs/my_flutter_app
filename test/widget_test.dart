import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ta3/main.dart';

void main() {
  testWidgets('app opens the drink menu after the splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == 'assets/logo kopi.png',
      ),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Warung IS - Menu'), findsOneWidget);
    expect(find.text('Espresso'), findsOneWidget);

    await tester.tap(find.text('Pesan').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keranjang').first);
    await tester.pumpAndSettle();
    expect(find.text('Espresso'), findsOneWidget);
    expect(find.text('Nama Pemesan'), findsOneWidget);
    expect(find.text('Nomor Meja'), findsOneWidget);

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Nama Pemesan tidak boleh kosong.'), findsOneWidget);
    expect(find.text('Nomor Meja harus berupa angka.'), findsOneWidget);
    expect(find.text('Checkout Berhasil'), findsNothing);

    await tester.enterText(find.byType(TextFormField).first, 'Tazkiyah');
    await tester.enterText(find.byType(TextFormField).last, 'abc');
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Nomor Meja harus berupa angka.'), findsOneWidget);
    expect(find.text('Checkout Berhasil'), findsNothing);

    await tester.enterText(find.byType(TextFormField).last, '21');
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Nomor Meja harus antara 1-20.'), findsOneWidget);
    expect(find.text('Checkout Berhasil'), findsNothing);

    await tester.enterText(find.byType(TextFormField).last, '1');
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Checkout Berhasil'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang Anda kosong.'), findsOneWidget);
  });
}

// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_language_fonts/google_language_fonts.dart';
import 'package:google_language_fonts/src/asset_manifest.dart';
import 'package:google_language_fonts/src/google_fonts_base.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAssetManifest extends Mock implements CustomAssetManifest {}

void main() {
  setUpAll(() {
    assetManifest = MockAssetManifest();
  });
  tearDown(() {
    clearCache();
  });

  //////////////////////////////
  // Derived fontFamily tests //
  //////////////////////////////

  testWidgets('Text style with a direct match is used', (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
    );

    final outputTextStyle = LatinFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto_regular'));
  });

  testWidgets('Text style with an italics direct match is used',
      (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
    );

    final outputTextStyle = LatinFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto_italic'));
  });

  testWidgets('Text style with no direct match picks closest font weight match',
      (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
    );

    final outputTextStyle = LatinFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto_500'));
  });

  testWidgets('Italic text style with no direct match picks closest match',
      (tester) async {
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );

    final outputTextStyle = LatinFonts.roboto(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Roboto_500italic'));
  });

  testWidgets('Text style prefers matching italics to closer weight',
      (tester) async {
    // Cardo has 400regular, 400italic, and 700 regular. Even though 700 is
    // closer in weight, when we ask for 600italic, it will give us 400 italic
    // font family.
    final inputTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );

    final outputTextStyle = LatinFonts.cardo(textStyle: inputTextStyle);

    expect(outputTextStyle.fontFamily, equals('Cardo_italic'));
  });

  testWidgets('Defaults to regular when no Text style is passed',
      (tester) async {
    final outputTextStyle = LatinFonts.lato();

    expect(outputTextStyle.fontFamily, equals('Lato_regular'));
  });

  testWidgets(
      'Defaults to regular when a Text style with no weight or style is passed',
      (tester) async {
    final outputTextStyle = LatinFonts.lato(textStyle: TextStyle());

    expect(outputTextStyle.fontFamily, equals('Lato_regular'));
  });

  ///////////////////////////
  // TextStyle param tests //
  ///////////////////////////

  testWidgets('color is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(color: const Color(0xDEADBEEF));
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.color, equals(const Color(0xDEADBEEF)));
  });

  testWidgets('color is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(color: const Color(0xFACEFEED));

    expect(outputTextStyle.color, equals(const Color(0xFACEFEED)));
  });

  testWidgets(
      'color from the top-level param takes precedence over color '
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(color: const Color(0xDEADBEEF));
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      color: const Color(0xFACEFEED),
    );

    expect(outputTextStyle.color, const Color(0xFACEFEED));
  });

  testWidgets(
      'backgroundColor is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(backgroundColor: const Color(0xDEADBEEF));
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.backgroundColor, equals(const Color(0xDEADBEEF)));
  });

  testWidgets('backgroundColor is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle =
        LatinFonts.rancho(backgroundColor: const Color(0xFACEFEED));

    expect(outputTextStyle.backgroundColor, equals(const Color(0xFACEFEED)));
  });

  testWidgets(
      'backgroundColor from the top-level param takes precedence over '
      'backgroundColor from TextStyle param', (tester) async {
    final textStyle = TextStyle(backgroundColor: const Color(0xDEADBEEF));
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      backgroundColor: const Color(0xFACEFEED),
    );

    expect(outputTextStyle.backgroundColor, const Color(0xFACEFEED));
  });

  testWidgets('fontSize is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(fontSize: 37);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.fontSize, equals(37));
  });

  testWidgets('fontSize is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(fontSize: 31);

    expect(outputTextStyle.fontSize, equals(31));
  });

  testWidgets(
      'fontSize from the top-level param takes precedence over fontSize '
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(fontSize: 37);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      fontSize: 31,
    );

    expect(outputTextStyle.fontSize, equals(31));
  });

  testWidgets('fontWeight is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(fontWeight: FontWeight.w800);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.fontWeight, equals(FontWeight.w800));
  });

  testWidgets('fontWeight is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(fontWeight: FontWeight.w200);

    expect(outputTextStyle.fontWeight, equals(FontWeight.w200));
  });

  testWidgets(
      'fontWeight from the top-level param takes precedence over fontWeight '
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(fontWeight: FontWeight.w800);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      fontWeight: FontWeight.w200,
    );

    expect(outputTextStyle.fontWeight, equals(FontWeight.w200));
  });

  testWidgets('fontStyle is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(fontStyle: FontStyle.normal);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.fontStyle, equals(FontStyle.normal));
  });

  testWidgets('fontStyle is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(fontStyle: FontStyle.italic);

    expect(outputTextStyle.fontStyle, equals(FontStyle.italic));
  });

  testWidgets(
      'fontStyle from the top-level param takes precedence over fontStyle '
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(fontStyle: FontStyle.normal);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      fontStyle: FontStyle.italic,
    );

    expect(outputTextStyle.fontStyle, equals(FontStyle.italic));
  });

  testWidgets('letterSpacing is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(letterSpacing: 0.4);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.letterSpacing, equals(0.4));
  });

  testWidgets('letterSpacing is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(letterSpacing: 0.3);

    expect(outputTextStyle.letterSpacing, equals(0.3));
  });

  testWidgets(
      'letterSpacing from the top-level param takes precedence over '
      'letterSpacing from the TextStyle param', (tester) async {
    final textStyle = TextStyle(letterSpacing: 0.4);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      letterSpacing: 0.3,
    );

    expect(outputTextStyle.letterSpacing, equals(0.3));
  });

  testWidgets('wordSpacing is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(wordSpacing: 0.4);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.wordSpacing, equals(0.4));
  });

  testWidgets('wordSpacing is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(wordSpacing: 0.3);

    expect(outputTextStyle.wordSpacing, equals(0.3));
  });

  testWidgets(
      'wordSpacing from the top-level param takes precedence over wordSpacing '
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(wordSpacing: 0.4);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      wordSpacing: 0.3,
    );

    expect(outputTextStyle.wordSpacing, equals(0.3));
  });

  testWidgets('textBaseline is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(textBaseline: TextBaseline.ideographic);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.textBaseline, equals(TextBaseline.ideographic));
  });

  testWidgets('textBaseline is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle =
        LatinFonts.rancho(textBaseline: TextBaseline.alphabetic);

    expect(outputTextStyle.textBaseline, equals(TextBaseline.alphabetic));
  });

  testWidgets(
      'textBaseline from the top-level param takes precedence over textBaseline'
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(textBaseline: TextBaseline.ideographic);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      textBaseline: TextBaseline.alphabetic,
    );

    expect(outputTextStyle.textBaseline, equals(TextBaseline.alphabetic));
  });

  testWidgets('height is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(height: 33);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.height, equals(33));
  });

  testWidgets('height is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(height: 37);

    expect(outputTextStyle.height, equals(37));
  });

  testWidgets(
      'height from the top-level param takes precedence over height '
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(height: 33);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      height: 37,
    );

    expect(outputTextStyle.height, equals(37));
  });

  testWidgets('locale is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(locale: const Locale('abc'));
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.locale, equals(const Locale('abc')));
  });

  testWidgets('locale is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(locale: const Locale('xyz'));

    expect(outputTextStyle.locale, equals(const Locale('xyz')));
  });

  testWidgets(
      'locale from the top-level param takes precedence over locale '
      'from the TextStyle param', (tester) async {
    final textStyle = TextStyle(locale: const Locale('abc'));
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      locale: const Locale('xyz'),
    );

    expect(outputTextStyle.locale, equals(const Locale('xyz')));
  });

  testWidgets('foreground is honored when passed in via the TextStyle param',
      (tester) async {
    final paint = Paint()..color = const Color(0xDEADBEEF);
    final textStyle = TextStyle(foreground: paint);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.foreground, equals(paint));
  });

  testWidgets('foreground is honored when passed in as a top-level param',
      (tester) async {
    final paint = Paint()..color = const Color(0xFACEFEED);
    final outputTextStyle = LatinFonts.rancho(foreground: paint);

    expect(outputTextStyle.foreground, equals(paint));
  });

  testWidgets(
      'foreground from the top-level param takes precedence over foreground '
      'from the TextStyle param', (tester) async {
    final paint1 = Paint()..color = const Color(0xDEADBEEF);
    final paint2 = Paint()..color = const Color(0xFACEFEED);
    final textStyle = TextStyle(foreground: paint1);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      foreground: paint2,
    );

    expect(outputTextStyle.foreground, equals(paint2));
  });

  testWidgets('background is honored when passed in via the TextStyle param',
      (tester) async {
    final paint = Paint()..color = const Color(0xDEADBEEF);
    final textStyle = TextStyle(background: paint);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.background, equals(paint));
  });

  testWidgets('background is honored when passed in as a top-level param',
      (tester) async {
    final paint = Paint()..color = const Color(0xFACEFEED);
    final outputTextStyle = LatinFonts.rancho(background: paint);

    expect(outputTextStyle.background, equals(paint));
  });

  testWidgets(
      'background from the top-level param takes precedence over background '
      'from the TextStyle param', (tester) async {
    final paint1 = Paint()..color = const Color(0xDEADBEEF);
    final paint2 = Paint()..color = const Color(0xFACEFEED);
    final textStyle = TextStyle(background: paint1);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      background: paint2,
    );

    expect(outputTextStyle.background, equals(paint2));
  });

  testWidgets('shadows is honored when passed in via the TextStyle param',
      (tester) async {
    final shadows = [Shadow(blurRadius: 1)];
    final textStyle = TextStyle(shadows: shadows);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.shadows, equals(shadows));
  });

  testWidgets('shadows is honored when passed in as a top-level param',
      (tester) async {
    final shadows = [Shadow(blurRadius: 2)];
    final outputTextStyle = LatinFonts.rancho(shadows: shadows);

    expect(outputTextStyle.shadows, equals(shadows));
  });

  testWidgets(
      'shadows from the top-level param takes precedence over shadows '
      'from the TextStyle param', (tester) async {
    final shadows1 = [Shadow(blurRadius: 1)];
    final shadows2 = [Shadow(blurRadius: 2)];
    final textStyle = TextStyle(shadows: shadows1);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      shadows: shadows2,
    );

    expect(outputTextStyle.shadows, equals(shadows2));
  });

  testWidgets('fontFeatures is honored when passed in via the TextStyle param',
      (tester) async {
    final fontFeatures = [FontFeature.slashedZero()];
    final textStyle = TextStyle(fontFeatures: fontFeatures);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.fontFeatures, equals(fontFeatures));
  });

  testWidgets('fontFeatures is honored when passed in as a top-level param',
      (tester) async {
    final fontFeatures = [FontFeature.oldstyleFigures()];
    final outputTextStyle = LatinFonts.rancho(fontFeatures: fontFeatures);

    expect(outputTextStyle.fontFeatures, equals(fontFeatures));
  });

  testWidgets(
      'fontFeatures from the top-level param takes precedence over '
      'fontFeatures from the TextStyle param', (tester) async {
    final fontFeatures1 = [FontFeature.slashedZero()];
    final fontFeatures2 = [FontFeature.oldstyleFigures()];
    final textStyle = TextStyle(fontFeatures: fontFeatures1);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      fontFeatures: fontFeatures2,
    );

    expect(outputTextStyle.fontFeatures, equals(fontFeatures2));
  });

  testWidgets('decoration is honored when passed in via the TextStyle param',
      (tester) async {
    final decoration = TextDecoration.underline;
    final textStyle = TextStyle(decoration: decoration);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.decoration, equals(decoration));
  });

  testWidgets('decoration is honored when passed in as a top-level param',
      (tester) async {
    final decoration = TextDecoration.overline;
    final outputTextStyle = LatinFonts.rancho(decoration: decoration);

    expect(outputTextStyle.decoration, equals(decoration));
  });

  testWidgets(
      'decoration from the top-level param takes precedence over '
      'decoration from the TextStyle param', (tester) async {
    final decoration1 = TextDecoration.underline;
    final decoration2 = TextDecoration.overline;
    final textStyle = TextStyle(decoration: decoration1);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      decoration: decoration2,
    );

    expect(outputTextStyle.decoration, equals(decoration2));
  });

  testWidgets(
      'decorationColor is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(decorationColor: const Color(0xDEADBEEF));
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.decorationColor, const Color(0xDEADBEEF));
  });

  testWidgets('decorationColor is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle =
        LatinFonts.rancho(decorationColor: const Color(0xFACEFEED));

    expect(outputTextStyle.decorationColor, equals(const Color(0xFACEFEED)));
  });

  testWidgets(
      'decorationColor from the top-level param takes precedence over '
      'decorationColor from the TextStyle param', (tester) async {
    final textStyle = TextStyle(decorationColor: const Color(0xDEADBEEF));
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      decorationColor: const Color(0xFACEFEED),
    );

    expect(outputTextStyle.decorationColor, equals(const Color(0xFACEFEED)));
  });

  testWidgets(
      'decorationStyle is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(decorationStyle: TextDecorationStyle.dashed);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.decorationStyle, TextDecorationStyle.dashed);
  });

  testWidgets('decorationStyle is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle =
        LatinFonts.rancho(decorationStyle: TextDecorationStyle.dotted);

    expect(outputTextStyle.decorationStyle, equals(TextDecorationStyle.dotted));
  });

  testWidgets(
      'decorationStyle from the top-level param takes precedence over '
      'decorationStyle from the TextStyle param', (tester) async {
    final textStyle = TextStyle(decorationStyle: TextDecorationStyle.dashed);
    final outputTextStyle = LatinFonts.rancho(
      textStyle: textStyle,
      decorationStyle: TextDecorationStyle.dotted,
    );

    expect(outputTextStyle.decorationStyle, equals(TextDecorationStyle.dotted));
  });

  testWidgets(
      'decorationThickness is honored when passed in via the TextStyle param',
      (tester) async {
    final textStyle = TextStyle(decorationThickness: 2);
    final outputTextStyle = LatinFonts.rancho(textStyle: textStyle);

    expect(outputTextStyle.decorationThickness, 2);
  });

  testWidgets(
      'decorationThickness is honored when passed in as a top-level param',
      (tester) async {
    final outputTextStyle = LatinFonts.rancho(decorationThickness: 3);

    expect(outputTextStyle.decorationThickness, equals(3));
  });

  testWidgets(
      'decorationThickness from the top-level param takes precedence over '
      'decorationThickness from the TextStyle param', (tester) async {
    final textStyle = TextStyle(decorationThickness: 2);
    final outputTextStyle =
        LatinFonts.rancho(textStyle: textStyle, decorationThickness: 3);

    expect(outputTextStyle.decorationThickness, equals(3));
  });

  /////////////////////
  // TextTheme tests //
  /////////////////////

  testWidgets('TextTheme method works in the default case', (tester) async {
    final textTheme = LatinFonts.oswaldTextTheme();
    final expectedFamilyWithVariant = 'Oswald_regular';

    expect(textTheme.displayLarge!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.displayMedium!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.displaySmall!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.headlineMedium!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.headlineSmall!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.titleLarge!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.titleMedium!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.titleSmall!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.bodyLarge!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.bodyMedium!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.bodySmall!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.labelLarge!.fontFamily, equals(expectedFamilyWithVariant));
    expect(textTheme.labelSmall!.fontFamily, equals(expectedFamilyWithVariant));
  });

  testWidgets('TextTheme method works with a base textTheme', (tester) async {
    // In app this is usually obtained by Theme.of(context).textTheme.
    final baseTextTheme = TextTheme(
      displaySmall: TextStyle(fontWeight: FontWeight.w700),
      bodyMedium: LatinFonts.acme(),
      titleSmall: TextStyle(fontStyle: FontStyle.italic),
    );

    final textTheme = LatinFonts.oswaldTextTheme(baseTextTheme);
    final expectedFamilyWithVariant = 'Oswald_regular';

    // Default is preserved.
    expect(textTheme.headlineMedium!.fontFamily, equals(expectedFamilyWithVariant));
    // Different font family gets overridden by oswald.
    expect(textTheme.bodyMedium!.fontFamily, equals(expectedFamilyWithVariant));
    // Weight is preserved.
    expect(textTheme.displaySmall!.fontWeight, equals(FontWeight.w700));
    // Style is preserved.
    expect(textTheme.titleSmall!.fontStyle, equals(FontStyle.italic));
  });

  //////////////////
  // Method tests //
  //////////////////

  testWidgets('getFont works with all fonts in GoogleFonts.asMap',
      (tester) async {
    final allFonts = GoogleFonts.asMap().keys;

    for (var fontFamily in allFonts) {
      final dynamicFont = GoogleFonts.getFont(fontFamily);
      expect(dynamicFont.fontFamily, isNotNull);
    }

    expect(allFonts, isNotEmpty);
  });

  testWidgets('getFont returns the correct font', (tester) async {
    final dynamicFont = GoogleFonts.getFont('Roboto Mono');
    final methodFont = LatinFonts.robotoMono();

    expect(dynamicFont, equals(methodFont));
  });

  testWidgets('getTextTheme works with all fonts in GoogleFonts.asMap',
      (tester) async {
    final allFonts = GoogleFonts.asMap().keys;

    for (var fontFamily in allFonts) {
      final dynamicFont = GoogleFonts.getTextTheme(fontFamily);
      expect(dynamicFont.bodyLarge!.fontFamily, isNotNull);
    }

    expect(allFonts, isNotEmpty);
  });

  testWidgets('getTextTheme returns the correct text theme', (tester) async {
    final dynamicTheme = GoogleFonts.getTextTheme('Roboto Mono');
    final methodTheme = LatinFonts.robotoMonoTextTheme();

    expect(dynamicTheme, equals(methodTheme));
  });
}

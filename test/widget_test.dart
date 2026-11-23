import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/data/sample_entries.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/widgets/mood_card.dart';

// Self-check for Lab 4, Exercises 1 and 2. Run it with: flutter test
//
// Both tests fail on the starter code and pass once Exercise 2 is done.
// Exercise 3 changes what the Save button should do. Part of that task is
// to update these tests so they check the new requirement.

/// Renders the app in a window tall enough for every card to be built.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MoodTrackerApp());
}

Finder get saveButton => find.widgetWithText(FilledButton, 'Save entry');

const scoreError = 'Choose a mood score from 1 to 10.';
const noteError = 'Notes can be at most 2000 characters.';

Future<void> tapScore(WidgetTester tester, int score) async {
  await tester.tap(find.widgetWithText(ChoiceChip, '$score'));
  await tester.pump();
}

Future<void> tapSave(WidgetTester tester) async {
  await tester.tap(saveButton);
  await tester.pump();
}

String noteText(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).controller!.text;

bool isScoreSelected(WidgetTester tester, int score) => tester
    .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '$score'))
    .selected;

Finder historyCardWithText(String text) => find.descendant(
      of: find.byType(MoodCard).first,
      matching: find.text(text),
    );

void main() {
  testWidgets('saving without a score shows an error and adds nothing',
      (tester) async {
    await pumpApp(tester);

    expect(tester.widget<FilledButton>(saveButton).onPressed, isNotNull);

    await tapSave(tester);

    expect(find.text(scoreError), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  testWidgets('choosing a score hides the score error', (tester) async {
    await pumpApp(tester);
    await tapSave(tester);

    await tapScore(tester, 7);

    expect(find.text(scoreError), findsNothing);
  });

  testWidgets('a note of exactly the limit saves and clears the form',
      (tester) async {
    await pumpApp(tester);
    await tapScore(tester, 5);
    await tester.enterText(find.byType(TextField), 'a' * 2000);

    await tapSave(tester);

    expect(find.text(noteError), findsNothing);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(historyCardWithText('a' * 2000), findsOneWidget);
    expect(isScoreSelected(tester, 5), isFalse);
    expect(noteText(tester), isEmpty);
  });

  testWidgets('a note over the limit shows an error and keeps the input',
      (tester) async {
    await pumpApp(tester);
    await tapScore(tester, 5);
    await tester.enterText(find.byType(TextField), 'a' * 2001);

    await tapSave(tester);

    expect(find.text(noteError), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
    expect(isScoreSelected(tester, 5), isTrue);
    expect(noteText(tester).length, 2001);
  });

  testWidgets('shortening a long note lets the entry save', (tester) async {
    await pumpApp(tester);
    await tapScore(tester, 5);
    await tester.enterText(find.byType(TextField), 'a' * 2001);
    await tapSave(tester);

    await tester.enterText(find.byType(TextField), 'a' * 2000);
    await tapSave(tester);

    expect(find.text(noteError), findsNothing);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(historyCardWithText('a' * 2000), findsOneWidget);
  });

  testWidgets('no score and a long note show both errors', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byType(TextField), 'a' * 2001);

    await tapSave(tester);

    expect(find.text(scoreError), findsOneWidget);
    expect(find.text(noteError), findsOneWidget);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length));
  });

  testWidgets('an empty note saves as "No note"', (tester) async {
    await pumpApp(tester);
    await tapScore(tester, 8);

    await tapSave(tester);

    expect(find.text(scoreError), findsNothing);
    expect(find.text(noteError), findsNothing);
    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(historyCardWithText('No note'), findsOneWidget);
  });

  testWidgets('saving an entry puts it at the top of the history',
      (tester) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, '3'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Rainy walk home');
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.byType(MoodCard), findsNWidgets(sampleEntries.length + 1));
    expect(
      find.descendant(
        of: find.byType(MoodCard).first,
        matching: find.text('Rainy walk home'),
      ),
      findsOneWidget,
    );
  });
}

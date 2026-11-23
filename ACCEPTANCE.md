# Form validation: acceptance criteria

1. Given the app just opened with no score selected, when I look at the form, then the "Save entry" button is not greyed out and I can tap it.
2. Given the app just opened with no score selected and an empty note, when I tap "Save entry", then the text "Choose a mood score from 1 to 10." appears below the score numbers, History shows the same entries as before, and the "Entries" number in the summary does not change.
3. Given the text "Choose a mood score from 1 to 10." is visible, when I tap score 7, then that text disappears.
4. Given score 5 is selected and the note contains exactly 2000 letters "a", when I tap "Save entry", then no error text appears, a new entry with score 5 appears at the top of History, the "Entries" number increases by 1, no score is selected, and the note is empty.
5. Given score 5 is selected and I paste a note of exactly 2001 letters "a", when I tap "Save entry", then the text "Notes can be at most 2000 characters." appears below the note, History shows the same entries as before, the "Entries" number does not change, score 5 stays selected, and the note still contains all 2001 letters.
6. Given the text "Notes can be at most 2000 characters." is visible, when I delete one letter from the note and tap "Save entry", then that text disappears and a new entry with score 5 appears at the top of History.
7. Given no score is selected and the note contains exactly 2001 letters "a", when I tap "Save entry", then both "Choose a mood score from 1 to 10." and "Notes can be at most 2000 characters." appear, and History shows the same entries as before.
8. Given score 8 is selected and the note is empty, when I tap "Save entry", then a new entry with score 8 and the text "No note" appears at the top of History, and no error text appears.

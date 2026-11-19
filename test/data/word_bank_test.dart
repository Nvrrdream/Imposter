import 'dart:math';

import 'package:imposter/models/word_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imposter/data/word_bank.dart';

void main() {
  group('WordBank', () {
    test('contains valid word entries', () {
      expect(WordBank.entries, isNotEmpty);

      for (final entry in WordBank.entries) {
        expect(entry.word.trim(), isNotEmpty);
        expect(entry.category.trim(), isNotEmpty);
        expect(entry.lowerCategory.trim(), isNotEmpty);
        expect(entry.lowerCategory.trim(), isNotEmpty);
        expect(entry.hint.trim(), isNotEmpty);
      }
    });
    
    test('contains no duplicate words', () {
      final words = WordBank.entries
          .map((entry) => entry.word.toLowerCase())
          .toSet();

      expect(words.length, WordBank.entries.length);
    });

    test('random selection returns an existing entry', () {
      final selected = WordBank.pickRandom(
        difficulty: WordDifficulty.medium,
        random: Random(1)
      );

      expect(WordBank.entries, contains(selected));
    });
  });
}
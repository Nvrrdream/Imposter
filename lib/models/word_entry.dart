enum WordDifficulty {
  easy,
  medium,
  hard,
}

class WordEntry {
  const WordEntry({
    required this.word,
    required this.category,
    required this.lowerCategory,
    required this.hint,
    required this.difficulty,
  });

  final String word;
  final String category;
  final String lowerCategory;
  final String hint;
  final WordDifficulty difficulty;
}
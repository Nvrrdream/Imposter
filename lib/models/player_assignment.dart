class PlayerAssignment {
  const PlayerAssignment({
    required this.playerName,
    required this.isImposter,
    this.secretWord,
    this.category,
    this.hint,
  });

  final String playerName;
  final bool isImposter;
  final String? secretWord;
  final String? category;
  final String? hint;
}
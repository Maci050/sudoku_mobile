class SudokuTip {
  final String title;
  final String text;
  final List<String> assetImages;

  const SudokuTip({
    required this.title,
    required this.text,
    this.assetImages = const [],
  });
}
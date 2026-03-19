import 'package:flutter/material.dart';
import '../../../settings/domain/app_settings.dart';

class SudokuBoardPalette {
  final Color boardBackground;
  final Color cellBackground;
  final Color highlightedCell;
  final Color selectedCell;
  final Color errorCell;
  final Color hintFocusCell;
  final Color hintRelatedCell;
  final Color fixedNumber;
  final Color userNumber;
  final Color noteColor;
  final Color thickLine;
  final Color thinLine;

  const SudokuBoardPalette({
    required this.boardBackground,
    required this.cellBackground,
    required this.highlightedCell,
    required this.selectedCell,
    required this.errorCell,
    required this.hintFocusCell,
    required this.hintRelatedCell,
    required this.fixedNumber,
    required this.userNumber,
    required this.noteColor,
    required this.thickLine,
    required this.thinLine,
  });
}

SudokuBoardPalette paletteForBoardTheme(SudokuBoardTheme theme) {
  switch (theme) {
    case SudokuBoardTheme.classic:
      return const SudokuBoardPalette(
        boardBackground: Colors.white,
        cellBackground: Colors.white,
        highlightedCell: Color(0xFFEAF3FB),
        selectedCell: Color(0xFFD7E8FA),
        errorCell: Color(0xFFF8D7DA),
        hintFocusCell: Color(0xFFFFE08A),
        hintRelatedCell: Color(0xFFFFF1BF),
        fixedNumber: Colors.black,
        userNumber: Color(0xFF2F5D9F),
        noteColor: Colors.grey,
        thickLine: Colors.black,
        thinLine: Colors.grey,
      );

    case SudokuBoardTheme.paper:
      return const SudokuBoardPalette(
        boardBackground: Color(0xFFFFFBF2),
        cellBackground: Color(0xFFFFFBF2),
        highlightedCell: Color(0xFFF2EAD3),
        selectedCell: Color(0xFFEAD8A6),
        errorCell: Color(0xFFF6D1D1),
        hintFocusCell: Color(0xFFF7D774),
        hintRelatedCell: Color(0xFFFBE9A9),
        fixedNumber: Color(0xFF2B2B2B),
        userNumber: Color(0xFF4A6FA5),
        noteColor: Color(0xFF8A8A8A),
        thickLine: Color(0xFF3B342B),
        thinLine: Color(0xFFAAA08E),
      );

    case SudokuBoardTheme.darkBlue:
      return const SudokuBoardPalette(
        boardBackground: Color(0xFFF4F7FB),
        cellBackground: Color(0xFFF4F7FB),
        highlightedCell: Color(0xFFDCE8F7),
        selectedCell: Color(0xFFBDD3F2),
        errorCell: Color(0xFFF5D2D7),
        hintFocusCell: Color(0xFFFFD76A),
        hintRelatedCell: Color(0xFFFFEDB0),
        fixedNumber: Color(0xFF10233F),
        userNumber: Color(0xFF2C63A8),
        noteColor: Color(0xFF6D7D93),
        thickLine: Color(0xFF12263A),
        thinLine: Color(0xFF9AA9BC),
      );

    case SudokuBoardTheme.forest:
      return const SudokuBoardPalette(
        boardBackground: Color(0xFFE8F5E9),
        cellBackground: Color(0xFFE8F5E9),
        highlightedCell: Color(0xFFC8E6C9),
        selectedCell: Color(0xFFA5D6A7),
        errorCell: Color(0xFFF5D2D7),
        hintFocusCell: Color(0xFFFFDD75),
        hintRelatedCell: Color(0xFFFFF0B8),
        fixedNumber: Color(0xFF1B5E20),
        userNumber: Color(0xFF2E7D32),
        noteColor: Color(0xFF6F8373),
        thickLine: Color(0xFF1B5E20),
        thinLine: Color(0xFF81C784),
      );

    case SudokuBoardTheme.sunset:
      return const SudokuBoardPalette(
        boardBackground: Color(0xFFFFF3E0),
        cellBackground: Color(0xFFFFF3E0),
        highlightedCell: Color(0xFFFFE0B2),
        selectedCell: Color(0xFFFFCC80),
        errorCell: Color(0xFFF5D2D7),
        hintFocusCell: Color(0xFFFFCB66),
        hintRelatedCell: Color(0xFFFFE8A9),
        fixedNumber: Color(0xFFBF360C),
        userNumber: Color(0xFFE65100),
        noteColor: Color(0xFF8C7A72),
        thickLine: Color(0xFFBF360C),
        thinLine: Color(0xFFFFAB91),
      );
  }
}
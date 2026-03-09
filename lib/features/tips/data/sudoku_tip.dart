import '../domain/sudoku_tip.dart';

const sudokuTips = [
  SudokuTip(
    title: 'Empieza por lo fácil',
    text:
        'Busca filas, columnas o bloques que ya tengan muchos números colocados.',
  ),
  SudokuTip(
    title: 'Usa el modo notas',
    text:
        'Marca posibles números en una celda antes de decidir cuál colocar.',
  ),
  SudokuTip(
    title: 'Candidato único',
    text:
        'Si una celda solo puede contener un número posible, ese número es la solución.',
  ),
  SudokuTip(
    title: 'Pareja desnuda',
    text:
        'Si dos casillas del mismo bloque solo pueden contener 2 y 3, esos números quedan reservados para ellas. Eso permite eliminar 2 y 3 del resto de casillas del bloque.',
    assetImages: [
      'assets/tips/naked_pair_1.png',
      'assets/tips/naked_pair_2.png',
    ],
  ),
];
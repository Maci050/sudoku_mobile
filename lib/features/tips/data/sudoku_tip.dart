import '../domain/sudoku_tip.dart';

const sudokuTips = [
  SudokuTip(
    title: 'Candidato oculto',
    text:
        'A veces un número solo puede ir en una casilla de la fila, columna o bloque, aunque esa casilla tenga más candidatos. En ese caso, ese número debe colocarse ahí.',
    assetImages: [
      'assets/tips/hidden_simple_1.png',
      'assets/tips/hidden_simple_2.png',
    ],
  ),
  SudokuTip(
    title: 'Pareja desnuda',
    text:
        'Si dos casillas de la misma unidad solo pueden contener los números 1 y 2, esos números quedan reservados para ellas y pueden eliminarse del resto.',
    assetImages: [
      'assets/tips/naked_pair_1.png',
      'assets/tips/naked_pair_2.png',
    ],
  ),
  SudokuTip(
    title: 'Candidato único',
    text:
        'Si una casilla solo tiene un número posible, entonces ese número es la solución correcta para esa casilla.',
    assetImages: [
      'assets/tips/naked_single_1.png',
      'assets/tips/naked_single_2.png',
    ],
  ),
  SudokuTip(
    title: 'Triple desnudo',
    text:
        'Si tres casillas de una misma unidad solo contienen tres números posibles entre ellas, esos números no pueden aparecer en otras casillas de esa unidad.',
    assetImages: [
      'assets/tips/naked_triplets_1.png',
      'assets/tips/naked_triplets_2.png',
    ],
  ),
  SudokuTip(
    title: 'Pareja oculta',
    text:
        'Si dos números solo pueden aparecer en dos casillas concretas de una unidad, esas casillas deben contener esos dos números, y los demás candidatos pueden eliminarse.',
    assetImages: [
      'assets/tips/hidden_pairs_1.png',
      'assets/tips/hidden_pairs_2.png',
    ],
  ),
  SudokuTip(
    title: 'Reducción línea-bloque',
    text:
        'Si un número dentro de un bloque solo puede ir en una fila o columna concreta, ese número puede eliminarse del resto de esa fila o columna fuera del bloque.',
    assetImages: [
      'assets/tips/line-box_reduction_1.png',
      'assets/tips/line-box_reduction_2.png',
    ],
  ),
  SudokuTip(
    title: 'Pareja apuntadora',
    text:
        'Si un número en un bloque solo aparece en dos casillas de la misma fila o columna, ese número puede eliminarse del resto de esa fila o columna fuera del bloque.',
    assetImages: [
      'assets/tips/pointing_pair_1.png',
      'assets/tips/pointing_pair_2.png',
    ],
  ),
  SudokuTip(
    title: 'X-Wing',
    text:
        'Cuando un número aparece exactamente en dos posiciones en dos filas y forma un rectángulo, se puede eliminar ese candidato en otras casillas de las columnas implicadas.',
    assetImages: [
      'assets/tips/x_wing_1.png',
      'assets/tips/x_wing_2.png',
    ],
  ),
  SudokuTip(
    title: 'Swordfish',
    text:
        'Es una extensión del patrón X-Wing. Si tres filas y tres columnas forman un patrón cerrado para un mismo número, ese candidato puede eliminarse de otras casillas.',
    assetImages: [
      'assets/tips/swordfish_1.png',
      'assets/tips/swordfish_2.png',
      'assets/tips/swordfish_3.png',
    ],
  ),
];
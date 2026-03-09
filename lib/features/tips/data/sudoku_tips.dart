import '../domain/sudoku_tip.dart';

const sudokuTips = [
  SudokuTip(
    title: "Empieza por lo fácil",
    text:
        "Busca filas, columnas o bloques que ya tengan muchos números colocados.",
  ),
  SudokuTip(
    title: "Usa el modo notas",
    text:
        "Marca posibles números en una celda antes de decidir cuál colocar.",
  ),
  SudokuTip(
    title: "Candidato único",
    text:
        "Si una celda solo puede contener un número posible, entonces ese número es la solución.",
  ),
  SudokuTip(
    title: "Eliminación lógica",
    text:
        "Si en tres celdas solo pueden ir los números 1 y 2, entonces cualquier otra celda del bloque no puede contener esos números.",
    assetImage: "assets/tips/naked_pair.png",
  ),
  SudokuTip(
    title: "Trío desnudo",
    text:
        "Si tres celdas contienen solo los números 1,2,3 entonces esos números no pueden aparecer en otras celdas del mismo bloque.",
    assetImage: "assets/tips/naked_triple.png",
  ),
];
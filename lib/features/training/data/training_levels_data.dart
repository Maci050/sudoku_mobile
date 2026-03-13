import '../../game/domain/cell_position.dart';
import '../domain/training_level.dart';
 
const trainingLevels = [

  // NAKED SINGLE
  TrainingLevel(
    id: 'naked_single_1',
    title: 'Ejercicio 1',
    skill: TrainingSkill.nakedSingle,
    order: 1,
    type: TrainingExerciseType.placeNumber,
    objective:
        'El tablero tiene una sola casilla vacía. Determina qué número debe ir ahí.',
    explanation:
        'Revisa la fila, la columna y el bloque de la casilla resaltada. '
        'Los ocho dígitos restantes ya aparecen en esas tres unidades: '
        'solo queda una opción posible.',
    puzzle: [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 6, 1, 4, 2, 3],
      [4, 2, 6, 8, 5, 3, 7, 9, 1],
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 6, 3, 5],
      [3, 4, 5, 2, 8, 6, 1, 7, 0], // (8,8) = 9
    ],
    targetRow: 8,
    targetCol: 8,
    targetValue: 9,
    highlightedCells: [
      CellPosition(row: 8, col: 8),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_single_2',
    title: 'Ejercicio 2',
    skill: TrainingSkill.nakedSingle,
    order: 2,
    type: TrainingExerciseType.placeNumber,
    objective:
        'Hay cinco casillas vacías. Localiza la que solo admite un candidato.',
    explanation:
        'No todas las casillas vacías son naked singles. '
        'Examina cada una: fila, columna y bloque. '
        'La casilla resaltada queda reducida a un único número posible.',
    puzzle: [
      [5, 3, 4, 6, 7, 8, 9, 1, 2],
      [6, 7, 2, 1, 9, 5, 3, 4, 8],
      [1, 9, 8, 3, 4, 2, 5, 6, 7],
      [8, 5, 9, 7, 0, 1, 4, 2, 3], // (3,4)=6
      [4, 2, 6, 0, 5, 3, 7, 9, 1], // (4,3)=8
      [7, 1, 3, 9, 2, 4, 8, 5, 6],
      [9, 6, 1, 5, 3, 7, 2, 8, 4],
      [2, 8, 7, 4, 1, 9, 0, 3, 5], // (7,6)=6
      [3, 4, 5, 2, 8, 6, 1, 0, 0], // (8,7)=7 ← target; (8,8)=9
    ],
    targetRow: 8,
    targetCol: 7,
    targetValue: 7,
    highlightedCells: [
      CellPosition(row: 3, col: 4),
      CellPosition(row: 4, col: 3),
      CellPosition(row: 7, col: 6),
      CellPosition(row: 8, col: 7),
      CellPosition(row: 8, col: 8),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_single_3',
    title: 'Ejercicio 3',
    skill: TrainingSkill.nakedSingle,
    order: 3,
    type: TrainingExerciseType.placeNumber,
    objective:
        'El tablero tiene muchas casillas vacías. Encuentra la que solo permite un número.',
    explanation:
        'Con más huecos el ruido visual aumenta, pero la lógica es la misma: '
        'descarta cada dígito que ya aparezca en la fila, columna o bloque. '
        'Una casilla se queda sin más opción que un único candidato.',
    puzzle: [
      [0, 0, 0, 2, 6, 0, 7, 0, 1],
      [6, 8, 0, 0, 7, 0, 0, 9, 0],
      [1, 9, 0, 0, 0, 4, 5, 0, 0],
      [8, 2, 0, 1, 0, 0, 0, 4, 0],
      [0, 0, 4, 6, 0, 2, 9, 0, 0],
      [0, 5, 0, 0, 0, 3, 0, 2, 8],
      [0, 0, 9, 3, 0, 0, 0, 7, 4],
      [0, 4, 0, 0, 5, 0, 0, 3, 6],
      [7, 0, 3, 0, 1, 8, 0, 0, 0],
    ],
    // (0,1)=3 is the clearest NS target in this puzzle
    targetRow: 0,
    targetCol: 1,
    targetValue: 3,
    highlightedCells: [
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 2),
      CellPosition(row: 0, col: 5),
      CellPosition(row: 0, col: 7),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_single_4',
    title: 'Ejercicio 4',
    skill: TrainingSkill.nakedSingle,
    order: 4,
    type: TrainingExerciseType.placeNumber,
    objective:
        'En este tablero más escaso, solo tres casillas son naked singles. '
        'Resuelve la casilla resaltada.',
    explanation:
        'Cuando hay pocos dígitos dados, la mayoría de casillas vacías tiene '
        'varios candidatos. La casilla objetivo es una excepción: '
        'sus restricciones la dejan con un único número válido. '
        'Céntrate en ella e ignora el resto.',
    puzzle: [
      [0, 0, 3, 0, 2, 0, 6, 0, 0],
      [9, 0, 0, 3, 0, 5, 0, 0, 1],
      [0, 0, 1, 8, 0, 6, 4, 0, 0],
      [0, 0, 8, 1, 0, 2, 9, 0, 0],
      [7, 0, 0, 0, 0, 0, 0, 0, 8],
      [0, 0, 6, 7, 0, 8, 2, 0, 0],
      [0, 0, 2, 6, 0, 9, 5, 0, 0],
      [8, 0, 0, 2, 0, 3, 0, 0, 9],
      [0, 0, 5, 0, 1, 0, 3, 0, 0],
    ],
    // (4,5)=4 is one of 3 NS in this board; also (4,6)=1 and (8,3)=4
    targetRow: 4,
    targetCol: 5,
    targetValue: 4,
    highlightedCells: [
      CellPosition(row: 4, col: 5),
      CellPosition(row: 4, col: 6),
      CellPosition(row: 8, col: 3),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_single_5',
    title: 'Ejercicio 5',
    skill: TrainingSkill.nakedSingle,
    order: 5,
    type: TrainingExerciseType.placeNumber,
    objective:
        'Tablero realista con muchos huecos. Identifica el naked single entre '
        'las casillas resaltadas y coloca el número correcto.',
    explanation:
        'A medida que el tablero se llena de huecos, aparecen hidden singles y '
        'otras técnicas. Aquí la casilla objetivo todavía puede resolverse '
        'solo por descarte de fila, columna y bloque: es un naked single '
        'aunque el entorno sea más complejo.',
    puzzle: [
      [1, 0, 0, 4, 8, 9, 0, 0, 6],
      [7, 3, 0, 0, 0, 0, 0, 4, 0],
      [0, 0, 0, 0, 0, 1, 2, 9, 5],
      [0, 0, 7, 1, 2, 0, 6, 0, 0],
      [5, 4, 0, 7, 0, 3, 0, 1, 0],
      [0, 0, 1, 0, 5, 6, 7, 0, 0],
      [9, 1, 4, 6, 0, 0, 0, 0, 0],
      [0, 2, 0, 0, 0, 0, 0, 3, 8],
      [0, 0, 0, 5, 1, 2, 0, 0, 4],
    ],
    // (0,1)=5 — fila: tiene 1,4,8,9,6; col: tiene 3,7,4,5,4,1,9,2; box: tiene 1,4,8,9,7,3
    targetRow: 0,
    targetCol: 1,
    targetValue: 5,
    highlightedCells: [
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 2),
      CellPosition(row: 0, col: 6),
      CellPosition(row: 0, col: 7),
      CellPosition(row: 1, col: 2),
    ],
  ),
 
  // HIDDEN SINGLE
  TrainingLevel(
    id: 'hidden_single_1',
    title: 'Ejercicio 1',
    skill: TrainingSkill.hiddenSingle,
    order: 1,
    type: TrainingExerciseType.placeNumber,
    objective:
        'La casilla resaltada tiene varios candidatos posibles, '
        'pero dentro de su bloque solo ella puede contener el 7. '
        'Coloca ese dígito.',
    explanation:
        'Un hidden single no se descubre mirando solo una casilla: '
        'debes revisar toda la unidad (fila, columna o bloque). '
        'Si un número solo cabe en una casilla dentro de esa unidad, '
        'ahí debe ir, aunque la casilla parezca tener más opciones.',
    puzzle: [
      [0, 2, 0, 6, 0, 8, 0, 0, 0],
      [5, 8, 0, 0, 0, 9, 7, 0, 0],
      [0, 0, 0, 0, 4, 0, 0, 0, 0],
      [3, 7, 0, 0, 0, 0, 5, 0, 0],
      [6, 0, 0, 0, 0, 0, 0, 0, 4],
      [0, 0, 8, 0, 0, 0, 0, 1, 3],
      [0, 0, 0, 0, 2, 0, 0, 0, 0],
      [0, 0, 9, 8, 0, 0, 0, 3, 6],
      [0, 0, 0, 3, 0, 6, 0, 9, 0],
    ],
    targetRow: 4,
    targetCol: 7,
    targetValue: 7,
    highlightedCells: [
      CellPosition(row: 3, col: 7),
      CellPosition(row: 3, col: 8),
      CellPosition(row: 4, col: 7), // target
      CellPosition(row: 4, col: 8),
      CellPosition(row: 5, col: 7),
      CellPosition(row: 5, col: 8),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_single_2',
    title: 'Ejercicio 2',
    skill: TrainingSkill.hiddenSingle,
    order: 2,
    type: TrainingExerciseType.placeNumber,
    objective:
        'Encuentra el hidden single en la fila resaltada: '
        'uno de los números solo puede ir en la casilla objetivo.',
    explanation:
        'Revisa toda la fila 0 (la primera). '
        'La casilla objetivo tiene varios candidatos, '
        'pero el dígito 1 no puede aparecer en ninguna otra '
        'casilla vacía de esa fila. Ese es tu hidden single.',
    puzzle: [
      [0, 0, 3, 0, 2, 0, 6, 0, 0],
      [9, 0, 0, 3, 0, 5, 0, 0, 1],
      [0, 0, 1, 8, 0, 6, 4, 0, 0],
      [0, 0, 8, 1, 0, 2, 9, 0, 0],
      [7, 0, 0, 0, 0, 0, 0, 0, 8],
      [0, 0, 6, 7, 0, 8, 2, 0, 0],
      [0, 0, 2, 6, 0, 9, 5, 0, 0],
      [8, 0, 0, 2, 0, 3, 0, 0, 9],
      [0, 0, 5, 0, 1, 0, 3, 0, 0],
    ],
    targetRow: 0,
    targetCol: 5,
    targetValue: 1,
    highlightedCells: [
      CellPosition(row: 0, col: 0),
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 3),
      CellPosition(row: 0, col: 5), // target
      CellPosition(row: 0, col: 7),
      CellPosition(row: 0, col: 8),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_single_3',
    title: 'Ejercicio 3',
    skill: TrainingSkill.hiddenSingle,
    order: 3,
    type: TrainingExerciseType.placeNumber,
    objective:
        'Busca el hidden single en la columna resaltada: '
        'una columna donde el 8 solo puede ir en una casilla.',
    explanation:
        'La columna 6 tiene varias casillas vacías con distintos candidatos. '
        'Comprueba cuáles de ellas admiten el dígito 8. '
        'Si solo una puede tenerlo, esa casilla es un hidden single.',
    puzzle: [
      [0, 0, 3, 0, 2, 0, 6, 0, 0],
      [9, 0, 0, 3, 0, 5, 0, 0, 1],
      [0, 0, 1, 8, 0, 6, 4, 0, 0],
      [0, 0, 8, 1, 0, 2, 9, 0, 0],
      [7, 0, 0, 0, 0, 0, 0, 0, 8],
      [0, 0, 6, 7, 0, 8, 2, 0, 0],
      [0, 0, 2, 6, 0, 9, 5, 0, 0],
      [8, 0, 0, 2, 0, 3, 0, 0, 9],
      [0, 0, 5, 0, 1, 0, 3, 0, 0],
    ],
    targetRow: 1,
    targetCol: 6,
    targetValue: 8,
    highlightedCells: [
      CellPosition(row: 0, col: 6),
      CellPosition(row: 1, col: 6), // target
      CellPosition(row: 4, col: 6),
      CellPosition(row: 6, col: 6),
      CellPosition(row: 7, col: 6),
      CellPosition(row: 8, col: 6),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_single_4',
    title: 'Ejercicio 4',
    skill: TrainingSkill.hiddenSingle,
    order: 4,
    type: TrainingExerciseType.placeNumber,
    objective:
        'Tablero más escaso. El hidden single de la casilla objetivo '
        'se esconde entre muchos huecos: encuéntralo en la fila.',
    explanation:
        'Con menos dígitos dados, las casillas tienen más candidatos. '
        'El truco del hidden single sigue siendo el mismo: '
        'localiza un dígito que solo quepa en una casilla de la fila, '
        'columna o bloque, y colócalo.',
    puzzle: [
      [1, 0, 0, 4, 8, 9, 0, 0, 6],
      [7, 3, 0, 0, 0, 0, 0, 4, 0],
      [0, 0, 0, 0, 0, 1, 2, 9, 5],
      [0, 0, 7, 1, 2, 0, 6, 0, 0],
      [5, 4, 0, 7, 0, 3, 0, 1, 0],
      [0, 0, 1, 0, 5, 6, 7, 0, 0],
      [9, 1, 4, 6, 0, 0, 0, 0, 0],
      [0, 2, 0, 0, 0, 0, 0, 3, 8],
      [0, 0, 0, 5, 1, 2, 0, 0, 4],
    ],
    targetRow: 0,
    targetCol: 2,
    targetValue: 2,
    highlightedCells: [
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 2), // target
      CellPosition(row: 0, col: 6),
      CellPosition(row: 0, col: 7),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_single_5',
    title: 'Ejercicio 5',
    skill: TrainingSkill.hiddenSingle,
    order: 5,
    type: TrainingExerciseType.placeNumber,
    objective:
        'Puzzle difícil con muchos huecos. Localiza el hidden single '
        'en el bloque o la columna resaltada.',
    explanation:
        'En puzzles escasos el razonamiento por unidad es esencial. '
        'Comprueba qué dígitos pueden ir en cada casilla vacía del bloque '
        'o columna resaltada. El que solo aparece en una casilla es el '
        'hidden single que debes colocar.',
    puzzle: [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 3, 0, 8, 5],
      [0, 0, 1, 0, 2, 0, 0, 0, 0],
      [0, 0, 0, 5, 0, 7, 0, 0, 0],
      [0, 0, 4, 0, 0, 0, 1, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 7, 3],
      [0, 0, 2, 0, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 4, 0, 0, 0, 9],
    ],
    targetRow: 0,
    targetCol: 4,
    targetValue: 5,
    highlightedCells: [
      CellPosition(row: 0, col: 4), // target
      CellPosition(row: 3, col: 4),
      CellPosition(row: 5, col: 4),
      CellPosition(row: 6, col: 4),
      CellPosition(row: 7, col: 4),
    ],
  ),
 
  // NAKED PAIR
  TrainingLevel(
    id: 'naked_pair_1',
    title: 'Ejercicio 1',
    skill: TrainingSkill.nakedPair,
    order: 1,
    type: TrainingExerciseType.selectCells,
    objective:
        'Selecciona las dos casillas que forman la naked pair en este tablero.',
    explanation:
        'Calcula los candidatos de cada casilla resaltada. '
        'Si dos casillas de la misma unidad comparten exactamente '
        'los mismos dos candidatos, forman una naked pair. '
        'Esos dos números quedan "reservados" para ellas '
        'y pueden eliminarse del resto de la unidad.',
    puzzle: [
      [4, 0, 0, 0, 0, 0, 9, 3, 8],
      [0, 3, 2, 0, 9, 4, 1, 0, 0],
      [0, 9, 5, 3, 0, 0, 2, 4, 0],
      [3, 7, 0, 6, 0, 9, 0, 0, 4],
      [5, 2, 9, 0, 0, 1, 6, 7, 0],
      [6, 0, 4, 7, 0, 0, 0, 9, 0],
      [7, 4, 0, 0, 0, 0, 8, 0, 0],
      [0, 0, 0, 0, 0, 0, 4, 0, 0],
      [0, 0, 0, 0, 8, 0, 0, 0, 7],
    ],
    highlightedCells: [
      CellPosition(row: 1, col: 3),
      CellPosition(row: 1, col: 7),
      CellPosition(row: 1, col: 8),
      CellPosition(row: 5, col: 6),
    ],
    expectedSelectedCells: [
      CellPosition(row: 1, col: 7),
      CellPosition(row: 1, col: 8),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_pair_2',
    title: 'Ejercicio 2',
    skill: TrainingSkill.nakedPair,
    order: 2,
    type: TrainingExerciseType.selectCells,
    objective:
        'Dos casillas de la misma columna forman una naked pair. '
        'Encuéntralas entre las resaltadas.',
    explanation:
        'Fíjate en la columna 6. Calcula los candidatos de cada '
        'casilla vacía de esa columna. Dos de ellas tienen exactamente '
        'los mismos dos candidatos: eso es la naked pair. '
        'El par impide que esos dígitos vayan en cualquier otra casilla '
        'de la columna.',
    puzzle: [
      [4, 0, 0, 0, 0, 0, 9, 3, 8],
      [0, 3, 2, 0, 9, 4, 1, 0, 0],
      [0, 9, 5, 3, 0, 0, 2, 4, 0],
      [3, 7, 0, 6, 0, 9, 0, 0, 4],
      [5, 2, 9, 0, 0, 1, 6, 7, 0],
      [6, 0, 4, 7, 0, 0, 0, 9, 0],
      [7, 4, 0, 0, 0, 0, 8, 0, 0],
      [0, 0, 0, 0, 0, 0, 4, 0, 0],
      [0, 0, 0, 0, 8, 0, 0, 0, 7],
    ],
    highlightedCells: [
      CellPosition(row: 1, col: 6),
      CellPosition(row: 3, col: 6),
      CellPosition(row: 5, col: 6),
      CellPosition(row: 6, col: 6),
      CellPosition(row: 8, col: 6),
    ],
    expectedSelectedCells: [
      CellPosition(row: 5, col: 6),
      CellPosition(row: 8, col: 6),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_pair_3',
    title: 'Ejercicio 3',
    skill: TrainingSkill.nakedPair,
    order: 3,
    type: TrainingExerciseType.selectCells,
    objective:
        'Una naked pair se esconde dentro del bloque resaltado. '
        'Selecciona las dos casillas correctas.',
    explanation:
        'Dentro de un bloque 3×3 también pueden formarse naked pairs. '
        'Calcula los candidatos de cada casilla vacía del bloque. '
        'Dos de ellas comparten exactamente la misma pareja de candidatos: '
        'eso impide que esos números se coloquen en otra casilla del mismo bloque.',
    puzzle: [
      [4, 0, 0, 0, 0, 0, 9, 3, 8],
      [0, 3, 2, 0, 9, 4, 1, 0, 0],
      [0, 9, 5, 3, 0, 0, 2, 4, 0],
      [3, 7, 0, 6, 0, 9, 0, 0, 4],
      [5, 2, 9, 0, 0, 1, 6, 7, 0],
      [6, 0, 4, 7, 0, 0, 0, 9, 0],
      [7, 4, 0, 0, 0, 0, 8, 0, 0],
      [0, 0, 0, 0, 0, 0, 4, 0, 0],
      [0, 0, 0, 0, 8, 0, 0, 0, 7],
    ],
    highlightedCells: [
      CellPosition(row: 1, col: 0),
      CellPosition(row: 1, col: 3),
      CellPosition(row: 1, col: 7),
      CellPosition(row: 1, col: 8),
    ],
    expectedSelectedCells: [
      CellPosition(row: 1, col: 7),
      CellPosition(row: 1, col: 8),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_pair_4',
    title: 'Ejercicio 4',
    skill: TrainingSkill.nakedPair,
    order: 4,
    type: TrainingExerciseType.selectCells,
    objective:
        'Tablero más complejo. Detecta la naked pair entre '
        'las casillas resaltadas de la columna.',
    explanation:
        'Las naked pairs no siempre son visibles a primera vista. '
        'Aquí el tablero tiene más huecos y más distracción. '
        'Calcula los candidatos de las casillas resaltadas y busca '
        'el par exacto de dos dígitos compartidos entre dos casillas.',
    puzzle: [
      [4, 0, 0, 0, 0, 0, 9, 3, 8],
      [0, 3, 2, 0, 9, 4, 1, 0, 0],
      [0, 9, 5, 3, 0, 0, 2, 4, 0],
      [3, 7, 0, 6, 0, 9, 0, 0, 4],
      [5, 2, 9, 0, 0, 1, 6, 7, 0],
      [6, 0, 4, 7, 0, 0, 0, 9, 0],
      [7, 4, 0, 0, 0, 0, 8, 0, 0],
      [0, 0, 0, 0, 0, 0, 4, 0, 0],
      [0, 0, 0, 0, 8, 0, 0, 0, 7],
    ],
    highlightedCells: [
      CellPosition(row: 3, col: 6),
      CellPosition(row: 5, col: 6),
      CellPosition(row: 6, col: 6),
      CellPosition(row: 8, col: 6),
    ],
    expectedSelectedCells: [
      CellPosition(row: 5, col: 6),
      CellPosition(row: 8, col: 6),
    ],
  ),
 
  TrainingLevel(
    id: 'naked_pair_5',
    title: 'Ejercicio 5',
    skill: TrainingSkill.nakedPair,
    order: 5,
    type: TrainingExerciseType.selectCells,
    objective:
        'Ejercicio final de naked pair. Localiza la pareja exacta '
        'entre todas las casillas vacías de la unidad.',
    explanation:
        'En este ejercicio hay más casillas vacías como distracción. '
        'Solo dos de ellas comparten exactamente los mismos dos candidatos. '
        'Calcula los candidatos de cada casilla resaltada y '
        'selecciona únicamente las que forman la naked pair.',
    puzzle: [
      [4, 0, 0, 0, 0, 0, 9, 3, 8],
      [0, 3, 2, 0, 9, 4, 1, 0, 0],
      [0, 9, 5, 3, 0, 0, 2, 4, 0],
      [3, 7, 0, 6, 0, 9, 0, 0, 4],
      [5, 2, 9, 0, 0, 1, 6, 7, 0],
      [6, 0, 4, 7, 0, 0, 0, 9, 0],
      [7, 4, 0, 0, 0, 0, 8, 0, 0],
      [0, 0, 0, 0, 0, 0, 4, 0, 0],
      [0, 0, 0, 0, 8, 0, 0, 0, 7],
    ],
    highlightedCells: [
      CellPosition(row: 1, col: 0),
      CellPosition(row: 1, col: 3),
      CellPosition(row: 1, col: 7),
      CellPosition(row: 1, col: 8),
      CellPosition(row: 5, col: 1),
    ],
    expectedSelectedCells: [
      CellPosition(row: 1, col: 7),
      CellPosition(row: 1, col: 8),
    ],
  ),
 
  // HIDDEN PAIR
  TrainingLevel(
    id: 'hidden_pair_1',
    title: 'Ejercicio 1',
    skill: TrainingSkill.hiddenPair,
    order: 1,
    type: TrainingExerciseType.selectCells,
    objective:
        'Selecciona las dos casillas que forman el hidden pair '
        'dentro de la fila resaltada.',
    explanation:
        'A diferencia de la naked pair, en el hidden pair las casillas '
        'tienen más de dos candidatos. La clave es que dos números concretos '
        'solo pueden aparecer en exactamente dos casillas de la unidad. '
        'Esas dos casillas son el hidden pair.',
    puzzle: [
      [0, 2, 0, 6, 0, 8, 0, 0, 0],
      [5, 8, 0, 0, 0, 9, 7, 0, 0],
      [0, 0, 0, 0, 4, 0, 0, 0, 0],
      [3, 7, 0, 0, 0, 0, 5, 0, 0],
      [6, 0, 0, 0, 0, 0, 0, 0, 4],
      [0, 0, 8, 0, 0, 0, 0, 1, 3],
      [0, 0, 0, 0, 2, 0, 0, 0, 0],
      [0, 0, 9, 8, 0, 0, 0, 3, 6],
      [0, 0, 0, 3, 0, 6, 0, 9, 0],
    ],
    highlightedCells: [
      CellPosition(row: 4, col: 1),
      CellPosition(row: 4, col: 2),
      CellPosition(row: 4, col: 3),
      CellPosition(row: 4, col: 5),
      CellPosition(row: 4, col: 6),
      CellPosition(row: 4, col: 7),
    ],
    expectedSelectedCells: [
      CellPosition(row: 4, col: 5),
      CellPosition(row: 4, col: 7),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_pair_2',
    title: 'Ejercicio 2',
    skill: TrainingSkill.hiddenPair,
    order: 2,
    type: TrainingExerciseType.selectCells,
    objective:
        'En el bloque resaltado, dos números solo caben en dos casillas. '
        'Selecciona esas dos casillas.',
    explanation:
        'Revisa qué dígitos faltan en el bloque y, para cada uno, '
        'en qué casillas vacías pueden colocarse. '
        'Si dos dígitos solo caben en las mismas dos casillas, '
        'esas casillas forman un hidden pair y ningún otro número puede ir ahí.',
    puzzle: [
      [0, 0, 3, 0, 2, 0, 6, 0, 0],
      [9, 0, 0, 3, 0, 5, 0, 0, 1],
      [0, 0, 1, 8, 0, 6, 4, 0, 0],
      [0, 0, 8, 1, 0, 2, 9, 0, 0],
      [7, 0, 0, 0, 0, 0, 0, 0, 8],
      [0, 0, 6, 7, 0, 8, 2, 0, 0],
      [0, 0, 2, 6, 0, 9, 5, 0, 0],
      [8, 0, 0, 2, 0, 3, 0, 0, 9],
      [0, 0, 5, 0, 1, 0, 3, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 0),
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 3),
      CellPosition(row: 0, col: 5),
      CellPosition(row: 0, col: 7),
      CellPosition(row: 0, col: 8),
    ],
    expectedSelectedCells: [
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 8),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_pair_3',
    title: 'Ejercicio 3',
    skill: TrainingSkill.hiddenPair,
    order: 3,
    type: TrainingExerciseType.selectCells,
    objective:
        'Encuentra el hidden pair en la columna resaltada.',
    explanation:
        'Analiza la columna indicada casilla por casilla. '
        'Para cada dígito que falta en esa columna, '
        'cuenta en cuántas casillas vacías puede aparecer. '
        'Si son exactamente dos casillas para dos dígitos distintos, '
        'esas casillas forman el hidden pair.',
    puzzle: [
      [0, 0, 3, 0, 2, 0, 6, 0, 0],
      [9, 0, 0, 3, 0, 5, 0, 0, 1],
      [0, 0, 1, 8, 0, 6, 4, 0, 0],
      [0, 0, 8, 1, 0, 2, 9, 0, 0],
      [7, 0, 0, 0, 0, 0, 0, 0, 8],
      [0, 0, 6, 7, 0, 8, 2, 0, 0],
      [0, 0, 2, 6, 0, 9, 5, 0, 0],
      [8, 0, 0, 2, 0, 3, 0, 0, 9],
      [0, 0, 5, 0, 1, 0, 3, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 1),
      CellPosition(row: 1, col: 1),
      CellPosition(row: 2, col: 1),
      CellPosition(row: 3, col: 1),
      CellPosition(row: 4, col: 1),
      CellPosition(row: 5, col: 1),
    ],
    expectedSelectedCells: [
      CellPosition(row: 1, col: 1),
      CellPosition(row: 4, col: 1),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_pair_4',
    title: 'Ejercicio 4',
    skill: TrainingSkill.hiddenPair,
    order: 4,
    type: TrainingExerciseType.selectCells,
    objective:
        'El hidden pair se esconde en un tablero más complejo. '
        'Selecciona las dos casillas correctas del bloque.',
    explanation:
        'En este ejercicio hay más casillas vacías y más candidatos. '
        'El razonamiento no cambia: identifica dos dígitos que '
        'solo puedan aparecer en dos casillas de la misma unidad. '
        'Esas dos casillas son el hidden pair, independientemente '
        'de cuántos otros candidatos tengan.',
    puzzle: [
      [1, 0, 0, 4, 8, 9, 0, 0, 6],
      [7, 3, 0, 0, 0, 0, 0, 4, 0],
      [0, 0, 0, 0, 0, 1, 2, 9, 5],
      [0, 0, 7, 1, 2, 0, 6, 0, 0],
      [5, 4, 0, 7, 0, 3, 0, 1, 0],
      [0, 0, 1, 0, 5, 6, 7, 0, 0],
      [9, 1, 4, 6, 0, 0, 0, 0, 0],
      [0, 2, 0, 0, 0, 0, 0, 3, 8],
      [0, 0, 0, 5, 1, 2, 0, 0, 4],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 2),
      CellPosition(row: 0, col: 6),
      CellPosition(row: 0, col: 7),
      CellPosition(row: 1, col: 2),
      CellPosition(row: 1, col: 4),
    ],
    expectedSelectedCells: [
      CellPosition(row: 0, col: 6),
      CellPosition(row: 0, col: 7),
    ],
  ),
 
  TrainingLevel(
    id: 'hidden_pair_5',
    title: 'Ejercicio 5',
    skill: TrainingSkill.hiddenPair,
    order: 5,
    type: TrainingExerciseType.selectCells,
    objective:
        'Ejercicio final de hidden pair. El tablero es escaso '
        'y el par está bien oculto.',
    explanation:
        'Con un tablero muy vacío y muchos candidatos por casilla, '
        'el hidden pair requiere analizar sistemáticamente cada unidad. '
        'Para cada par de dígitos que faltan en la unidad, comprueba '
        'si solo dos casillas los admiten. Cuando lo encuentres, '
        'esas dos casillas son tu respuesta.',
    puzzle: [
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 3, 0, 8, 5],
      [0, 0, 1, 0, 2, 0, 0, 0, 0],
      [0, 0, 0, 5, 0, 7, 0, 0, 0],
      [0, 0, 4, 0, 0, 0, 1, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 7, 3],
      [0, 0, 2, 0, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 4, 0, 0, 0, 9],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 4),
      CellPosition(row: 3, col: 4),
      CellPosition(row: 5, col: 4),
      CellPosition(row: 6, col: 4),
      CellPosition(row: 7, col: 4),
    ],
    expectedSelectedCells: [
      CellPosition(row: 0, col: 4),
      CellPosition(row: 6, col: 4),
    ],
  ),
 
  // POINTING PAIR
  TrainingLevel(
    id: 'pointing_pair_1',
    title: 'Ejercicio 1',
    skill: TrainingSkill.pointingPair,
    order: 1,
    type: TrainingExerciseType.selectCells,
    objective:
        'Dentro del bloque resaltado, el candidato 3 solo aparece '
        'en dos casillas de la misma columna. Selecciónalas.',
    explanation:
        'Cuando un candidato queda restringido a una fila o columna '
        'dentro de un bloque, se puede eliminar de esa misma fila o '
        'columna fuera del bloque. El primer paso es identificar '
        'las casillas que forman ese pointing pair dentro del bloque.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 6, col: 5),
      CellPosition(row: 7, col: 3),
      CellPosition(row: 7, col: 5),
      CellPosition(row: 8, col: 5),
    ],
    expectedSelectedCells: [
      CellPosition(row: 7, col: 5),
      CellPosition(row: 8, col: 5),
    ],
  ),
 
  TrainingLevel(
    id: 'pointing_pair_2',
    title: 'Ejercicio 2',
    skill: TrainingSkill.pointingPair,
    order: 2,
    type: TrainingExerciseType.selectCells,
    objective:
        'Un candidato dentro del bloque inferior-central '
        'queda confinado a una sola fila. Selecciona esas casillas.',
    explanation:
        'Para detectar un pointing pair, revisa cada candidato '
        'en las casillas vacías del bloque. Si un número solo aparece '
        'en casillas de la misma fila (o columna) dentro del bloque, '
        'esas casillas forman el pointing pair.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 6, col: 0),
      CellPosition(row: 6, col: 3),
      CellPosition(row: 6, col: 4),
      CellPosition(row: 7, col: 4),
      CellPosition(row: 8, col: 3),
    ],
    expectedSelectedCells: [
      CellPosition(row: 6, col: 3),
      CellPosition(row: 6, col: 4),
    ],
  ),
 
  TrainingLevel(
    id: 'pointing_pair_3',
    title: 'Ejercicio 3',
    skill: TrainingSkill.pointingPair,
    order: 3,
    type: TrainingExerciseType.selectCells,
    objective:
        'Selecciona la pointing pair correcta del bloque. '
        'No todas las casillas vacías participan.',
    explanation:
        'En un bloque con varios huecos, es fácil confundir cuáles '
        'forman la pointing pair. Solo deben seleccionarse las casillas '
        'donde el candidato clave queda confinado a una misma '
        'fila o columna dentro del bloque.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 6, col: 0),
      CellPosition(row: 6, col: 3),
      CellPosition(row: 6, col: 4),
      CellPosition(row: 7, col: 3),
      CellPosition(row: 7, col: 5),
      CellPosition(row: 8, col: 5),
    ],
    expectedSelectedCells: [
      CellPosition(row: 7, col: 5),
      CellPosition(row: 8, col: 5),
    ],
  ),
 
  TrainingLevel(
    id: 'pointing_pair_4',
    title: 'Ejercicio 4',
    skill: TrainingSkill.pointingPair,
    order: 4,
    type: TrainingExerciseType.selectCells,
    objective:
        'Tablero más complejo. Identifica la pointing pair '
        'entre varias casillas candidatas resaltadas.',
    explanation:
        'Con más huecos es tentador seleccionar casillas al azar. '
        'La técnica exige verificar candidato a candidato: '
        'para un valor dado, ¿quedan todas sus posiciones en el bloque '
        'alineadas en una misma fila o columna? Si sí, eso es la pointing pair.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 6, col: 3),
      CellPosition(row: 6, col: 4),
      CellPosition(row: 7, col: 3),
      CellPosition(row: 7, col: 5),
      CellPosition(row: 8, col: 3),
      CellPosition(row: 8, col: 5),
    ],
    expectedSelectedCells: [
      CellPosition(row: 6, col: 3),
      CellPosition(row: 6, col: 4),
    ],
  ),
 
  TrainingLevel(
    id: 'pointing_pair_5',
    title: 'Ejercicio 5',
    skill: TrainingSkill.pointingPair,
    order: 5,
    type: TrainingExerciseType.selectCells,
    objective:
        'Ejercicio final de pointing pair. Con más ruido visual, '
        'selecciona solo las dos casillas que restringen el candidato.',
    explanation:
        'Este es el ejercicio más exigente de pointing pair. '
        'Hay más casillas vacías como distracción. Analiza el bloque '
        'resaltado e identifica el candidato que queda alineado '
        'en una sola fila o columna. Solo esas casillas forman la técnica.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 6, col: 0),
      CellPosition(row: 6, col: 3),
      CellPosition(row: 6, col: 4),
      CellPosition(row: 7, col: 3),
      CellPosition(row: 7, col: 5),
      CellPosition(row: 8, col: 3),
      CellPosition(row: 8, col: 5),
    ],
    expectedSelectedCells: [
      CellPosition(row: 7, col: 5),
      CellPosition(row: 8, col: 5),
    ],
  ),
 
  // BOX-LINE REDUCTION
  TrainingLevel(
    id: 'box_line_1',
    title: 'Ejercicio 1',
    skill: TrainingSkill.boxLineReduction,
    order: 1,
    type: TrainingExerciseType.selectCells,
    objective:
        'El candidato 2 en la fila 0 solo aparece dentro del bloque '
        'superior-derecho. Selecciona las casillas de esa fila '
        'que activan la reducción.',
    explanation:
        'La box-line reduction es el inverso del pointing pair: '
        'si todas las posibles posiciones de un candidato en una fila '
        '(o columna) caen dentro de un mismo bloque, ese candidato '
        'puede eliminarse de las demás casillas del bloque '
        'que no están en esa fila.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 0),
      CellPosition(row: 0, col: 1),
      CellPosition(row: 0, col: 6),
      CellPosition(row: 0, col: 7),
      CellPosition(row: 0, col: 8),
    ],
    expectedSelectedCells: [
      CellPosition(row: 0, col: 6),
      CellPosition(row: 0, col: 7),
    ],
  ),
 
  TrainingLevel(
    id: 'box_line_2',
    title: 'Ejercicio 2',
    skill: TrainingSkill.boxLineReduction,
    order: 2,
    type: TrainingExerciseType.selectCells,
    objective:
        'El candidato de la columna resaltada está confinado '
        'a un bloque. Selecciona las casillas que lo demuestran.',
    explanation:
        'En este ejercicio la reducción ocurre en una columna, no en una fila. '
        'Si un candidato en una columna solo aparece en celdas que pertenecen '
        'al mismo bloque, puede eliminarse de las demás casillas de ese bloque '
        'que están en otras columnas.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 5),
      CellPosition(row: 2, col: 5),
      CellPosition(row: 3, col: 5),
      CellPosition(row: 4, col: 5),
      CellPosition(row: 5, col: 5),
    ],
    expectedSelectedCells: [
      CellPosition(row: 3, col: 5),
      CellPosition(row: 4, col: 5),
    ],
  ),
 
  TrainingLevel(
    id: 'box_line_3',
    title: 'Ejercicio 3',
    skill: TrainingSkill.boxLineReduction,
    order: 3,
    type: TrainingExerciseType.selectCells,
    objective:
        'Selecciona las casillas de la línea que provocan '
        'la reducción dentro del bloque.',
    explanation:
        'Identifica el candidato que, en la columna (o fila) resaltada, '
        'solo aparece dentro de un único bloque. '
        'Selecciona esas casillas: son las que "bloquean" ese candidato '
        'para el resto del bloque fuera de la línea.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 3, col: 3),
      CellPosition(row: 4, col: 3),
      CellPosition(row: 5, col: 3),
      CellPosition(row: 6, col: 3),
      CellPosition(row: 8, col: 3),
    ],
    expectedSelectedCells: [
      CellPosition(row: 3, col: 3),
      CellPosition(row: 4, col: 3),
    ],
  ),
 
  TrainingLevel(
    id: 'box_line_4',
    title: 'Ejercicio 4',
    skill: TrainingSkill.boxLineReduction,
    order: 4,
    type: TrainingExerciseType.selectCells,
    objective:
        'Con más ruido visual, localiza las casillas de la línea '
        'que activan la box-line reduction.',
    explanation:
        'Con más huecos en el tablero, el candidato relevante puede '
        'estar en varias columnas o filas. La clave es encontrar '
        'el candidato que, dentro de la línea analizada, '
        'solo aparece en casillas del mismo bloque. '
        'Esas son las casillas que buscas.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 1),
      CellPosition(row: 3, col: 1),
      CellPosition(row: 4, col: 1),
      CellPosition(row: 5, col: 1),
      CellPosition(row: 6, col: 1),
    ],
    expectedSelectedCells: [
      CellPosition(row: 4, col: 1),
      CellPosition(row: 5, col: 1),
    ],
  ),
 
  TrainingLevel(
    id: 'box_line_5',
    title: 'Ejercicio 5',
    skill: TrainingSkill.boxLineReduction,
    order: 5,
    type: TrainingExerciseType.selectCells,
    objective:
        'Ejercicio final de box-line reduction. '
        'Selecciona las casillas exactas de la línea que activan la técnica.',
    explanation:
        'Para dominar box-line reduction debes analizar sistemáticamente '
        'cada candidato en cada línea. Este ejercicio te pone a prueba '
        'con más candidatos posibles como distracción. '
        'Encuentra el que está completamente confinado a un bloque '
        'dentro de la columna y selecciona esas casillas.',
    puzzle: [
      [0, 0, 0, 0, 3, 8, 0, 0, 0],
      [0, 0, 0, 0, 0, 5, 0, 4, 1],
      [4, 2, 0, 6, 0, 0, 0, 0, 0],
      [0, 9, 0, 0, 0, 0, 0, 0, 7],
      [0, 0, 0, 0, 0, 0, 0, 0, 0],
      [5, 0, 0, 0, 0, 0, 0, 8, 0],
      [0, 0, 0, 0, 0, 1, 0, 3, 4],
      [8, 5, 0, 2, 0, 0, 0, 0, 0],
      [0, 0, 0, 5, 4, 0, 0, 0, 0],
    ],
    highlightedCells: [
      CellPosition(row: 0, col: 5),
      CellPosition(row: 3, col: 5),
      CellPosition(row: 4, col: 5),
      CellPosition(row: 5, col: 5),
      CellPosition(row: 6, col: 5),
      CellPosition(row: 8, col: 5),
    ],
    expectedSelectedCells: [
      CellPosition(row: 3, col: 5),
      CellPosition(row: 4, col: 5),
    ],
  ),
];
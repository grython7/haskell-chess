# Implementing a chess game engine using Haskell

## Assumptions for simplicity:
a) There are no promotions of pawns.

b) It is legal for a king to move to locations in which he will be threatened.

### Functions

#### a) setBoard :: Board
The function does not take any inputs and returns a board representing the initial configuration depicted in Figure 1. Assume that the first turn is always on the white player. Example:

<details>
<summary>setBoard</summary>

```haskell
(White, [R (’h’,1),N (’g’,1),B (’f’,1),K (’e’,1),
 Q (’d’,1),B (’c’,1),N (’b’,1),R (’a’,1),
 P (’h’,2),P (’g’,2),P (’f’,2),P (’e’,2),
 P (’d’,2),P (’c’,2),P (’b’,2),P (’a’,2)],
 [R (’h’,8),N (’g’,8),B (’f’,8),K (’e’,8),
 Q (’d’,8),B (’c’,8),N (’b’,8),R (’a’,8),
 P (’h’,7),P (’g’,7),P (’f’,7),P (’e’,7),
 P (’d’,7),P (’c’,7),P (’b’,7),P (’a’,7)])
 ```
</details>

#### b) visualizeBoard:: Board->String
The function takes as input a board and returns a visual representation of the board in a string. Black pieces are suffixed with ’B’ and white pieces are suffixed with ’W’.

<details>
<summary>visualizeBoard (setBoard)</summary>

```haskell
|   | a  | b  | c  | d  | e  | f  | g  | h  |
|---|----|----|----|----|----|----|----|----|
| 8 | RB | NB | BB | QB | KB | BB | NB | RB |
| 7 | PB | PB | PB | PB | PB | PB | PB | PB |
| 6 |    |    |    |    |    |    |    |    |
| 5 |    |    |    |    |    |    |    |    |
| 4 |    |    |    |    |    |    |    |    |
| 3 |    |    |    |    |    |    |    |    |
| 2 | PW | PW | PW | PW | PW | PW | PW | PW |
| 1 | RW | NW | BW | QW | KW | BW | NW | RW |
```
</details>

#### c) isLegal:: Piece-> Board-> Location-> Bool
The function takes as input a piece, a board, and a location. It returns True if the move of the piece on the given board to the input location is legal, and False otherwise.

<details>
<summary>isLegal (P (’a’,7)) (setBoard) (’a’,5)</summary>

```haskell
True
```
</details>

<details>
<summary>isLegal (P (’a’,7)) (setBoard) (’a’,4)</summary>

```haskell
False
```
</details>


#### d) suggestMove:: Piece-> Board-> [Location]
The function takes as input a piece and a board and outputs a list of possible legal next locations for the piece. Example:
<details>
<summary>suggestMove (P (’e’,2)) (setBoard)</summary>

```haskell
[(’e’,3),(’e’,4)]
```
</details>




#### e) move:: Piece-> Location-> Board-> Board
The function takes as input a piece, a location, and a board and returns a new updated board after the move is applied if it is a legal move. Otherwise, if the move is illegal, the function throws an appropriate error.

<details>
<summary>move (P (’a’,7)) (’a’,6) (setBoard)</summary>

```haskell
Program error: This is White player’s turn, Black can’t move.
```
</details>

<details>
<summary>move (R (’h’,1)) (’h’,2) (setBoard))</summary>

```haskell
Program error: Illegal move
```
</details>

## Example for a valid movement
```haskell
> move (N (’b’,3)) (’d’,4) (White, [R (’h’,1),N (’g’,1),B (’f’,1),
K (’e’,1), Q (’d’,1),B (’c’,1),N (’b’,3),R (’a’,1),
P (’h’,2),P (’g’,2),P (’f’,2),P (’e’,2),
P (’d’,2),P (’c’,2),P (’b’,2),P (’a’,2)] ,
[R (’h’,8),N (’g’,8),B (’f’,8),K (’e’,8),
Q (’d’,8),B (’c’,8),N (’b’,8),R (’a’,8),
P (’h’,7),P (’g’,7),P (’f’,7),P (’e’,7),
P (’d’,7),P (’c’,7),P (’b’,7),P (’a’,7)])

(Black,[R (’h’,1),N (’g’,1),B (’f’,1),K (’e’,1),
Q (’d’,1),B (’c’,1),N (’d’,4),R (’a’,1),
P (’h’,2),P (’g’,2),P (’f’,2),P (’e’,2),
P (’d’,2),P (’c’,2),P (’b’,2),P (’a’,2)],
[R (’h’,8),N (’g’,8),B (’f’,8),K (’e’,8),
Q (’d’,8),B (’c’,8),N (’b’,8),R (’a’,8),
P (’h’,7),P (’g’,7),P (’f’,7),P (’e’,7),
P (’d’,7),P (’c’,7),P (’b’,7),P (’a’,7)])

import Data.Char (ord)
import Data.List

type Location = (Char, Integer)
data Player = White | Black deriving (Show, Eq)
data Piece = P Location | N Location | K Location | Q Location | R Location | B Location deriving (Show, Eq)
type Board = (Player, [Piece], [Piece])

setBoard :: Board
setBoard = (White, 
    [R ('h',1),N ('g',1),B ('f',1),K ('e',1), Q ('d',1),B ('c',1),N ('b',1),R ('a',1),
    P ('h',2),P ('g',2),P ('f',2),P ('e',2), P ('d',2),P ('c',2),P ('b',2),P ('a',2)],
    [R ('h',8),N ('g',8),B ('f',8),K ('e',8), Q ('d',8),B ('c',8),N ('b',8),R ('a',8),
    P ('h',7),P ('g',7),P ('f',7),P ('e',7), P ('d',7),P ('c',7),P ('b',7),P ('a',7)])
	
empty="  "



pieceLocation :: Piece -> Location
pieceLocation (P loc) = loc
pieceLocation (N loc) = loc
pieceLocation (K loc) = loc
pieceLocation (Q loc) = loc
pieceLocation (R loc) = loc
pieceLocation (B loc) = loc

pieceName :: Piece -> String
pieceName (P _) = "P"
pieceName (N _) = "N"
pieceName (K _) = "K"
pieceName (Q _) = "Q"
pieceName (R _) = "R"
pieceName (B _) = "B"



playerColor :: Player->String
playerColor White="White"
playerColor Black="Black"


findBlack ::  Location->[Piece]->String
findBlack l []=empty
findBlack  l (h:t) =
	if pieceLocation h == l then (pieceName h) ++"B"
	else findBlack l t
	
findWhite ::  Location->[Piece]->String
findWhite l []=empty
findWhite  l (h:t) =
	if pieceLocation h == l then (pieceName h )++ "W"
	else findWhite l t


boardRows = [8, 7 .. 1]
boardColumns = ['a' .. 'h']
boardColumns1 = ['8', '7' .. '1']

findPiece  blackList whiteList (char,int) =if findBlack (char,int) blackList ==empty && findWhite (char,int) whiteList==empty then empty
									      else if findBlack (char,int) blackList /= empty then findBlack (char,int) blackList 
										  else  findWhite (char,int) whiteList
										  
			
getAllLocations = [(char,int)|  int <- boardRows, char <- boardColumns]


foo whiteList blackList = map (findPiece blackList whiteList)  getAllLocations

convertToListOfLists :: [a] -> [[a]]
convertToListOfLists [] = []
convertToListOfLists xs = take 8 xs : convertToListOfLists (drop 8 xs)

listToString :: [String] -> String
listToString [] = ""
listToString [x] =  x
listToString (x:xs) = x ++ " | " ++ listToString xs

helper :: [Char] -> [[String]] -> String
helper [] _ = ""
helper _ [] = ""
helper (char:restChars) (h:t) = char : " | " ++ listToString h ++ "\n" ++ helper restChars t



visualizeBoard (p,blackList,whiteList)=
	putStr("    a    b    c    d    e    f    g    h"++ "\n"++ helper boardColumns1 (convertToListOfLists(foo blackList whiteList))++"\n"++"Turn: "++playerColor p)


subtractChars :: Char -> Char -> Int
subtractChars c1 c2 = ord c1 - ord c2

incrementChar :: Char -> Char
incrementChar c = toEnum (fromEnum c + 1)

isHorizontal (char1,int1) (char2,int2)= int1-int2==0
isVertical  (char1,int1) (char2,int2)= subtractChars char1 char2==0
isDiagonal (char1,int1) (char2,int2) = toInteger(abs(subtractChars char1 char2)) == abs (int1-int2)
isL (char1,int1) (char2,int2) = abs(subtractChars char1 char2) == 2 && abs (int1-int2) == 1 || abs(subtractChars char1 char2) == 1 && abs (int1-int2) == 2
										
isHorizontalBlocked :: Location -> Location -> [Piece] -> [Piece] -> Bool
isHorizontalBlocked (char1, int1) (char2, int2) blackList whiteList =
	if char2<char1 then isHorizontalBlocked (char2, int2) (char1, int1) blackList whiteList
    else any (\(char, int) -> int==int1 && char<char2 && char>char1 ) [ (char, int) | (char, int) <- map pieceLocation (blackList++whiteList) ]

isVerticalBlocked :: Location -> Location -> [Piece] -> [Piece] -> Bool
isVerticalBlocked (char1, int1) (char2, int2) blackList whiteList =
	if int2<int1 then isVerticalBlocked (char2, int2) (char1, int1) blackList whiteList
    else any (\(char, int) -> char==char1 && int<int2 && int>int1 ) [ (char, int) | (char, int) <- map pieceLocation (blackList++whiteList)]

--a 8 to h 1
isDiagonalBlocked (char1, int1) (char2, int2) blackList whiteList =
	--top right
	if (int2 > int1 && char2 > char1) then isDiagonalBlockedHelper1 (char1, int1) (char2, int2) blackList whiteList
	--top left
	else if (int2 > int1 && char2 < char1 ) then isDiagonalBlockedHelper2 (char1, int1) (char2, int2) blackList whiteList
	--bottom right
	else if (int2 < int1 && char2 > char1) then isDiagonalBlockedHelper3 (char1, int1) (char2, int2) blackList whiteList
	--bottom left
	else isDiagonalBlockedHelper4 (char1, int1) (char2, int2) blackList whiteList

--top right
isDiagonalBlockedHelper1 (char1, int1) (char2, int2) blackList whiteList = 
	any ( \(char, int) -> toInteger (abs(subtractChars char char1) )== abs (int-int1) && int > int1 && int < int2 && char > char1 && char < char2 ) [ (char, int) | (char, int) <- map pieceLocation (blackList++whiteList)]
--top left
isDiagonalBlockedHelper2 (char1, int1) (char2, int2) blackList whiteList = 
	any (\(char, int) -> toInteger (abs(subtractChars char char1)) ==abs (int-int1) && int > int1 && int < int2 && char < char1 && char2 < char) [ (char, int) | (char, int) <- map pieceLocation (blackList++whiteList)]
--bottom right
isDiagonalBlockedHelper3 (char1, int1) (char2, int2) blackList whiteList = 
	any (\(char, int) -> toInteger (abs(subtractChars char char1)) == abs (int-int1) && int < int1 && int > int2 && char > char1 && char < char2) [ (char, int) | (char, int) <- map pieceLocation (blackList++whiteList)]
--bottom left
isDiagonalBlockedHelper4 (char1, int1) (char2, int2) blackList whiteList = 
	any (\(char, int) ->toInteger( abs(subtractChars char char1)) == abs (int-int1) && int < int1 && int > int2 && char < char1 && char2 < char) [ (char, int) | (char, int) <- map pieceLocation (blackList++whiteList)]

isWithinBorders (char, int) = elem char ['a' .. 'h'] && elem int [8, 7 .. 1]

isOccupiedByPlayer piece blackList whiteList loc =
	if elem piece blackList && (findBlack loc blackList /=empty) || elem piece whiteList && (findWhite loc whiteList /=empty) then True
	else False
	
	
	

isOccupiedByOpponent piece blackList whiteList loc =
	if elem piece blackList && (findBlack loc whiteList /=empty) || elem piece whiteList && (findWhite loc blackList /=empty) then True
	else False

isLegal:: Piece -> Board -> Location -> Bool
isLegal (P (char1, int1))(White,whiteList,blackList)(char2, int2) = 
	if int2>int1 then
		if isOccupiedByPlayer (P (char1, int1)) blackList whiteList (char2, int2) || 
			(not) (isWithinBorders (char2, int2)) || 
			isVerticalBlocked (char1,int1) (char2,int2) blackList whiteList then False
		else
			if isOccupiedByOpponent (P (char1, int1)) blackList whiteList (char2, int2) then
				if abs(subtractChars char1 char2) == 1 && (int2 - int1) == 1 then True
				else False
			else
				if (not) (isVertical (char1,int1) (char2,int2)) then False
				else
					if int1 == 2 && (int2 - int1) <= 2  then True
					else
						if (int2 - int1) <= 1  then True
						else False
	else False
						
isLegal (P (char1, int1))(Black,whiteList,blackList)(char2, int2) = 
    if  int2<int1 then
		if isOccupiedByPlayer (P (char1, int1)) blackList whiteList (char2, int2) || 
			(not) (isWithinBorders (char2, int2)) || 
			isVerticalBlocked (char1,int1) (char2,int2) blackList whiteList then False
		else
			if isOccupiedByOpponent (P (char1, int1)) blackList whiteList (char2, int2) then
				if abs(subtractChars char1 char2) == 1 && (int1 - int2) == 1 then True
				else False
			else
				if (not) (isVertical (char1,int1) (char2,int2)) then False
				else
					if int1 == 7 && (int1 - int2) <= 2 then True
					else
						if (int1 - int2) <= 1 then True
						else False			
	else False


isLegal (N (char1, int1))(player,whiteList,blackList)(char2, int2) = 
		if isOccupiedByPlayer (N (char1, int1)) blackList whiteList (char2, int2) || 
			(not) (isWithinBorders (char2, int2)) || 
			(not) (isL (char1,int1) (char2,int2)) then False
		else True

isLegal (K (char1, int1))(player,whiteList,blackList)(char2, int2) = 
		if isOccupiedByPlayer (K (char1, int1)) blackList whiteList (char2, int2) || 
			(not) (isWithinBorders (char2, int2)) then False
		else
			if abs(subtractChars char1 char2) == 1 && abs(int1 - int2) == 1 then True
			else False

isLegal (Q (char1, int1))(player,whiteList,blackList)(char2, int2) = 
		if isOccupiedByPlayer (Q (char1, int1)) blackList whiteList (char2, int2) || 
			(not) (isWithinBorders (char2, int2)) then False
		else
			if isVertical (char1,int1) (char2,int2) && (not) (isVerticalBlocked (char1,int1) (char2,int2) blackList whiteList) ||
				isHorizontal (char1,int1) (char2,int2) && (not) (isHorizontalBlocked (char1,int1) (char2,int2) blackList whiteList) ||
				isDiagonal (char1,int1) (char2,int2) && (not) (isDiagonalBlocked (char1,int1) (char2,int2) blackList whiteList) then True
			else False

isLegal (R (char1, int1))(player,whiteList,blackList)(char2, int2) = 
		if isOccupiedByPlayer (R (char1, int1)) blackList whiteList (char2, int2) || 
			(not) (isWithinBorders (char2, int2)) then False
		else
			if isVertical (char1,int1) (char2,int2) && (not) (isVerticalBlocked (char1,int1) (char2,int2) blackList whiteList) ||
				isHorizontal (char1,int1) (char2,int2) && (not) (isHorizontalBlocked (char1,int1) (char2,int2) blackList whiteList) then True
			else False
		
isLegal (B (char1, int1))(player,whiteList,blackList)(char2, int2) = 
		if isOccupiedByPlayer (B (char1, int1)) blackList whiteList (char2, int2) || 
			(not) (isWithinBorders (char2, int2)) then False
		else
			if isDiagonal (char1,int1) (char2,int2) && (not) (isDiagonalBlocked (char1,int1) (char2,int2) blackList whiteList) then True
			else False
			
suggestMove:: Piece -> Board -> [Location]
suggestMove piece board= [(char, int) | (char, int) <- getAllLocations, isLegal piece board (char, int)]

move:: Piece -> Location -> Board -> Board
move piece (char2, int2) (player,whiteList,blackList) =
		if elem piece blackList && player == White then error "This is White player's turn, Black can't move."
		else if elem piece whiteList && player == Black then error "This is Black player's turn, White can't move"
		else if (isLegal piece (player,whiteList,blackList) (char2,int2))then 
			if player == Black then (White,whiteList,(delete piece blackList)++[swap piece (char2,int2)] )
			else (Black,(delete piece whiteList)++[swap piece (char2,int2)],blackList)
		else error "error!"
		
		
swap (P loc) loc2 = P loc2
swap (N loc) loc2 = N loc2
swap (Q loc) loc2 = Q loc2
swap (R loc) loc2 = R loc2
swap (K loc) loc2 = K loc2
swap (B loc) loc2 = B loc2

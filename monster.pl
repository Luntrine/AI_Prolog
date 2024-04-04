% Q1

% Basic types
basicType(psychic).
basicType(fighting).
basicType(dark).
basicType(ghost).
basicType(normal).

% Monsters and their types
monster(annihilape, ghost).
monster(espathra, psychic).
monster(flamigo, fighting).
monster(lechonk, normal).
monster(mabosstiff, dark).

% Moves and their types, as well as which Monsters they are assigned to.
% Annihilape Moveset
move(lowKick, fighting).
move(shadowPunch, ghost).
move(rageFist, ghost).
move(bodySlam, normal).

% Espathra Moveset
move(psybeam, psychic).
move(quickAttack, normal).
% Instance of lowKick (already defined)
move(shadowBall, ghost).

% Flamigo Moveset
% Instance of lowKick (already defined)
move(payback, dark).
move(megaKick, normal).
move(closeCombat, fighting).

% LeChonk Moveset
move(tackle, normal).
move(takeDown, normal).
move(zenHeadbutt, psychic).
% Instance of bodySlam (already defined)

% Mabosstiff Moveset
move(snarl, dark).
move(lick, ghost).
move(bite, dark).
% Instance of bodySlam (already defined)

% Annihilape Moveset Assignment
monsterMove(annihilape, lowKick).
monsterMove(annihilape, shadowPunch).
monsterMove(annihilape, rageFist).
monsterMove(annihilape, bodySlam).

% Espathra Moveset Assignment
monsterMove(espathra, psybeam).
monsterMove(espathra, quickAttack).
monsterMove(espathra, lowKick).
monsterMove(espathra, shadowBall).

% Flamigo Moveset Assignment
monsterMove(flamigo, lowKick).
monsterMove(flamigo, payback).
monsterMove(flamigo, megaKick).
monsterMove(flamigo, closeCombat).

% LeChonk Moveset Assigmment
monsterMove(lechonk, tackle).
monsterMove(lechonk, takeDown).
monsterMove(lechonk, zenHeadbutt).
monsterMove(lechonk, bodySlam).

% Mabosstiff Moveset Assignment
monsterMove(mabosstiff, snarl).
monsterMove(mabosstiff, lick).
monsterMove(mabosstiff, bite).
monsterMove(mabosstiff, bodySlam).


% Q2

% Type effectiveness
% Psychic Moves
typeEffectiveness(weak, psychic, psychic).
typeEffectiveness(strong, psychic, fighting).
typeEffectiveness(superweak, psychic, dark).
typeEffectiveness(ordinary, psychic, ghost).
typeEffectiveness(ordinary, psychic, normal).

% Fighting Moves
typeEffectiveness(weak, fighting, psychic).
typeEffectiveness(ordinary, fighting, fighting).
typeEffectiveness(strong, fighting, dark).
typeEffectiveness(superweak, fighting, ghost).
typeEffectiveness(strong, fighting, normal).

% Dark Moves
typeEffectiveness(strong, dark, psychic).
typeEffectiveness(weak, dark, fighting).
typeEffectiveness(weak, dark, dark).
typeEffectiveness(strong, dark, ghost).
typeEffectiveness(ordinary, dark, normal).

% Ghost Moves
typeEffectiveness(strong, ghost, psychic).
typeEffectiveness(ordinary, ghost, fighting).
typeEffectiveness(weak, ghost, dark).
typeEffectiveness(strong, ghost, ghost).
typeEffectiveness(superweak, ghost, normal).

% Normal Moves
typeEffectiveness(ordinary, normal, psychic).
typeEffectiveness(ordinary, normal, fighting).
typeEffectiveness(ordinary, normal, dark).
typeEffectiveness(superweak, normal, ghost).
typeEffectiveness(ordinary, normal, normal).


% Q3

% Basic effectiveness relationships
moreEffective(strong, ordinary).
moreEffective(ordinary, weak).
moreEffective(weak, superweak).


% Q4

% Transitive effectiveness information
moreEffectiveThan(E1, E2) :- 
    moreEffective(E1, E2).

moreEffectiveThan(E1, E2) :- 
    moreEffective(E1, E), 
    moreEffectiveThan(E, E2). % Recursive call in case more than 1 "strength" apart.



% Q5

% Rule for monsters having moves of the same type
monsterMoveMatch(T, MO1, MO2, MV) :-
    monsterMove(MO1, MV), % Check if MO1 has MV
    monsterMove(MO2, MV),% Check if MO2 has MV
    move(MV, T). % Check if MV is of type T


% Q6

% Rule to compare move effectiveness against monsters of a certain type
moreEffectiveMoveType(MV1, MV2, T) :-
    move(MV1, T1), % Get the type of MV1
    move(MV2, T2), % Get the type of MV2
    typeEffectiveness(Effectiveness1, T1, T), % Check effectiveness of MV1 against T
    typeEffectiveness(Effectiveness2, T2, T), % Check effectiveness of MV2 against T
    moreEffectiveThan(Effectiveness1, Effectiveness2). % Compare the effectiveness


% Q7

% Rule to compare move effectiveness between monsters
moreEffectiveMove(MO1, MV1, MO2, MV2) :-
    monsterMove(MO1, MV1), % Check if MO1 has MV1
    monsterMove(MO2, MV2), % Check if MO2 has MV2
    monster(MO1, MOT1), % Get the type of MO1
    monster(MO2, MOT2), % Get the type of MO2
    move(MV1, MVT1), % Get the type of MV1
    move(MV2, MVT2), % Get the type of MV2
    typeEffectiveness(Effectiveness1, MVT1, MOT2), % Check effectiveness of MV1 against MO2
    typeEffectiveness(Effectiveness2, MVT2, MOT1), % Check effectiveness of MV2 against MO1
    moreEffectiveThan(Effectiveness1, Effectiveness2). % Compare the effectiveness



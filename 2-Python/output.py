#
#
# Probably better with graphs, but who's got time for those?
#
#

from enum import Enum

class Moves(Enum):
    A = 1
    X = 1
    ROCK = 1
    B = 2
    Y = 2
    PAPER = 2
    C = 3
    Z = 3
    SCISSORS = 3

score = 0

#Part one

with open('input.txt', encoding="utf-8") as f:
    for line in f:
        game = line.split()
        opponent = Moves[game[0]]
        self = Moves[game[1]]
        if opponent == self:
            score += self.value + 3
        elif opponent == Moves.ROCK:
            if self == Moves.PAPER:
                score += self.value + 6
            else:
                score += self.value
        elif opponent == Moves.PAPER:
            if self == Moves.SCISSORS:
                score += self.value + 6
            else:
                score += self.value
        elif opponent == Moves.SCISSORS:
            if self == Moves.ROCK:
                score += self.value + 6
            else:
                score += self.value

print(score)

#Part two

score = 0

class Strategies(Enum):
    X = 0
    LOSE = 0
    Y = 3
    DRAW = 3
    Z = 6
    WIN = 6

with open('input.txt', encoding="utf-8") as f:
    for line in f:
        game = line.split()
        opponent = Moves[game[0]]
        strategy = Strategies[game[1]]
        score += strategy.value
        if strategy == Strategies.LOSE:
            if opponent == Moves.ROCK:
                score += Moves.SCISSORS.value
            elif opponent == Moves.PAPER:
                score += Moves.ROCK.value
            elif opponent == Moves.SCISSORS:
                score += Moves.PAPER.value
        if strategy == Strategies.WIN:
            if opponent == Moves.ROCK:
                score += Moves.PAPER.value
            elif opponent == Moves.PAPER:
                score += Moves.SCISSORS.value
            elif opponent == Moves.SCISSORS:
                score += Moves.ROCK.value
        if strategy == Strategies.DRAW:
                score += opponent.value
       
print(score)
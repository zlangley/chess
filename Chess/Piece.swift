//
//  Piece.swift
//  Chess
//
//  Created by Zachary Langley on 12/21/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import Foundation

enum Color {
    case White
    case Black
}

enum Role {
    case Pawn
    case Knight
    case Bishop
    case Rook
    case Queen
    case King
}

class Piece: Equatable, DebugPrintable {
    let color: Color
    let role: Role

    // move to board?
    private let squareInBounds: (Square -> Bool) = { (square) in return square.row >= 0 && square.row < 8 && square.col >= 0 && square.col < 8 }

    var debugDescription: String {
        return "[\(color) \(role)]"
    }

    init(color: Color, role: Role) {
        self.color = color
        self.role = role
    }

    func attackSquareGeneratorsFromSquare(square: Square) -> [SquareGenerator] {
        let squareInBounds = self.squareInBounds
        let allValid: (Square, Int) -> Bool = { (square, idx) in squareInBounds(square) }
        let oneMoveValid: (Square, Int) -> Bool = { (square, idx) in return idx <= 1 && squareInBounds(square) }

        switch self.role {
        case .Pawn:
            let rowDelta = (self.color == .White) ? 1 : -1
            return [
                SquareGenerator(startSquare: square, rowDelta: rowDelta, colDelta: 1, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: rowDelta, colDelta: -1, isValid: oneMoveValid),
            ]
        case .Knight:
            return [
                SquareGenerator(startSquare: square, rowDelta: 1, colDelta: 2, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: -1, colDelta: 2, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: 1, colDelta: -2, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: -1, colDelta: -2, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: 2, colDelta: 1, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: -2, colDelta: 1, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: 2, colDelta: -1, isValid: oneMoveValid),
                SquareGenerator(startSquare: square, rowDelta: -2, colDelta: -1, isValid: oneMoveValid)
            ]
        case .Bishop:
            return self.diagonalGeneratorsFromSquare(square, isValid: allValid)
        case .Rook:
            return self.lineGeneratorsFromSquare(square, isValid: allValid)
        case .Queen:
            return self.diagonalGeneratorsFromSquare(square, isValid: allValid) + self.lineGeneratorsFromSquare(square, isValid: allValid)
        case .King:
            return self.diagonalGeneratorsFromSquare(square, isValid: oneMoveValid) + self.lineGeneratorsFromSquare(square, isValid: oneMoveValid)
        }
    }

    func moveSquareGeneratorsFromSquare(square: Square) -> [SquareGenerator] {
        if self.role != .Pawn {
            return attackSquareGeneratorsFromSquare(square)
        }

        let squareInBounds = self.squareInBounds
        let validForNMoves: Int -> (Square, Int) -> Bool = { (moves) in
            return { (square, idx) in return idx <= moves && squareInBounds(square) }
        }
        let numberOfMoves = ((self.color == .White && square.row == 1) || (self.color == .Black && square.row == 6)) ? 2 : 1
        let rowDelta = (self.color == .White) ? 1 : -1
        return attackSquareGeneratorsFromSquare(square) + [SquareGenerator(startSquare: square, rowDelta: rowDelta, colDelta: 0, isValid:validForNMoves(numberOfMoves))]
    }

    // If the piece can move from the square `from` to the square `to`, assuming
    // an empty board.
    func canAttackFromSquare(fromSquare: Square, toSquare: Square) -> Bool {
        for generator in attackSquareGeneratorsFromSquare(fromSquare) {
            if contains(GeneratorSequence(generator), toSquare) {
                return true
            }
        }
        return false
    }

    // If the piece can move from the square `from` to the square `to`, assuming
    // an empty board.
    func canMoveFromSquare(fromSquare: Square, toSquare: Square) -> Bool {
        for generator in moveSquareGeneratorsFromSquare(fromSquare) {
            if contains(GeneratorSequence(generator), toSquare) {
                return true
            }
        }
        return false
    }

    private func diagonalGeneratorsFromSquare(square: Square, isValid: (Square, Int) -> Bool) -> [SquareGenerator] {
        return [
            SquareGenerator(startSquare: square, rowDelta: 1, colDelta: 1, isValid: isValid),
            SquareGenerator(startSquare: square, rowDelta: -1, colDelta: 1, isValid: isValid),
            SquareGenerator(startSquare: square, rowDelta: 1, colDelta: -1, isValid: isValid),
            SquareGenerator(startSquare: square, rowDelta: -1, colDelta: -1, isValid: isValid)
        ]
    }

    private func lineGeneratorsFromSquare(square: Square, isValid: (Square, Int) -> Bool) -> [SquareGenerator] {
        return [
            SquareGenerator(startSquare: square, rowDelta: 0, colDelta: 1, isValid: isValid),
            SquareGenerator(startSquare: square, rowDelta: 0, colDelta: -1, isValid: isValid),
            SquareGenerator(startSquare: square, rowDelta: -1, colDelta: 0, isValid: isValid),
            SquareGenerator(startSquare: square, rowDelta: 1, colDelta: 0, isValid: isValid)
        ]
    }
}

class SquareGenerator: GeneratorType {
    let startSquare: Square
    let rowDelta: Int
    let colDelta: Int
    let isValid: (Square, Int) -> Bool

    var index: Int

    init(startSquare: Square, rowDelta: Int, colDelta: Int, isValid: (Square, Int) -> Bool) {
        self.startSquare = startSquare
        self.rowDelta = rowDelta
        self.colDelta = colDelta
        self.isValid = isValid
        self.index = 0
    }

    func next() -> Square? {
        self.index++
        let nextSquare = Square(row: startSquare.row + rowDelta * index, col: startSquare.col + colDelta * index)
        return isValid(nextSquare, self.index) ? nextSquare : nil
    }
}

func ==(lhs: Piece, rhs: Piece) -> Bool {
    return lhs.color == rhs.color && lhs.role == rhs.role
}

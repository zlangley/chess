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

    var debugDescription: String {
        return "[\(color) \(role)]"
    }

    init(color: Color, role: Role) {
        self.color = color
        self.role = role
    }

    /**
     * Whether or not this piece can move from `fromSquare` to `toSquare`, based on the given
     * board set up, assuming this piece was on `fromSquare`.
     */
    func canMoveFromSquare(fromSquare: Square, toSquare: Square, board: Board) -> Bool {
        for generator in moveSquareGeneratorsFromSquare(fromSquare, board: board) {
            if contains(GeneratorSequence(generator), toSquare) {
                return true
            }
        }
        return false
    }

    private func moveSquareGeneratorsFromSquare(square: Square, board: Board) -> [SquareGenerator] {
        let generalValidity = self.generalValidity(board)
        let oneMoveValidity = generalValidityForNMoves(board, moves: 1)

        switch self.role {
        case .Pawn:
            let pawnAttackValidity: (Square, Int) -> MoveValidity = { (square, index) in
                if let piece = board[square] {
                    return (piece.color == self.color) ? .InvalidMove : .LastValidMove
                }
                return .InvalidMove
            }

            let numberOfMoves = ((self.color == .White && square.row == 1) || (self.color == .Black && square.row == 6)) ? 2 : 1
            let rowDelta = (self.color == .White) ? 1 : -1
            return [
                SquareGenerator(startSquare: square, rowDelta: rowDelta, colDelta: 0, moveValidity: self.generalValidityForNMoves(board, moves: numberOfMoves)),
                SquareGenerator(startSquare: square, rowDelta: rowDelta, colDelta: 1, moveValidity: pawnAttackValidity),
                SquareGenerator(startSquare: square, rowDelta: rowDelta, colDelta: -1, moveValidity: pawnAttackValidity),
            ]
        case .Knight:
            return [
                SquareGenerator(startSquare: square, rowDelta: 1, colDelta: 2, moveValidity: oneMoveValidity),
                SquareGenerator(startSquare: square, rowDelta: -1, colDelta: 2, moveValidity: oneMoveValidity),
                SquareGenerator(startSquare: square, rowDelta: 1, colDelta: -2, moveValidity: oneMoveValidity),
                SquareGenerator(startSquare: square, rowDelta: -1, colDelta: -2, moveValidity: oneMoveValidity),
                SquareGenerator(startSquare: square, rowDelta: 2, colDelta: 1, moveValidity: oneMoveValidity),
                SquareGenerator(startSquare: square, rowDelta: -2, colDelta: 1, moveValidity: oneMoveValidity),
                SquareGenerator(startSquare: square, rowDelta: 2, colDelta: -1, moveValidity: oneMoveValidity),
                SquareGenerator(startSquare: square, rowDelta: -2, colDelta: -1, moveValidity: oneMoveValidity)
            ]
        case .Bishop:
            return self.diagonalGeneratorsFromSquare(square, moveValidity: generalValidity)
        case .Rook:
            return self.lineGeneratorsFromSquare(square, moveValidity: generalValidity)
        case .Queen:
            return self.diagonalGeneratorsFromSquare(square, moveValidity: generalValidity) + self.lineGeneratorsFromSquare(square, moveValidity: generalValidity)
        case .King:
            return self.diagonalGeneratorsFromSquare(square, moveValidity: oneMoveValidity) + self.lineGeneratorsFromSquare(square, moveValidity: oneMoveValidity)
        }
    }

    private func diagonalGeneratorsFromSquare(square: Square, moveValidity: (Square, Int) -> MoveValidity) -> [SquareGenerator] {
        return [
            SquareGenerator(startSquare: square, rowDelta: 1, colDelta: 1, moveValidity: moveValidity),
            SquareGenerator(startSquare: square, rowDelta: -1, colDelta: 1, moveValidity: moveValidity),
            SquareGenerator(startSquare: square, rowDelta: 1, colDelta: -1, moveValidity: moveValidity),
            SquareGenerator(startSquare: square, rowDelta: -1, colDelta: -1, moveValidity: moveValidity)
        ]
    }

    private func lineGeneratorsFromSquare(square: Square, moveValidity: (Square, Int) -> MoveValidity) -> [SquareGenerator] {
        return [
            SquareGenerator(startSquare: square, rowDelta: 0, colDelta: 1, moveValidity: moveValidity),
            SquareGenerator(startSquare: square, rowDelta: 0, colDelta: -1, moveValidity: moveValidity),
            SquareGenerator(startSquare: square, rowDelta: -1, colDelta: 0, moveValidity: moveValidity),
            SquareGenerator(startSquare: square, rowDelta: 1, colDelta: 0, moveValidity: moveValidity)
        ]
    }

    private func generalValidity(board: Board) -> (Square, Int) -> MoveValidity {
        return { (square, idx) in
            if board.containsSquare(square) {
                if let piece = board[square] {
                    return (piece.color == self.color) ? .InvalidMove : .LastValidMove
                } else {
                    return .ValidMove
                }
            } else {
                return .InvalidMove
            }
        }
    }

    private func generalValidityForNMoves(board: Board, moves: Int) -> (Square, Int) -> MoveValidity {
        let generalValidity = self.generalValidity(board)
        return { (square, idx) in
            if (generalValidity(square, idx) == .ValidMove && idx == moves) {
                return .LastValidMove
            }
            return generalValidity(square, idx)
        }
    }
}

enum MoveValidity {
    case InvalidMove
    case ValidMove
    case LastValidMove
}

class SquareGenerator: GeneratorType {
    let startSquare: Square
    let rowDelta: Int
    let colDelta: Int
    let moveValidity: (Square, Int) -> MoveValidity

    private var index: Int
    private var done: Bool

    init(startSquare: Square, rowDelta: Int, colDelta: Int, moveValidity: (Square, Int) -> MoveValidity) {
        self.startSquare = startSquare
        self.rowDelta = rowDelta
        self.colDelta = colDelta
        self.moveValidity = moveValidity
        self.index = 0
        self.done = false
    }

    func next() -> Square? {
        if self.done {
            return nil
        }

        self.index++
        let nextSquare = Square(row: startSquare.row + rowDelta * index, col: startSquare.col + colDelta * index)
        switch moveValidity(nextSquare, self.index) {
        case .InvalidMove:
            return nil
        case .ValidMove:
            return nextSquare
        case .LastValidMove:
            self.done = true
            return nextSquare
        }
    }
}

func ==(lhs: Piece, rhs: Piece) -> Bool {
    return lhs.color == rhs.color && lhs.role == rhs.role
}

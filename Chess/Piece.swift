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

    // If the piece can move from the square `from` to the square `to`, assuming
    // an empty board.
    func canAttackFromSquare(fromSquare: Square, toSquare: Square) -> Bool {
        if (fromSquare == toSquare) {
            return false
        }
        switch (role) {
        case .Pawn:
            return fromSquare.colDistanceToSquare(toSquare) == 1 && fromSquare.rowDeltaToSquare(toSquare) == ((self.color == .White) ? 1 : -1)
        case .Knight:
            let rowDistance = fromSquare.rowDistanceToSquare(toSquare)
            let colDistance = fromSquare.colDistanceToSquare(toSquare)
            return (rowDistance == 1 && colDistance == 2) || (rowDistance == 2 && colDistance == 1)
        case .Bishop:
            return fromSquare.isOnSameDiagonalAsSquare(toSquare)
        case .Rook:
            return fromSquare.isOnSameRowAsSquare(toSquare) || fromSquare.isOnSameColAsSquare(toSquare)
        case .Queen:
            return fromSquare.isOnSameDiagonalAsSquare(toSquare) || fromSquare.isOnSameRowAsSquare(toSquare) || fromSquare.isOnSameColAsSquare(toSquare)
        case .King:
            return fromSquare.isAdjacentToSquare(toSquare)
        }
    }

    // If the piece can move from the square `from` to the square `to`, assuming
    // an empty board.
    func canMoveFromSquare(fromSquare: Square, toSquare: Square) -> Bool {
        if (self.canAttackFromSquare(fromSquare, toSquare: toSquare)) {
            return true
        } else if (self.role == .Pawn && fromSquare.isOnSameColAsSquare(toSquare)) {
            switch (self.color) {
            case .White:
                return fromSquare.rowDeltaToSquare(toSquare) == 1 || (fromSquare.row == 1 && fromSquare.rowDeltaToSquare(toSquare) == 2)
            case .Black:
                return fromSquare.rowDeltaToSquare(toSquare) == -1 || (fromSquare.row == 6 && fromSquare.rowDeltaToSquare(toSquare) == -2)
            }
        } else {
            return false
        }
    }
}

func ==(lhs: Piece, rhs: Piece) -> Bool {
    return lhs.color == rhs.color && lhs.role == rhs.role
}

//
//  Board.swift
//  Chess
//
//  Created by Zachary Langley on 12/21/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import Foundation

class Board {
    let pieceDictionary: [Square: Piece]
    let canWhiteCastleKingside: Bool
    let canWhiteCastleQueenside: Bool
    let canBlackCastleKingside: Bool
    let canBlackCastleQueenside: Bool
    let colorToMove: Color

    init(pieceDictionary: [Square: Piece], canWhiteCastleKingside: Bool, canWhiteCastleQueenside: Bool, canBlackCastleKingside: Bool, canBlackCastleQueenside: Bool, colorToMove: Color) {
        self.pieceDictionary = pieceDictionary
        self.canWhiteCastleKingside = canWhiteCastleKingside
        self.canWhiteCastleQueenside = canWhiteCastleQueenside
        self.canBlackCastleKingside = canBlackCastleKingside
        self.canBlackCastleQueenside = canBlackCastleQueenside
        self.colorToMove = colorToMove
    }

    subscript(square: Square) -> Piece? {
        return pieceDictionary[square]
    }

    subscript(square: String) -> Piece? {
        return pieceDictionary[Square(square)]
    }

    func containsSquare(square: Square) -> Bool {
        return square.row >= 0 && square.row < 8 && square.col >= 0 && square.col < 8
    }

    // Returns self if not possible.
    func boardByMovingPieceFromSquare(fromSquare: Square, toSquare: Square) -> Board {
        if let pieceToMove = self[fromSquare] {
            if pieceToMove.canMoveFromSquare(fromSquare, toSquare: toSquare, board: self) {
                var newPieceDictionary = pieceDictionary
                newPieceDictionary.removeValueForKey(fromSquare)
                newPieceDictionary.updateValue(pieceToMove, forKey: toSquare)
                return Board(pieceDictionary: newPieceDictionary, canWhiteCastleKingside: canWhiteCastleKingside, canWhiteCastleQueenside: canWhiteCastleQueenside, canBlackCastleKingside: canBlackCastleKingside, canBlackCastleQueenside: canBlackCastleQueenside, colorToMove: colorToMove)
            }
        }
        return self
    }
}

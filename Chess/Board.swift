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

    func pieceAtSquare(square: Square) -> Piece? {
        return pieceDictionary[square]
    }

    // Returns self if not possible.
    func boardByMovingPieceFromSquare(fromSquare: Square, toSquare: Square) -> Board {
        if let pieceToMove = self.pieceAtSquare(fromSquare) {
            if let pieceBeingAttacked = self.pieceAtSquare(toSquare) {
                if pieceToMove.canAttackFromSquare(fromSquare, toSquare: toSquare) {
                    var newPieceDictionary = pieceDictionary
                    newPieceDictionary.removeValueForKey(fromSquare)
                    newPieceDictionary.updateValue(pieceToMove, forKey: toSquare)
                    return Board(pieceDictionary: newPieceDictionary, canWhiteCastleKingside: canWhiteCastleKingside, canWhiteCastleQueenside: canWhiteCastleQueenside, canBlackCastleKingside: canBlackCastleKingside, canBlackCastleQueenside: canBlackCastleQueenside, colorToMove: colorToMove)
                }
            } else if pieceToMove.canMoveFromSquare(fromSquare, toSquare: toSquare) {
                var newPieceDictionary = pieceDictionary
                newPieceDictionary.removeValueForKey(fromSquare)
                newPieceDictionary.updateValue(pieceToMove, forKey: toSquare)
                return Board(pieceDictionary: newPieceDictionary, canWhiteCastleKingside: canWhiteCastleKingside, canWhiteCastleQueenside: canWhiteCastleQueenside, canBlackCastleKingside: canBlackCastleKingside, canBlackCastleQueenside: canBlackCastleQueenside, colorToMove: colorToMove)
            }
        }
        return self
    }
}

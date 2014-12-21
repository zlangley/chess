//
//  Board.swift
//  Chess
//
//  Created by Zachary Langley on 12/21/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import Foundation

class Board: NSObject {
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
}

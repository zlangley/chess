//
//  Board+ForsythEdwards.swift
//  Chess
//
//  Created by Zachary Langley on 12/22/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import Foundation

class ForsythEdwardsParser {
    class func parseBoard(notation: String) -> Board {
        let fields = notation.componentsSeparatedByString(" ")

        // Piece placement
        let ranks = fields[0].componentsSeparatedByString("/").map(rankNotationToDictionary)
        let pieces = ranks.reduce((7, [Square: Piece]()), combine: { (pair, fileDictionary) in
            var (rankIndex, pieceDictionary) = pair
            for (file, piece) in fileDictionary {
                pieceDictionary.updateValue(piece, forKey: Square(row: rankIndex, col: file))
            }
            return (rankIndex - 1, pieceDictionary)
        }).1

        // Color to move
        let colorToMove = (fields[1] == "w") ? Color.White : Color.Black

        // Castline ability
        let canWhiteCastleKingSide = fields[2].rangeOfString("K") != nil
        let canWhiteCastleQueenSide = fields[2].rangeOfString("Q") != nil
        let canBlackCastleKingSide = fields[2].rangeOfString("k") != nil
        let canBlackCastleQueenSide = fields[2].rangeOfString("q") != nil

        let enPassantTargetSquare = fields[3]
        let halfMoveClock = fields[4]
        let fullMoveCounter = fields[5]

        return Board(pieceDictionary: pieces, canWhiteCastleKingside: canWhiteCastleKingSide, canWhiteCastleQueenside: canWhiteCastleQueenSide, canBlackCastleKingside: canBlackCastleKingSide, canBlackCastleQueenside: canBlackCastleQueenSide, colorToMove: colorToMove)
    }

    private class func rankNotationToDictionary(rank: String) -> [Int: Piece] {
        return reduce(rank, (0, [Int: Piece]())) { (pair, ch) in
            var (col, dictionary) = pair
            if let piece = self.pieceFromCharacter(ch) {
                dictionary.updateValue(piece, forKey: col)
                return (col + 1, dictionary)
            } else if let blankCols = String(ch).toInt() {
                return (col + blankCols, dictionary)
            } else {
                // Should never happen.
                return (col + 1, dictionary)
            }
        }.1
    }

    private class func pieceFromCharacter(ch: Character) -> Piece? {
        switch (ch) {
        case "p": return Piece(color: Color.Black, role: Role.Pawn)
        case "r": return Piece(color: Color.Black, role: Role.Rook)
        case "n": return Piece(color: Color.Black, role: Role.Knight)
        case "b": return Piece(color: Color.Black, role: Role.Bishop)
        case "k": return Piece(color: Color.Black, role: Role.King)
        case "q": return Piece(color: Color.Black, role: Role.Queen)
        case "P": return Piece(color: Color.White, role: Role.Pawn)
        case "R": return Piece(color: Color.White, role: Role.Rook)
        case "N": return Piece(color: Color.White, role: Role.Knight)
        case "B": return Piece(color: Color.White, role: Role.Bishop)
        case "K": return Piece(color: Color.White, role: Role.King)
        case "Q": return Piece(color: Color.White, role: Role.Queen)
        default: return nil
        }
    }
}

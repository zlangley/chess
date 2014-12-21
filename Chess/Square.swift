//
//  Square.swift
//  Chess
//
//  Created by Zachary Langley on 12/21/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import Foundation

struct Square: Hashable {
    let row: Int
    let col: Int

    var file: String {
        return String(UnicodeScalar(65 + col))
    }

    var rank: String {
        return String(row + 1)
    }

    var description: String {
        return "\(self.file)\(self.rank)"
    }

    var hashValue: Int {
        return self.row * 13 + self.col
    }

    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }

    init(algebraicNotation: String) {
        // FIXME ?
        let upperCase = algebraicNotation.uppercaseString
        let index = advance(upperCase.startIndex, 1)
        let file = upperCase.substringToIndex(index)
        let rank = upperCase.substringFromIndex(index)
        let col = Int(file.unicodeScalars[file.unicodeScalars.startIndex].value) - 65
        let row = rank.toInt()! - 1
        self.init(row: row, col: col)
    }

    func isAdjacentToSquare(square: Square) -> Bool {
        return rowDistanceToSquare(square) <= 1 && colDistanceToSquare(square) <= 1
    }

    func isOnSameDiagonalAsSquare(square: Square) -> Bool {
        return rowDistanceToSquare(square) == colDistanceToSquare(square)
    }

    func isOnSameRowAsSquare(square: Square) -> Bool {
        return self.row == square.row
    }

    func isOnSameColAsSquare(square: Square) -> Bool {
        return self.col == square.col
    }

    func rowDeltaToSquare(square: Square) -> Int {
        return self.row - square.row
    }

    func colDeltaToSquare(square: Square) -> Int {
        return self.col - square.col
    }

    func rowDistanceToSquare(square: Square) -> Int {
        return abs(rowDeltaToSquare(square))
    }

    func colDistanceToSquare(square: Square) -> Int {
        return abs(colDeltaToSquare(square))
    }
}

func ==(lhs: Square, rhs: Square) -> Bool {
    return lhs.isOnSameRowAsSquare(rhs) && lhs.isOnSameColAsSquare(rhs)
}
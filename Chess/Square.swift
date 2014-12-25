//
//  Square.swift
//  Chess
//
//  Created by Zachary Langley on 12/21/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import Foundation

struct Square: Hashable, Printable, DebugPrintable {
    let row: Int
    let col: Int

    var file: String {
        return String(UnicodeScalar(UnicodeScalar("a").value + col))
    }

    var rank: String {
        return String(row + 1)
    }

    var description: String {
        return "\(self.file)\(self.rank)"
    }

    var debugDescription: String {
        return description
    }

    var hashValue: Int {
        return self.row * 13 + self.col
    }

    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }

    init(_ algebraicNotation: String) {
        // FIXME ?
        let lowerCase = algebraicNotation.lowercaseString
        let index = advance(lowerCase.startIndex, 1)
        let file = lowerCase.substringToIndex(index)
        let rank = lowerCase.substringFromIndex(index)
        let col = Int(file.unicodeScalars[file.unicodeScalars.startIndex].value - UnicodeScalar("a").value)
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
        return square.row - self.row
    }

    func colDeltaToSquare(square: Square) -> Int {
        return square.col - self.col
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

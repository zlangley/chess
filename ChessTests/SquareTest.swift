//
//  Square.swift
//  Chess
//
//  Created by Zachary Langley on 12/21/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import Foundation
import XCTest

class SquareTest: XCTestCase {
    func testFile() {
        XCTAssertEqual(Square(row: 0, col: 0).file, "A")
        XCTAssertEqual(Square(row: 3, col: 5).file, "F")
        XCTAssertEqual(Square(row: 7, col: 7).file, "H")
    }

    func testRank() {
        XCTAssertEqual(Square(row: 0, col: 0).rank, "1")
        XCTAssertEqual(Square(row: 3, col: 5).rank, "4")
        XCTAssertEqual(Square(row: 7, col: 7).rank, "8")
    }

    func testDescription() {
        XCTAssertEqual(Square(row: 0, col: 0).description, "A1")
        XCTAssertEqual(Square(row: 3, col: 5).description, "F4")
        XCTAssertEqual(Square(row: 7, col: 7).description, "H8")
    }

    func testAdjacency() {
        XCTAssertTrue(Square(row: 4, col: 4).isAdjacentToSquare(Square(row: 5, col: 5)))
        XCTAssertTrue(Square(row: 4, col: 4).isAdjacentToSquare(Square(row: 5, col: 4)))
        XCTAssertTrue(Square(row: 4, col: 4).isAdjacentToSquare(Square(row: 3, col: 5)))

        XCTAssertFalse(Square(row: 4, col: 4).isAdjacentToSquare(Square(row: 3, col: 6)))
    }

    func testDiagonal() {
        XCTAssertTrue(Square(row: 4, col: 4).isOnSameDiagonalAsSquare(Square(row: 5, col: 5)))
        XCTAssertTrue(Square(row: 4, col: 4).isOnSameDiagonalAsSquare(Square(row: 1, col: 7)))
        XCTAssertTrue(Square(row: 4, col: 4).isOnSameDiagonalAsSquare(Square(row: 2, col: 2)))
        XCTAssertTrue(Square(row: 4, col: 4).isOnSameDiagonalAsSquare(Square(row: 7, col: 1)))

        XCTAssertFalse(Square(row: 4, col: 4).isOnSameDiagonalAsSquare(Square(row: 3, col: 6)))
    }

    func testAlgebraicNotationInitializer() {
        XCTAssertEqual(Square("a1").row, 0)
        XCTAssertEqual(Square("a1").col, 0)
        XCTAssertEqual(Square("A1").row, 0)
        XCTAssertEqual(Square("F4").row, 3)
        XCTAssertEqual(Square("F4").col, 5)
    }
}

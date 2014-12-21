//
//  ForsythEdwardsParserTest.swift
//  Chess
//
//  Created by Zachary Langley on 12/22/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import XCTest

class ForsythEdwardsParserTest: XCTestCase {
    func testFenParsing() {
        // 1. e4 c5 2. Nf3
        let board = ForsythEdwardsParser.parseBoard("rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")

        XCTAssertNil(board.pieceAtSquare(Square(algebraicNotation: "e2")))
        XCTAssertNil(board.pieceAtSquare(Square(algebraicNotation: "c7")))
        XCTAssertNil(board.pieceAtSquare(Square(algebraicNotation: "g1")))

        if let e4 = board.pieceAtSquare(Square(algebraicNotation: "e4")) {
            XCTAssertEqual(e4.color, Color.White)
            XCTAssertEqual(e4.role, Role.Pawn)
        } else {
            XCTFail()
        }

        if let c5 = board.pieceAtSquare(Square(algebraicNotation: "c5")) {
            XCTAssertEqual(c5.color, Color.Black)
            XCTAssertEqual(c5.role, Role.Pawn)
        } else {
            XCTFail()
        }

        if let f3 = board.pieceAtSquare(Square(algebraicNotation: "f3")) {
            XCTAssertEqual(f3.color, Color.White)
            XCTAssertEqual(f3.role, Role.Knight)
        } else {
            XCTFail()
        }

        XCTAssertTrue(board.canWhiteCastleKingside)
        XCTAssertTrue(board.canWhiteCastleQueenside)
        XCTAssertTrue(board.canBlackCastleKingside)
        XCTAssertTrue(board.canBlackCastleQueenside)

        XCTAssertEqual(board.colorToMove, Color.Black)
    }
}

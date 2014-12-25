//
//  PieceTest.swift
//  Chess
//
//  Created by Zachary Langley on 12/24/14.
//  Copyright (c) 2014 Zach Langley. All rights reserved.
//

import XCTest

class PieceTest: XCTestCase {
    func testWhitePawnMovesFromStartingPosition() {
        let whitePawn = Piece(color: .White, role: .Pawn)
        let fromSquare = Square("e2")
        let board = boardWithPieceOnSquare(whitePawn, square: fromSquare)
        let toSquares = [Square("e3"), Square("e4")]
        assertPieceCanOnlyMoveToSquares(whitePawn, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testBlackPawnMovesFromStartingPosition() {
        let blackPawn = Piece(color: .Black, role: .Pawn)
        let fromSquare = Square("e7")
        let board = boardWithPieceOnSquare(blackPawn, square: fromSquare)
        let toSquares = [Square("e5"), Square("e6")]
        assertPieceCanOnlyMoveToSquares(blackPawn, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testWhitePawnMovesFromNonStartingPosition() {
        let whitePawn = Piece(color: .White, role: .Pawn)
        let fromSquare = Square("b4")
        let board = boardWithPieceOnSquare(whitePawn, square: fromSquare)
        let toSquares = [Square("b5")]
        assertPieceCanOnlyMoveToSquares(whitePawn, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testBlackPawnMovesFromNonStartingPosition() {
        let blackPawn = Piece(color: .Black, role: .Pawn)
        let fromSquare = Square("b6")
        let board = boardWithPieceOnSquare(blackPawn, square: fromSquare)
        let toSquares = [Square("b5")]
        assertPieceCanOnlyMoveToSquares(blackPawn, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testWhitePawnAttack() {
        let whitePawn = Piece(color: .White, role: .Pawn)
        let fromSquare = Square("d2")
        let board = ForsythEdwardsParser.parseBoard("k7/8/8/8/8/2p1p3/3P4/7K w - - 0 1")!
        let toSquares = ["d3", "d4", "e3", "c3"].map { (s) -> Square in Square(s) }
        assertPieceCanOnlyMoveToSquares(whitePawn, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testBlackPawnAttack() {
        let whitePawn = Piece(color: .Black, role: .Pawn)
        let fromSquare = Square("d7")
        let board = ForsythEdwardsParser.parseBoard("k7/3p4/2P1P3/8/8/8/8/7K w - - 0 1")!
        let toSquares = ["d6", "d5", "e6", "c6"].map { (s) -> Square in Square(s) }
        assertPieceCanOnlyMoveToSquares(whitePawn, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testKnightMovement() {
        let knight = Piece(color: .White, role: .Knight)
        let fromSquare = Square("d5")
        let board = boardWithPieceOnSquare(knight, square: fromSquare)
        let toSquares = ["e7", "f6", "f4", "e3", "c3", "b4", "b6", "c7"].map { (s) -> Square in Square(s) }
        assertPieceCanOnlyMoveToSquares(knight, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testBishopMovement() {
        let bishop = Piece(color: .White, role: .Bishop)
        let fromSquare = Square("d5")
        let board = boardWithPieceOnSquare(bishop, square: fromSquare)
        let toSquares = ["a2", "b3", "c4", "e6", "f7", "g8", "h1", "g2", "f3", "e4", "c6", "b7", "a8"].map { (s) -> Square in Square(s) }
        assertPieceCanOnlyMoveToSquares(bishop, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testRookMovement() {
        let rook = Piece(color: .Black, role: .Rook)
        let fromSquare = Square("d5")
        let board = boardWithPieceOnSquare(rook, square: fromSquare)
        let toSquares = ["a5", "b5", "c5", "e5", "f5", "g5", "h5", "d1", "d2", "d3", "d4", "d6", "d7", "d8"].map { (s) -> Square in Square(s) }
        assertPieceCanOnlyMoveToSquares(rook, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testQueenMovement() {
        let queen = Piece(color: .Black, role: .Queen)
        let fromSquare = Square("d5")
        let board = boardWithPieceOnSquare(queen, square: fromSquare)
        let toSquares = ["a2", "b3", "c4", "e6", "f7", "g8", "h1", "g2", "f3", "e4", "c6", "b7", "a8", "a5", "b5", "c5", "e5", "f5", "g5", "h5", "d1", "d2", "d3", "d4", "d6", "d7", "d8"].map { (s) -> Square in Square(s) }
        assertPieceCanOnlyMoveToSquares(queen, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testKingMovement() {
        let king = Piece(color: .Black, role: .King)
        let fromSquare = Square("d5")
        let board = boardWithPieceOnSquare(king, square: fromSquare)
        let toSquares = ["d6", "e6", "e5", "e4", "d4", "c4", "c5", "c6"].map { (s) -> Square in Square(s) }
        assertPieceCanOnlyMoveToSquares(king, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testBishopCannotPassThroughPieces() {
        let bishop = Piece(color: .White, role: .Bishop)
        let fromSquare = Square("d4")
        let board = ForsythEdwardsParser.parseBoard("8/8/5R2/2R5/3B4/2R1R3/8/8 w - - 0 1")!
        let toSquares = [Square("e5")]
        assertPieceCanOnlyMoveToSquares(bishop, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func testBishopCanMoveToOppositeColoredPieces() {
        let bishop = Piece(color: .White, role: .Bishop)
        let fromSquare = Square("d4")
        let board = ForsythEdwardsParser.parseBoard("k7/8/5r2/2R5/3B4/2R1r3/8/7K w - - 0 1")!
        let toSquares = [Square("e5"), Square("f6"), Square("e3")]
        assertPieceCanOnlyMoveToSquares(bishop, fromSquare: fromSquare, toSquares: toSquares, board: board)
    }

    func assertPieceCanOnlyMoveToSquares(piece: Piece, fromSquare: Square, toSquares: [Square], board: Board) {
        for row in 0...7 {
            for col in 0...7 {
                let toSquare = Square(row: row, col: col)
                if contains(toSquares, toSquare) {
                    XCTAssertTrue(piece.canMoveFromSquare(fromSquare, toSquare: toSquare, board: board), "\(piece.debugDescription) cannot move from \(fromSquare.debugDescription) to \(toSquare.debugDescription)")
                } else {
                    XCTAssertFalse(piece.canMoveFromSquare(fromSquare, toSquare: toSquare, board: board), "\(piece.debugDescription) can move from \(fromSquare.debugDescription) to \(toSquare.debugDescription)")
                }
            }
        }
    }

    func boardWithPieceOnSquare(piece: Piece, square: Square) -> Board {
        return Board(pieceDictionary: [square: piece], canWhiteCastleKingside: false, canWhiteCastleQueenside: false, canBlackCastleKingside: false, canBlackCastleQueenside: false, colorToMove: Color.White)
    }
}

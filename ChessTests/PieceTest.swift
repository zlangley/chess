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
        let attackSquares = [Square("d3"), Square("f3")]
        let moveToSquares = [Square("d3"), Square("e3"), Square("e4"), Square("f3")]
        assertPieceCanOnlyMoveToSquares(whitePawn, fromSquare: fromSquare, toSquares: moveToSquares)
        assertPieceCanOnlyAttackSquares(whitePawn, fromSquare: fromSquare, toSquares: attackSquares)
    }

    func testBlackPawnMovesFromStartingPosition() {
        let blackPawn = Piece(color: .Black, role: .Pawn)
        let fromSquare = Square("e7")
        let attackSquares = [Square("d6"), Square("f6")]
        let moveToSquares = [Square("d6"), Square("e5"), Square("e6"), Square("f6")]
        assertPieceCanOnlyMoveToSquares(blackPawn, fromSquare: fromSquare, toSquares: moveToSquares)
        assertPieceCanOnlyAttackSquares(blackPawn, fromSquare: fromSquare, toSquares: attackSquares)
    }

    func testWhitePawnMovesFromNonStartingPosition() {
        let whitePawn = Piece(color: .White, role: .Pawn)
        let fromSquare = Square("b4")
        let attackSquares = [Square("a5"), Square("c5")]
        let moveToSquares = [Square("a5"), Square("b5"), Square("c5")]
        assertPieceCanOnlyMoveToSquares(whitePawn, fromSquare: fromSquare, toSquares: moveToSquares)
        assertPieceCanOnlyAttackSquares(whitePawn, fromSquare: fromSquare, toSquares: attackSquares)
    }

    func testBlackPawnMovesFromNonStartingPosition() {
        let whitePawn = Piece(color: .Black, role: .Pawn)
        let fromSquare = Square("b6")
        let attackSquares = [Square("a5"), Square("c5")]
        let moveToSquares = [Square("a5"), Square("b5"), Square("c5")]
        assertPieceCanOnlyMoveToSquares(whitePawn, fromSquare: fromSquare, toSquares: moveToSquares)
        assertPieceCanOnlyAttackSquares(whitePawn, fromSquare: fromSquare, toSquares: attackSquares)
    }

    func testKnightMovement() {
        let knight = Piece(color: .White, role: .Knight)
        let fromSquare = Square("d5")
        let toSquares = [Square("e7"), Square("f6"), Square("f4"), Square("e3"), Square("c3"), Square("b4"), Square("b6"), Square("c7")]
        assertPieceCanOnlyMoveToSquares(knight, fromSquare: fromSquare, toSquares: toSquares)
        assertPieceCanOnlyAttackSquares(knight, fromSquare: fromSquare, toSquares: toSquares)
    }

    func testBishopMovement() {
        let bishop = Piece(color: .White, role: .Bishop)
        let fromSquare = Square("d5")
        let toSquares = [Square("a2"), Square("b3"), Square("c4"), Square("e6"), Square("f7"), Square("g8"), Square("h1"), Square("g2"), Square("f3"), Square("e4"), Square("c6"), Square("b7"), Square("a8")]
        assertPieceCanOnlyMoveToSquares(bishop, fromSquare: fromSquare, toSquares: toSquares)
        assertPieceCanOnlyAttackSquares(bishop, fromSquare: fromSquare, toSquares: toSquares)
    }

    func testRookMovement() {
        let rook = Piece(color: .Black, role: .Rook)
        let fromSquare = Square("d5")
        let toSquares = [Square("a5"), Square("b5"), Square("c5"), Square("e5"), Square("f5"), Square("g5"), Square("h5"), Square("d1"), Square("d2"), Square("d3"), Square("d4"), Square("d6"), Square("d7"), Square("d8")]
        assertPieceCanOnlyMoveToSquares(rook, fromSquare: fromSquare, toSquares: toSquares)
        assertPieceCanOnlyAttackSquares(rook, fromSquare: fromSquare, toSquares: toSquares)
    }

    func testQueenMovement() {
        let queen = Piece(color: .Black, role: .Queen)
        let fromSquare = Square("d5")
        let bishopSquares = [Square("a2"), Square("b3"), Square("c4"), Square("e6"), Square("f7"), Square("g8"), Square("h1"), Square("g2"), Square("f3"), Square("e4"), Square("c6"), Square("b7"), Square("a8")]
        let rookSquares = [Square("a5"), Square("b5"), Square("c5"), Square("e5"), Square("f5"), Square("g5"), Square("h5"), Square("d1"), Square("d2"), Square("d3"), Square("d4"), Square("d6"), Square("d7"), Square("d8")]
        let queenSquares = bishopSquares + rookSquares
        assertPieceCanOnlyMoveToSquares(queen, fromSquare: fromSquare, toSquares: queenSquares)
        assertPieceCanOnlyAttackSquares(queen, fromSquare: fromSquare, toSquares: queenSquares)
    }

    func testKingMovement() {
        let king = Piece(color: .Black, role: .King)
        let fromSquare = Square("d5")
        let toSquares = [Square("d6"), Square("e6"), Square("e5"), Square("e4"), Square("d4"), Square("c4"), Square("c5"), Square("c6")]
        assertPieceCanOnlyMoveToSquares(king, fromSquare: fromSquare, toSquares: toSquares)
        assertPieceCanOnlyAttackSquares(king, fromSquare: fromSquare, toSquares: toSquares)
    }

    func assertPieceCanOnlyMoveToSquares(piece: Piece, fromSquare: Square, toSquares: [Square]) {
        for row in 0...7 {
            for col in 0...7 {
                let toSquare = Square(row: row, col: col)
                if contains(toSquares, toSquare) {
                    XCTAssertTrue(piece.canMoveFromSquare(fromSquare, toSquare: toSquare), "\(piece.debugDescription) cannot move from \(fromSquare.debugDescription) to \(toSquare.debugDescription)")
                } else {
                    XCTAssertFalse(piece.canMoveFromSquare(fromSquare, toSquare: toSquare), "\(piece.debugDescription) can move from \(fromSquare.debugDescription) to \(toSquare.debugDescription)")
                }
            }
        }
    }

    func assertPieceCanOnlyAttackSquares(piece: Piece, fromSquare: Square, toSquares: [Square]) {
        for row in 0...7 {
            for col in 0...7 {
                let toSquare = Square(row: row, col: col)
                if contains(toSquares, toSquare) {
                    XCTAssertTrue(piece.canAttackFromSquare(fromSquare, toSquare: toSquare), "\(piece.debugDescription) cannot attack from \(fromSquare.debugDescription) to \(toSquare.debugDescription)")
                } else {
                    XCTAssertFalse(piece.canAttackFromSquare(fromSquare, toSquare: toSquare), "\(piece.debugDescription) can attack from \(fromSquare.debugDescription) to \(toSquare.debugDescription)")
                }
            }
        }
    }
}

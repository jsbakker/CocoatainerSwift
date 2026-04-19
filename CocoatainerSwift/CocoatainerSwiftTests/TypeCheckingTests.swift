//
//  TypeCheckingTests.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-20.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Testing
@testable import CocoatainerSwift

// Most of the TypeChecking tests in the original Objective-C Cocoatainer are
// invalid on Swift, as the Swift design prevents the otherwise error-throwing
// scenarios at compile-time.
@Suite("TypeCheckingTests") struct TypeCheckingTests {

    init() async throws {
        // Setup
    }

    @Test func resolveFailsWhenDependencyIsntRegistered() throws {

        let config = CCTContainer()
        let foo: Int = 42

        try config.register(
            type: String.self,
            dependentOn: [Int.self],
            constructWith: .withArgs({arg in
                return String(foo)
        }))

        #expect(throws: CCTError.self) {
            try config.resolve(String.self)
        }
    }

    @Test func resolvePrimitiveAsDependency() throws {

        let config = CCTContainer()
        let foo: Int = 42

        try config.register(type: Int.self, withInstance: foo)

        try config.register(
            type: String.self,
            dependentOn: [Int.self],
            constructWith: .withArgs({arg in
                let intArg = arg[0] as! Int
                return String(intArg)
        }))

        let bar = try config.resolve(String.self)
        #expect(bar == "42")
    }
}

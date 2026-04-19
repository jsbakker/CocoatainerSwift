//
//  RegistrationConflictTests.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-20.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Testing
@testable import CocoatainerSwift

@Suite("RegistrationConflictTests") struct RegistrationConflictTests {

    init() async throws {
        // Setup
    }

    @Test func resolveUnregisteredClassThrows() async throws {
        let config = CCTContainer()
        #expect(throws: CCTError.self) {
            try config.resolve(String.self)
        }
    }

    @Test func resolveUnregisteredProtocolThrows() async throws {
        let config = CCTContainer()
        #expect(throws: CCTError.self) {
            try config.resolve((any Hashable).self)
        }
    }

    @Test func registerAbstractResolveConcreteThrows() throws {
        let config = CCTContainer()
        try config.register(type: IndependentA.self, withInstance: NoDepsA())
        #expect(throws: CCTError.self) {
            try config.resolve(NoDepsA.self)
        }
    }

    @Test func registerDependencyCycleThrows() throws {
        let config = CCTContainer()
        #expect(throws: CCTError.self) {
            try config.register(type: String.self, dependentOn: [String.self], constructWith: .withArgs{ _ in String() })
        }
    }

    @Test func registerSameTypeTwiceThrows() throws {
        let config = CCTContainer()
        try config.register(type: IndependentA.self, withInstance: NoDepsA())
        #expect(throws: CCTError.self) {
            try config.register(
                type: IndependentA.self,
                withInstance: NoDepsA())
        }
    }

    @Test func registerConcreteResolveAbstractThrows() throws {
        let config = CCTContainer()
        try config.register(type: NoDepsA.self, withInstance: NoDepsA())
        #expect(throws: CCTError.self) {
            try config.resolve(IndependentA.self)
        }
    }
}

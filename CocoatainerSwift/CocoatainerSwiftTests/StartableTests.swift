//
//  StartableTests.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//

import Testing
@testable import CocoatainerSwift

@Suite("StartableTests") class StartableTests {

    init() async throws {
        // Setup
    }

    deinit {
        // Teardown
    }

    @Test func notResolvedNotStarted() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: CCTStartable.self,
                constructWith: .noArgs({
                    return Startable()
                }))

            // Start before resolving
            try config.start(autoResolve: false)

            let startable = try config.resolveComponent(type: CCTStartable.self) as! Startable
            #expect(!startable.started)
        }
    }

    @Test func resolveAndStart() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: CCTStartable.self,
                constructWith: .noArgs({
                    return Startable()
                }))

            let startable = try config.resolveComponent(type: CCTStartable.self) as! Startable
            try config.start(autoResolve: false)
            #expect(startable.started)
        }
    }

    @Test func autoResolveWithStart() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: Startable.self,
                constructWith: .noArgs({
                    return Startable()
                }))

            try config.registerComponent(type: HasDeps1A.self,
                                     dependentOn: [Startable.self],
                                     constructWith: .withArgs({ deps in
                let dependency: IndependentA = deps[0] as! IndependentA
                return HasDeps1A(dependency1: dependency)
            }))

            try config.registerComponent(type: HasDeps2CShared.self,
                                     dependentOn: [HasDeps1A.self, Startable.self],
                                     constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: IndependentA = deps[1] as! IndependentA
                return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
            }))

            try config.start(autoResolve: true)

            let startable: Startable = try config.resolveComponent(type: Startable.self) as! Startable
            #expect(startable.started == true)
        } catch {
            #expect(Bool(false))
        }
    }
}

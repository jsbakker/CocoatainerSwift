//
//  StartableTests.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

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
            try config.register(
                type: CCTStartable.self,
                constructWith: .noArgs({
                    return Startable()
                }))

            // Start before resolving
            try config.start(autoResolve: false)

            let startable = try config.resolve(CCTStartable.self) as! Startable
            #expect(!startable.started)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveAndStart() throws {
        let config = CCTContainer()

        do {
            try config.register(
                type: CCTStartable.self,
                constructWith: .noArgs({
                    return Startable()
                }))

            let startable = try config.resolve(CCTStartable.self) as! Startable
            try config.start(autoResolve: false)
            #expect(startable.started)
        } catch {
            Issue.record(error)
        }
    }

    @Test func autoResolveWithStart() throws {
        let config = CCTContainer()

        do {
            try config.register(
                type: Startable.self,
                constructWith: .noArgs({
                    return Startable()
                }))

            try config.register(type: HasDeps1A.self,
                                dependentOn: [Startable.self],
                                constructWith: .withArgs({ deps in
                let dependency: IndependentA = deps[0] as! IndependentA
                return HasDeps1A(dependency1: dependency)
            }))

            try config.register(type: HasDeps2CShared.self,
                                dependentOn: [HasDeps1A.self, Startable.self],
                                constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: IndependentA = deps[1] as! IndependentA
                return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
            }))

            try config.start(autoResolve: true)

            let startable: Startable = try config.resolve(Startable.self)
            #expect(startable.started == true)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveAllDeterminism() throws {

        // This was a bug in CocoatainerSwift that didn't
        // exist in the original Objective-C Cocoatainer.
        // Fixed the non-deterministic dict key iteration.
        let expectedLog: [String] = [
            "init: InitLoggerA",
            "init: InitLoggerB",
            "init: InitLoggerC",
            "init: InitLoggerX",
            "init: InitLoggerY",
            "init: InitLoggerZ",
        ]

        let log = ArrayLog()

        for _ in 0..<6 {
            let config = CCTContainer()

            do {
                try config.register(type: Log.self, withInstance: ArrayLog())

                try config.register(
                    type: InitLoggerA.self,
                    withInstance: InitLoggerA(log: log))
                try config.register(
                    type: InitLoggerB.self,
                    withInstance: InitLoggerB(log: log))
                try config.register(
                    type: InitLoggerC.self,
                    withInstance: InitLoggerC(log: log))
                try config.register(
                    type: InitLoggerX.self,
                    withInstance: InitLoggerX(log: log))
                try config.register(
                    type: InitLoggerY.self,
                    withInstance: InitLoggerY(log: log))
                try config.register(
                    type: InitLoggerZ.self,
                    withInstance: InitLoggerZ(log: log))

                try config.start(autoResolve: true)
                let logLines = log.getLines()
                #expect(logLines.count == 6)
                #expect(logLines == expectedLog)
                log.clear()
            } catch {
                Issue.record(error)
            }
        }
    }
}

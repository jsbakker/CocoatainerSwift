//
//  CocoatainerScopeTests.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation
import Testing
@testable import CocoatainerSwift

@Suite("CocoatainerScopeTests") class CocoatainerScopeTests {

    init() async throws {
        // Setup
    }

    deinit {
        // Teardown
    }

    @Test func strongReferenceOutlivesContainerScope() throws {

        var resolved: HasDeps1A? = nil

        autoreleasepool { // scoping block
            let config = CCTContainer()

            do {
                try config.register(
                    type: NoDepsA.self,
                    constructWith: .noArgs({
                        return NoDepsA()
                    }))

                try config.register(type: HasDeps1A.self,
                                    dependentOn: [NoDepsA.self],
                                    constructWith: .withArgs({ deps in
                    let dependency: NoDepsA = deps[0] as! NoDepsA
                    return HasDeps1A(dependency1: dependency)
                }))

                resolved = try config.resolve(HasDeps1A.self)
                #expect(resolved != nil)
                #expect(resolved!.dependency1 is NoDepsA)
            } catch {
                Issue.record(error)
            }
        } // autoreleasepool
        #expect(resolved != nil)
    }

    @Test func weakReferenceDiesWithContainerScope() throws {

        weak var resolved: HasDeps1A? = nil

        autoreleasepool { // scoping block
            let config = CCTContainer()

            do {
                try config.register(
                    type: NoDepsA.self,
                    constructWith: .noArgs({
                        return NoDepsA()
                    }))

                try config.register(type: HasDeps1A.self,
                                    dependentOn: [NoDepsA.self],
                                    constructWith: .withArgs({ deps in
                    let dependency: NoDepsA = deps[0] as! NoDepsA
                    return HasDeps1A(dependency1: dependency)
                }))

                resolved = try config.resolve(HasDeps1A.self)
                #expect(resolved != nil)
                #expect(resolved!.dependency1 is NoDepsA)
            } catch {
                Issue.record(error)
            }
        } // autoreleasepool
        #expect(resolved == nil)
    }

    @Test func scopeEndsTriggersDeinitIfNoOutsideRefs() throws {

        let expected1: String = "Deinit: DescopeLoggerA"
        let expected2: String = "Deinit: DescopeLoggerB"

        let log: Log = ArrayLog()

        autoreleasepool {
            let config = CCTContainer()

            do {
                try config.register(type: Log.self, withInstance: log)

                try config.register(
                    type: UsesLogA.self,
                    dependentOn: [Log.self],
                    constructWith: .withArgs({ deps in
                        let dep: Log = deps[0] as! Log
                        return DescopeLoggerA(log: dep)
                    }))

                try config.register(
                    type: UsesLogB.self,
                    dependentOn: [Log.self],
                    constructWith: .withArgs({ deps in
                        let dep: Log = deps[0] as! Log
                        return DescopeLoggerB(log: dep)
                    }))

                let multiDeps: [Any.Type] = [UsesLogA.self, UsesLogB.self]
                try config.register(type: MultipleDeps.self, dependentOn: multiDeps, constructWith: .withArgs({ args in
                    return DependsOnMultiple(injections: args)
                }))

                let testObject = try config.resolve(MultipleDeps.self)
                #expect(testObject is DependsOnMultiple)

                #expect(log.getLines().count == 0)
            } catch {
                Issue.record(error)
            }
        } // autoreleasepool

        let logLines = log.getLines()
        #expect(logLines.count == 2)
        #expect(logLines.contains(expected1))
        #expect(logLines.contains(expected2))
    }

    @Test func scopeEndsNoDeinitWhenOutsideRefs() throws {

        let log: Log = ArrayLog()
        var dependsOnMultiple: MultipleDeps? = nil

        autoreleasepool {
            let config = CCTContainer()

            do {
                try config.register(type: Log.self, withInstance: log)

                try config.register(
                    type: UsesLogA.self,
                    dependentOn: [Log.self],
                    constructWith: .withArgs({ deps in
                        let dep: Log = deps[0] as! Log
                        return DescopeLoggerA(log: dep)
                    }))

                try config.register(
                    type: UsesLogB.self,
                    dependentOn: [Log.self],
                    constructWith: .withArgs({ deps in
                        let dep: Log = deps[0] as! Log
                        return DescopeLoggerB(log: dep)
                    }))

                let multiDeps: [Any.Type] = [UsesLogA.self, UsesLogB.self]
                try config.register(type: MultipleDeps.self, dependentOn: multiDeps, constructWith: .withArgs({ args in
                    return DependsOnMultiple(injections: args)
                }))

                let testObject = try config.resolve(MultipleDeps.self)
                dependsOnMultiple = testObject
                #expect(dependsOnMultiple is DependsOnMultiple)

                #expect(log.getLines().count == 0)
            } catch {
                Issue.record(error)
            }
        } // autoreleasepool

        let logLines = log.getLines()
        #expect(logLines.count == 0)
    }

    @Test func scopeEndsNoDeinitUntilOutsideRefEnds() throws {

        let expected1: String = "Deinit: DescopeLoggerA"
        let expected2: String = "Deinit: DescopeLoggerB"

        let log: Log = ArrayLog()

        autoreleasepool {
            var dependsOnMultiple: MultipleDeps? = nil

            autoreleasepool {
                let config = CCTContainer()

                do {
                    try config.register(type: Log.self, withInstance: log)

                    try config.register(
                        type: UsesLogA.self,
                        dependentOn: [Log.self],
                        constructWith: .withArgs({ deps in
                            let dep: Log = deps[0] as! Log
                            return DescopeLoggerA(log: dep)
                        }))

                    try config.register(
                        type: UsesLogB.self,
                        dependentOn: [Log.self],
                        constructWith: .withArgs({ deps in
                            let dep: Log = deps[0] as! Log
                            return DescopeLoggerB(log: dep)
                        }))

                    let multiDeps: [Any.Type] = [UsesLogA.self, UsesLogB.self]
                    try config.register(type: MultipleDeps.self, dependentOn: multiDeps, constructWith: .withArgs({ args in
                        return DependsOnMultiple(injections: args)
                    }))

                    let testObject = try config.resolve(MultipleDeps.self)
                    dependsOnMultiple = testObject
                    #expect(dependsOnMultiple is DependsOnMultiple)

                    #expect(log.getLines().count == 0)
                } catch {
                    Issue.record(error)
                }
            } // autoreleasepool inner
            #expect(log.getLines().count == 0)
        } // autoreleasepool outer

        let logLines = log.getLines()
        #expect(logLines.count == 2)
        #expect(logLines.contains(expected1))
        #expect(logLines.contains(expected2))
    }

    @Test func childScopeResolvesParentRegistryPreResolved() throws {

        let expected: String = "Deinit: DescopeLoggerA"

        let outerScope = CCTContainer()

        try outerScope.register(type: Log.self, withInstance: ArrayLog())
        let log = try outerScope.resolve(Log.self)
        #expect(log is ArrayLog)

        autoreleasepool { // inner scope
            let innerScope = CCTContainer() //(parent: outerScope)
            innerScope.addParent(outerScope)

            do {
                try innerScope.register(
                    type: UsesLogA.self,
                    dependentOn: [Log.self],
                    constructWith: .withArgs({deps in
                        let dep: Log = deps[0] as! Log
                        return DescopeLoggerA(log: dep)
                    }))

                let testObject = try innerScope.resolve(UsesLogA.self)
                #expect(testObject is DescopeLoggerA)
                #expect(log.getLines().count == 0)
            } catch {
                Issue.record(error)
            }
        } // end of inner scope

        let logLines = log.getLines()
        #expect(logLines.count == 1)
        #expect(logLines.contains(expected))
    }

    @Test func childScopeResolvesParentRegistryPreviouslyUnresolved() throws {

        let expected: String = "Deinit: DescopeLoggerA"

        let outerScope = CCTContainer()

        try outerScope.register(type: Log.self, withInstance: ArrayLog())

        autoreleasepool { // inner scope
            let innerScope = CCTContainer(parent: outerScope)

            do {
                try innerScope.register(
                    type: UsesLogA.self,
                    dependentOn: [Log.self],
                    constructWith: .withArgs({deps in
                        let dep: Log = deps[0] as! Log
                        return DescopeLoggerA(log: dep)
                    }))

                let testObject = try innerScope.resolve(UsesLogA.self)
                #expect(testObject is DescopeLoggerA)
            } catch {
                Issue.record(error)
            }
        } // end of inner scope

        let log = try outerScope.resolve(Log.self)
        #expect(log is ArrayLog)
        let logLines = log.getLines()
        #expect(logLines.count == 1)
        #expect(logLines.contains(expected))
    }

    @Test func parentScopeResolveChildRegistryThrow() throws {

        let outerScope = CCTContainer()

        try outerScope.register(type: Log.self, constructWith: .noArgs{ ArrayLog() })

        autoreleasepool {
            let innerScope = CCTContainer(parent: outerScope)

            do {
                try innerScope.register(
                    type: UsesLogA.self,
                    dependentOn: [Log.self],
                    constructWith: .withArgs({deps in
                        let dep: Log = deps[0] as! Log
                        return DescopeLoggerA(log: dep)
                    }))
                #expect(throws: CCTError.self) {
                    _ = try outerScope.resolve(UsesLogA.self)
                }
            } catch {
                Issue.record(error)
            }
        } // end of inner scope
    }
}

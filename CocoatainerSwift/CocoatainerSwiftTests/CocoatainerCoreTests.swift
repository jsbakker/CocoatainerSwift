//
//  CocoatainerSwiftTests.swift
//  CocoatainerSwiftTests
//
//  Created by Jeffrey Bakker on 2026-02-14.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Testing
@testable import CocoatainerSwift

@Suite("CocoatainerCoreTests") struct CocoatainerCoreTests {

    init() async throws {
        // Setup
    }

    @Test func resolveInjectedInstanceByInterface() throws {
        let config = CCTContainer()

        do {
            try config.register(type: IndependentA.self, withInstance: NoDepsA())

            let resolved = try config.resolve(IndependentA.self)
            #expect(resolved is NoDepsA)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveInjectedInstanceConcrete() throws {
        let config = CCTContainer()

        do {
            try config.register(type: NoDepsA.self, withInstance: NoDepsA())

            _ = try config.resolve(NoDepsA.self)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveConcreteTypeNoDeps() throws {
        let config = CCTContainer()

        do {
            try config.register(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            _ = try config.resolve(NoDepsA.self)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveDependsOn1() throws {
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

            let resolved = try config.resolve(HasDeps1A.self)
            #expect(resolved.dependency1 is NoDepsA)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveDependsOn1InjectedInstance() throws {
        let config = CCTContainer()

        do {
            try config.register(type: NoDepsA.self, withInstance: NoDepsA())

            try config.register(type: HasDeps1A.self,
                                dependentOn: [NoDepsA.self],
                                constructWith: .withArgs({ deps in
                let dependency: NoDepsA = deps[0] as! NoDepsA
                return HasDeps1A(dependency1: dependency)
            }))

            let resolved = try config.resolve(HasDeps1A.self)
            #expect(resolved.dependency1 is NoDepsA)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveDependsOn2() throws {
        let config = CCTContainer()

        do {
            try config.register(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            try config.register(
                type: NoDepsB.self,
                constructWith: .noArgs({
                    return NoDepsB()
                }))

            try config.register(type: HasDeps2A.self,
                                dependentOn: [NoDepsA.self, NoDepsB.self],
                                constructWith: .withArgs({ deps in
                let dependency1: NoDepsA = deps[0] as! NoDepsA
                let dependency2: NoDepsB = deps[1] as! NoDepsB
                return HasDeps2A(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolve(HasDeps2A.self)
            #expect(resolved.dependency1 is NoDepsA)
            #expect(resolved.dependency2 is NoDepsB)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveDependsOn2InjectedInstanceD1() throws {
        let config = CCTContainer()

        do {
            try config.register(type: NoDepsA.self, withInstance: NoDepsA())

            try config.register(
                type: NoDepsB.self,
                constructWith: .noArgs({
                    return NoDepsB()
                }))

            try config.register(type: HasDeps2A.self,
                                dependentOn: [NoDepsA.self, NoDepsB.self],
                                constructWith: .withArgs({ deps in
                let dependency1: NoDepsA = deps[0] as! NoDepsA
                let dependency2: NoDepsB = deps[1] as! NoDepsB
                return HasDeps2A(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolve(HasDeps2A.self)
            #expect(resolved.dependency1 is NoDepsA)
            #expect(resolved.dependency2 is NoDepsB)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveNestedDependencies() throws {
        let config = CCTContainer()

        do {
            try config.register(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            try config.register(
                type: NoDepsB.self,
                constructWith: .noArgs({
                    return NoDepsB()
                }))

            try config.register(type: HasDeps1A.self,
                                dependentOn: [NoDepsA.self],
                                constructWith: .withArgs({ deps in
                let dependency: NoDepsA = deps[0] as! NoDepsA
                return HasDeps1A(dependency1: dependency)
            }))

            try config.register(type: HasDeps2BRecursive.self,
                                dependentOn: [HasDeps1A.self, NoDepsB.self],
                                constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: NoDepsB = deps[1] as! NoDepsB
                return HasDeps2BRecursive(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolve(HasDeps2BRecursive.self)
            #expect(resolved.dependency1 is HasDeps1A)
            #expect(resolved.dependency2 is NoDepsB)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveNestedDependenciesPassedAsProtocol() throws {
        let config = CCTContainer()

        do {
            try config.register(type: NoDepsA.self, withInstance: NoDepsA())

            try config.register(type: NoDepsB.self, withInstance: NoDepsB())

            try config.register(type: HasDeps1A.self,
                                dependentOn: [NoDepsA.self],
                                constructWith: .withArgs({ deps in
                let dependency: IndependentA = deps[0] as! IndependentA
                return HasDeps1A(dependency1: dependency)
            }))

            try config.register(type: HasDeps2BRecursive.self,
                                dependentOn: [HasDeps1A.self, NoDepsB.self],
                                constructWith: .withArgs({ deps in
                let dependency1: Dependent1A = deps[0] as! Dependent1A
                let dependency2: IndependentB = deps[1] as! IndependentB
                return HasDeps2BRecursive(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolve(HasDeps2BRecursive.self)
            #expect(resolved.dependency1 is HasDeps1A)
            #expect(resolved.dependency2 is NoDepsB)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveNestedSharedDependencies() throws {
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

            try config.register(type: HasDeps2CShared.self,
                                dependentOn: [HasDeps1A.self, NoDepsA.self],
                                constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: NoDepsA = deps[1] as! NoDepsA
                return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolve(HasDeps2CShared.self)
            #expect(resolved.dependency1 is HasDeps1A)
            #expect(resolved.dependency2 is NoDepsA)
        } catch {
            Issue.record(error)
        }
    }

    @Test func resolveNestedSharedDependenciesInjectInstance() throws {
        let config = CCTContainer()

        do {
            let shared: NoDepsA = NoDepsA()
            try config.register(type: NoDepsA.self, withInstance: shared)

            try config.register(
                type: HasDeps1A.self,
                withInstance: HasDeps1A(dependency1: shared))

            try config.register(type: HasDeps2CShared.self,
                                dependentOn: [HasDeps1A.self, NoDepsA.self],
                                constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: NoDepsA = deps[1] as! NoDepsA
                return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolve(HasDeps2CShared.self)
            #expect(resolved.dependency1 is HasDeps1A)
            #expect(resolved.dependency2 is NoDepsA)
        } catch {
            Issue.record(error)
        }
    }
}

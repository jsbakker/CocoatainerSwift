//
//  CocoatainerSwiftTests.swift
//  CocoatainerSwiftTests
//
//  Created by Jeffrey Bakker on 2026-02-14.
//

import Testing
@testable import CocoatainerSwift

@Suite("CocoatainerSwift") class CocoatainerSwiftTests {

    init() async throws {
        // Setup
    }

    deinit {
        // Teardown
    }

    @Test func resolveUnregisteredClassThrows() async throws {
        let config = CCTContainer()
        #expect(throws: (any Error).self) {
            try config.resolveComponent(type: String.self)
        }
    }

    @Test func resolveUnregisteredProtocolThrows() async throws {
        let config = CCTContainer()
        #expect(throws: (any Error).self) {
            try config.resolveComponent(type: (any Hashable).self)
        }
    }

    @Test func registerAbstractResolveConcreteThrows() throws {
        let config = CCTContainer()
        try config.registerComponent(
            type: IndependentA.self,
            withInstance: NoDepsA())
        #expect(throws: (any Error).self) {
            try config.resolveComponent(type: NoDepsA.self)
        }
    }

    @Test func registerDependencyCycleThrows() throws {
        let config = CCTContainer()
        #expect(throws: (any Error).self) {
            try config.registerComponent(type: String.self, dependentOn: [String.self], constructWith: .withArgs{ _ in String() })
        }
    }

    @Test func registerSameTypeTwiceThrows() throws {
        let config = CCTContainer()
        try config.registerComponent(
            type: IndependentA.self,
            withInstance: NoDepsA())
        #expect(throws: (any Error).self) {
            try config.registerComponent(
                type: IndependentA.self,
                withInstance: NoDepsA())
        }
    }

    @Test func registerConcreteResolveAbstractThrows() throws {
        let config = CCTContainer()
        try config.registerComponent(
            type: NoDepsA.self,
            withInstance: NoDepsA())
        #expect(throws: (any Error).self) {
            try config.resolveComponent(type: IndependentA.self)
        }
    }

    @Test func resolveInjectedInstanceByInterface() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: IndependentA.self,
                withInstance: NoDepsA())

            let resolved = try config.resolveComponent(type: IndependentA.self)
            #expect(resolved != nil)
            #expect(resolved is IndependentA)
            #expect(resolved is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveInjectedInstance() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                withInstance: NoDepsA())

            let resolved = try config.resolveComponent(type: NoDepsA.self)
            #expect(resolved != nil)
            #expect(resolved is IndependentA)
            #expect(resolved is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNoDeps() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            let resolved = try config.resolveComponent(type: NoDepsA.self)
            #expect(resolved != nil)
            #expect(resolved is IndependentA)
            #expect(resolved is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveDependsOn1() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            try config.registerComponent(type: HasDeps1A.self,
                                         dependentOn: [NoDepsA.self],
                                         constructWith: .withArgs({ deps in
                let dependency: NoDepsA = deps[0] as! NoDepsA
                return HasDeps1A(dependency1: dependency)
            }))

            let resolved = try config.resolveComponent(type: HasDeps1A.self)
            #expect(resolved != nil)
            #expect(resolved is Dependent1A)
            #expect(resolved is HasDeps1A)

            let concrete: HasDeps1A = resolved as! HasDeps1A
            #expect(concrete.dependency1 is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveDependsOn1InjectedInstance() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                withInstance: NoDepsA())

            try config.registerComponent(type: HasDeps1A.self,
                                         dependentOn: [NoDepsA.self],
                                         constructWith: .withArgs({ deps in
                let dependency: NoDepsA = deps[0] as! NoDepsA
                return HasDeps1A(dependency1: dependency)
            }))

            let resolved = try config.resolveComponent(type: HasDeps1A.self)
            #expect(resolved != nil)
            #expect(resolved is Dependent1A)
            #expect(resolved is HasDeps1A)

            let concrete: HasDeps1A = resolved as! HasDeps1A
            #expect(concrete.dependency1 is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveDependsOn2() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            try config.registerComponent(
                type: NoDepsB.self,
                constructWith: .noArgs({
                    return NoDepsB()
                }))

            try config.registerComponent(type: HasDeps2A.self,
                                         dependentOn: [NoDepsA.self, NoDepsB.self],
                                         constructWith: .withArgs({ deps in
                let dependency1: NoDepsA = deps[0] as! NoDepsA
                let dependency2: NoDepsB = deps[1] as! NoDepsB
                return HasDeps2A(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolveComponent(type: HasDeps2A.self)
            #expect(resolved != nil)
            #expect(resolved is Dependent2A)
            #expect(resolved is HasDeps2A)

            let concrete: HasDeps2A = resolved as! HasDeps2A
            #expect(concrete.dependency1 is NoDepsA)
            #expect(concrete.dependency2 is NoDepsB)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveDependsOn2InjectedInstanceD1() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                withInstance: NoDepsA())

            try config.registerComponent(
                type: NoDepsB.self,
                constructWith: .noArgs({
                    return NoDepsB()
                }))

            try config.registerComponent(type: HasDeps2A.self,
                                         dependentOn: [NoDepsA.self, NoDepsB.self],
                                         constructWith: .withArgs({ deps in
                let dependency1: NoDepsA = deps[0] as! NoDepsA
                let dependency2: NoDepsB = deps[1] as! NoDepsB
                return HasDeps2A(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolveComponent(type: HasDeps2A.self)
            #expect(resolved != nil)
            #expect(resolved is Dependent2A)
            #expect(resolved is HasDeps2A)

            let concrete: HasDeps2A = resolved as! HasDeps2A
            #expect(concrete.dependency1 is NoDepsA)
            #expect(concrete.dependency2 is NoDepsB)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNestedDependencies() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            try config.registerComponent(
                type: NoDepsB.self,
                constructWith: .noArgs({
                    return NoDepsB()
                }))

            try config.registerComponent(type: HasDeps1A.self,
                                     dependentOn: [NoDepsA.self],
                                     constructWith: .withArgs({ deps in
                let dependency: NoDepsA = deps[0] as! NoDepsA
                return HasDeps1A(dependency1: dependency)
            }))

            try config.registerComponent(type: HasDeps2BRecursive.self,
                                     dependentOn: [HasDeps1A.self, NoDepsB.self],
                                     constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: NoDepsB = deps[1] as! NoDepsB
                return HasDeps2BRecursive(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolveComponent(type: HasDeps2BRecursive.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2BRecursive)

            let concrete: HasDeps2BRecursive = resolved as! HasDeps2BRecursive
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsB)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNestedDependenciesPassedAsProtocol() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                withInstance: NoDepsA())

            try config.registerComponent(
                type: NoDepsB.self,
                withInstance: NoDepsB())

            try config.registerComponent(type: HasDeps1A.self,
                                     dependentOn: [NoDepsA.self],
                                     constructWith: .withArgs({ deps in
                let dependency: IndependentA = deps[0] as! IndependentA
                return HasDeps1A(dependency1: dependency)
            }))

            try config.registerComponent(type: HasDeps2BRecursive.self,
                                     dependentOn: [HasDeps1A.self, NoDepsB.self],
                                     constructWith: .withArgs({ deps in
                let dependency1: Dependent1A = deps[0] as! Dependent1A
                let dependency2: IndependentB = deps[1] as! IndependentB
                return HasDeps2BRecursive(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolveComponent(type: HasDeps2BRecursive.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2BRecursive)

            let concrete: HasDeps2BRecursive = resolved as! HasDeps2BRecursive
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsB)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNestedSharedDependencies() throws {
        let config = CCTContainer()

        do {
            try config.registerComponent(
                type: NoDepsA.self,
                constructWith: .noArgs({
                    return NoDepsA()
                }))

            try config.registerComponent(type: HasDeps1A.self,
                                     dependentOn: [NoDepsA.self],
                                     constructWith: .withArgs({ deps in
                let dependency: NoDepsA = deps[0] as! NoDepsA
                return HasDeps1A(dependency1: dependency)
            }))

            try config.registerComponent(type: HasDeps2CShared.self,
                                     dependentOn: [HasDeps1A.self, NoDepsA.self],
                                     constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: NoDepsA = deps[1] as! NoDepsA
                return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolveComponent(type: HasDeps2CShared.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2CShared)

            let concrete: HasDeps2CShared = resolved as! HasDeps2CShared
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNestedSharedDependenciesInjectInstance() throws {
        let config = CCTContainer()

        do {
            let shared: NoDepsA = NoDepsA()
            try config.registerComponent(
                type: NoDepsA.self,
                withInstance: shared)

            try config.registerComponent(
                type: HasDeps1A.self,
                withInstance: HasDeps1A(dependency1: shared))

            try config.registerComponent(type: HasDeps2CShared.self,
                                     dependentOn: [HasDeps1A.self, NoDepsA.self],
                                     constructWith: .withArgs({ deps in
                let dependency1: HasDeps1A = deps[0] as! HasDeps1A
                let dependency2: NoDepsA = deps[1] as! NoDepsA
                return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
            }))

            let resolved = try config.resolveComponent(type: HasDeps2CShared.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2CShared)

            let concrete: HasDeps2CShared = resolved as! HasDeps2CShared
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsA)
        } catch {
            #expect(Bool(false))
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

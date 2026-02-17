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
            try config.resolveComponent(abstraction: String.self)
        }
    }

    @Test func resolveUnregisteredProtocolThrows() async throws {
        let config = CCTContainer()
        #expect(throws: (any Error).self) {
            try config.resolveComponent(abstraction: (any Hashable).self)
        }
    }

    @Test func registerAbstractResolveConcreteThrows() throws {
        let config = CCTContainer()
        config.registerComponent(
            abstraction: IndependentA.self,
            withInstance: NoDepsA())
        #expect(throws: (any Error).self) {
            try config.resolveComponent(abstraction: NoDepsA.self)
        }
    }

    @Test func registerConcreteResolveAbstractThrows() throws {
        let config = CCTContainer()
        config.registerComponent(
            abstraction: NoDepsA.self,
            withInstance: NoDepsA())
        #expect(throws: (any Error).self) {
            try config.resolveComponent(abstraction: IndependentA.self)
        }
    }

    @Test func resolveInjectedInstanceByInterface() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: IndependentA.self,
            withInstance: NoDepsA())

        do {
            let resolved = try config.resolveComponent(abstraction: IndependentA.self)
            #expect(resolved != nil)
            #expect(resolved is IndependentA)
            #expect(resolved is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveInjectedInstance() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            withInstance: NoDepsA())

        do {
            let resolved = try config.resolveComponent(abstraction: NoDepsA.self)
            #expect(resolved != nil)
            #expect(resolved is IndependentA)
            #expect(resolved is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNoDeps() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            initsWith: .noArgs({
                return NoDepsA()
            }))

        do {
            let resolved = try config.resolveComponent(abstraction: NoDepsA.self)
            #expect(resolved != nil)
            #expect(resolved is IndependentA)
            #expect(resolved is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveDependsOn1() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            initsWith: .noArgs({
                return NoDepsA()
            }))

        config.registerComponent(abstraction: HasDeps1A.self,
                                 dependentOn: [NoDepsA.self],
                                 initsWith: .withArgs({ deps in
            let dependency: NoDepsA = deps[0] as! NoDepsA
            return HasDeps1A(dependency1: dependency)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps1A.self)
            #expect(resolved != nil)
            #expect(resolved is Dependent1A)
            #expect(resolved is HasDeps1A)

            let concrete: HasDeps1A = resolved as! HasDeps1A
            #expect(concrete.dependency1 is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveDependsOn1InjectedInstance() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            withInstance: NoDepsA())

        config.registerComponent(abstraction: HasDeps1A.self,
                                 dependentOn: [NoDepsA.self],
                                 initsWith: .withArgs({ deps in
            let dependency: NoDepsA = deps[0] as! NoDepsA
            return HasDeps1A(dependency1: dependency)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps1A.self)
            #expect(resolved != nil)
            #expect(resolved is Dependent1A)
            #expect(resolved is HasDeps1A)

            let concrete: HasDeps1A = resolved as! HasDeps1A
            #expect(concrete.dependency1 is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveDependsOn2() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            initsWith: .noArgs({
                return NoDepsA()
            }))

        config.registerComponent(
            abstraction: NoDepsB.self,
            initsWith: .noArgs({
                return NoDepsB()
            }))

        config.registerComponent(abstraction: HasDeps2A.self,
                                 dependentOn: [NoDepsA.self, NoDepsB.self],
                                 initsWith: .withArgs({ deps in
            let dependency1: NoDepsA = deps[0] as! NoDepsA
            let dependency2: NoDepsB = deps[1] as! NoDepsB
            return HasDeps2A(dependency1: dependency1, dependency2: dependency2)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps2A.self)
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

    @Test func resolveDependsOn2InjectedInstanceD1() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            withInstance: NoDepsA())

        config.registerComponent(
            abstraction: NoDepsB.self,
            initsWith: .noArgs({
                return NoDepsB()
            }))

        config.registerComponent(abstraction: HasDeps2A.self,
                                 dependentOn: [NoDepsA.self, NoDepsB.self],
                                 initsWith: .withArgs({ deps in
            let dependency1: NoDepsA = deps[0] as! NoDepsA
            let dependency2: NoDepsB = deps[1] as! NoDepsB
            return HasDeps2A(dependency1: dependency1, dependency2: dependency2)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps2A.self)
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

    @Test func resolveNestedDependencies() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            initsWith: .noArgs({
                return NoDepsA()
            }))

        config.registerComponent(
            abstraction: NoDepsB.self,
            initsWith: .noArgs({
                return NoDepsB()
            }))

        config.registerComponent(abstraction: HasDeps1A.self,
                                 dependentOn: [NoDepsA.self],
                                 initsWith: .withArgs({ deps in
            let dependency: NoDepsA = deps[0] as! NoDepsA
            return HasDeps1A(dependency1: dependency)
        }))

        config.registerComponent(abstraction: HasDeps2BRecursive.self,
                                 dependentOn: [HasDeps1A.self, NoDepsB.self],
                                 initsWith: .withArgs({ deps in
            let dependency1: HasDeps1A = deps[0] as! HasDeps1A
            let dependency2: NoDepsB = deps[1] as! NoDepsB
            return HasDeps2BRecursive(dependency1: dependency1, dependency2: dependency2)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps2BRecursive.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2BRecursive)

            let concrete: HasDeps2BRecursive = resolved as! HasDeps2BRecursive
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsB)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNestedDependenciesPassedAsProtocol() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            withInstance: NoDepsA())

        config.registerComponent(
            abstraction: NoDepsB.self,
            withInstance: NoDepsB())

        config.registerComponent(abstraction: HasDeps1A.self,
                                 dependentOn: [NoDepsA.self],
                                 initsWith: .withArgs({ deps in
            let dependency: IndependentA = deps[0] as! IndependentA
            return HasDeps1A(dependency1: dependency)
        }))

        config.registerComponent(abstraction: HasDeps2BRecursive.self,
                                 dependentOn: [HasDeps1A.self, NoDepsB.self],
                                 initsWith: .withArgs({ deps in
            let dependency1: Dependent1A = deps[0] as! Dependent1A
            let dependency2: IndependentB = deps[1] as! IndependentB
            return HasDeps2BRecursive(dependency1: dependency1, dependency2: dependency2)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps2BRecursive.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2BRecursive)

            let concrete: HasDeps2BRecursive = resolved as! HasDeps2BRecursive
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsB)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNestedSharedDependencies() {
        let config = CCTContainer()

        config.registerComponent(
            abstraction: NoDepsA.self,
            initsWith: .noArgs({
                return NoDepsA()
            }))

        config.registerComponent(abstraction: HasDeps1A.self,
                                 dependentOn: [NoDepsA.self],
                                 initsWith: .withArgs({ deps in
            let dependency: NoDepsA = deps[0] as! NoDepsA
            return HasDeps1A(dependency1: dependency)
        }))

        config.registerComponent(abstraction: HasDeps2CShared.self,
                                 dependentOn: [HasDeps1A.self, NoDepsA.self],
                                 initsWith: .withArgs({ deps in
            let dependency1: HasDeps1A = deps[0] as! HasDeps1A
            let dependency2: NoDepsA = deps[1] as! NoDepsA
            return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps2CShared.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2CShared)

            let concrete: HasDeps2CShared = resolved as! HasDeps2CShared
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }

    @Test func resolveNestedSharedDependenciesInjectInstance() {
        let config = CCTContainer()

        let shared: NoDepsA = NoDepsA()
        config.registerComponent(
            abstraction: NoDepsA.self,
            withInstance: shared)

        config.registerComponent(
            abstraction: HasDeps1A.self,
            withInstance: HasDeps1A(dependency1: shared))

        config.registerComponent(abstraction: HasDeps2CShared.self,
                                 dependentOn: [HasDeps1A.self, NoDepsA.self],
                                 initsWith: .withArgs({ deps in
            let dependency1: HasDeps1A = deps[0] as! HasDeps1A
            let dependency2: NoDepsA = deps[1] as! NoDepsA
            return HasDeps2CShared(dependency1: dependency1, dependency2: dependency2)
        }))

        do {
            let resolved = try config.resolveComponent(abstraction: HasDeps2CShared.self)
            #expect(resolved != nil)
            #expect(resolved is HasDeps2CShared)

            let concrete: HasDeps2CShared = resolved as! HasDeps2CShared
            #expect(concrete.dependency1 is HasDeps1A)
            #expect(concrete.dependency2 is NoDepsA)
        } catch {
            #expect(Bool(false))
        }
    }
}

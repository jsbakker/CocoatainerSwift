//
//  CocoatainerScopeTests.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//

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
                #expect(Bool(false))
            }
        }
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
                #expect(Bool(false))
            }
        }
        #expect(resolved == nil)
    }
}

//
//  Deps.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-16.
//
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

protocol Dependent1A {
}

protocol Dependent1B {
}

protocol Dependent2A {
}

protocol Dependent2B {
}

protocol Dependent2C {
}

class HasDeps1A: Dependent1A {
    var dependency1: IndependentA
    init(dependency1: IndependentA) {
        self.dependency1 = dependency1
    }
}

class HasDeps1B: Dependent1B {
    var dependency1: IndependentB
    init(dependency1: IndependentB) {
        self.dependency1 = dependency1
    }
}

class HasDeps2A: Dependent2A {
    var dependency1: IndependentA
    var dependency2: IndependentB
    init(dependency1: IndependentA, dependency2: IndependentB) {
        self.dependency1 = dependency1
        self.dependency2 = dependency2
    }
}

class HasDeps2BRecursive: Dependent2B {
    var dependency1: Dependent1A
    var dependency2: IndependentB
    init(dependency1: Dependent1A, dependency2: IndependentB) {
        self.dependency1 = dependency1
        self.dependency2 = dependency2
    }
}

class HasDeps2CShared: Dependent2C {
    var dependency1: Dependent1A
    var dependency2: IndependentA
    init(dependency1: Dependent1A, dependency2: IndependentA) {
        self.dependency1 = dependency1
        self.dependency2 = dependency2
    }
}

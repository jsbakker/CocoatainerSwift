//
//  NoDeps.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-16.
//
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

protocol IndependentA {
}

protocol IndependentB {
}

protocol IndependentC {
}

class NoDepsA: IndependentA {
}

class NoDepsB: IndependentB {
}

class NoDepsC: IndependentC {
}

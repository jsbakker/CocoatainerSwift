//
//  Startable.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-17.
//
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import CocoatainerSwift

class Startable: IndependentA, CCTStartable {
    var started: Bool = false
    func start() {
        self.started = true
        print("Starting object of type: \(Self.self)")
    }
}

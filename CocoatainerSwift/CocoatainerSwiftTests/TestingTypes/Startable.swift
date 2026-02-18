//
//  Startable.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-17.
//

import CocoatainerSwift

class Startable: IndependentA, CCTStartable {
    var started: Bool = false
    func start() {
        self.started = true
        print("Starting object of type: \(Self.self)")
    }
}

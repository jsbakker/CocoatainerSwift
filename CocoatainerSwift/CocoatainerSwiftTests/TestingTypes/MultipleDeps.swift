//
//  MultipleDeps.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//

protocol MultipleDeps {
    var injections: [Any] { get set }
}

class DependsOnMultiple: MultipleDeps {
    var injections: [Any] = []

    init(injections: [Any]) {
        self.injections = injections
    }
}

//
//  CCTRegistry.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-14.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

typealias VisitComponents = (String, CCTComponent) throws -> Void

class CCTRegistry {
    var components: [String:CCTComponent]
    var parent: CCTRegistry?

    init() {
        self.components = [:]
        self.parent = nil
    }

    deinit {
        self.components.removeAll()
        self.parent = nil
    }

    func setParent(_ parent: CCTRegistry) {
        self.parent = parent
    }

    func getComponentRegistry(key: String) -> CCTComponent? {
        if self.components.keys.contains(key) {
            return self.components[key]
        }

        if parent != nil {
            return parent?.getComponentRegistry(key: key)
        }

        return nil
    }

    func traverseAndExecute(visitor: VisitComponents) rethrows {
        for key in self.components.keys {
            if let component = self.components[key] {
                try visitor(key, component)
            }
        }
    }

    func addComponent(type: Any.Type, instance: Any) throws {

        try addComponent(
            type: type,
            dependencies: nil,
            initWithDepsArray: false,
            constructionInfo: nil,
            instance: instance)
    }

    func addComponent(
        type: Any.Type,
        dependencies: [Any.Type]?,
        initWithDepsArray: Bool,
        constructionInfo: CCTComponentFactory?) throws {

            try addComponent(
                type: type,
                dependencies: dependencies,
                initWithDepsArray: initWithDepsArray,
                constructionInfo: constructionInfo,
                instance: nil)
    }

    private func addComponent(
        type: Any.Type,
        dependencies: [Any.Type]?,
        initWithDepsArray: Bool,
        constructionInfo: CCTComponentFactory?,
        instance: Any?) throws {

        let componentKey: String = String(reflecting: type.self)
        if components.keys.contains(componentKey) {
            throw CCTError.unableToResolveDependency("Duplicate abstraction: \(type)")
        }

        let component = CCTComponent()
        component.typeInfo = type
        component.constructionInfo = constructionInfo
        component.instance = instance
        component.dependencies = dependencies
        component.initWithDepsArray = initWithDepsArray

        self.components[componentKey] = component
    }
}

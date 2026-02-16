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

typealias VisitComponents = (CCTComponent) -> Void

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

    func addParent(_ parent: CCTRegistry) {
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

    func traverseAndExecute(visitor: VisitComponents) {
        for key in self.components.keys {
            if let component = self.components[key] {
                visitor(component)
            }
        }
    }

    func addComponent(abstraction: Any.Type, instance: Any) {

        addComponent(
            abstraction: abstraction,
            dependencies: nil,
            initWithDepsArray: false,
            constructionInfo: nil,
            instance: instance)
    }

    func addComponent(
        abstraction: Any.Type,
        dependencies: [Any.Type]?,
        initWithDepsArray: Bool,
        constructionInfo: CCTComponentFactory?) {

            addComponent(
                abstraction: abstraction,
                dependencies: dependencies,
                initWithDepsArray: initWithDepsArray,
                constructionInfo: constructionInfo,
                instance: nil)
    }

    private func addComponent(
        abstraction: Any.Type,
        dependencies: [Any.Type]?,
        initWithDepsArray: Bool,
        constructionInfo: CCTComponentFactory?,
        instance: Any?) {

        let componentKey: String = String(reflecting: abstraction.self)
        if components.keys.contains(componentKey) {
            fatalError("Duplicate abstraction: \(abstraction)")
        }

        var component: CCTComponent = CCTComponent()
        component.abstraction = abstraction
        component.constructionInfo = constructionInfo
        component.instance = instance
        component.dependencies = dependencies
        component.initWithDepsArray = initWithDepsArray

        self.components[componentKey] = component
    }
}

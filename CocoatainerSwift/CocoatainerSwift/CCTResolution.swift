//
//  CCTResolution.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

enum CCTError: Error {
    case unableToResolveDependency(String)
}

func resolveComponent(abstraction: Any.Type, fromRegistry: CCTRegistry) throws -> Any? {

    let componentKey: String = String(reflecting: abstraction.self)
    if !fromRegistry.components.keys.contains(componentKey) {
        throw CCTError.unableToResolveDependency("Cannot resolve unregistered component: \(abstraction)")
    }

    let component: CCTComponent = fromRegistry.components[componentKey]!
    var resolvedInstance = component.instance
    if resolvedInstance != nil {
        return resolvedInstance!
    }

    let initializer: CCTComponentFactory? = component.constructionInfo
    if initializer == nil {
        return nil
    }

    resolvedInstance = resolveDependencies(
        component: component, fromRegistry: fromRegistry, andConstruct: initializer!)

    component.instance = resolvedInstance
    return resolvedInstance
}

func resolveDependencies(component: CCTComponent,
                         fromRegistry: CCTRegistry,
                         andConstruct: CCTComponentFactory) -> Any? {

    let dependencies = component.dependencies
    if dependencies == nil || dependencies!.isEmpty {
        return andConstruct.create()
    }
    return resolveConstructableDependencies(dependencies: dependencies!, fromRegistry: fromRegistry, andConstruct: andConstruct)
}

func resolveConstructableDependencies(dependencies: [Any.Type],
                                      fromRegistry: CCTRegistry,
                                      andConstruct: CCTComponentFactory) -> Any? {
    var depInstances: [Any] = []
    
    for dep in dependencies {
        do {
            let instance = try resolveComponent(abstraction: dep, fromRegistry: fromRegistry)
            depInstances.append(instance!)
        } catch {
            return nil
        }
    }

    return andConstruct.create(with: depInstances)
}

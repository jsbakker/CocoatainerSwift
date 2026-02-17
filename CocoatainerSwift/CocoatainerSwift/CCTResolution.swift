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

func resolveComponent(type: Any.Type, fromRegistry: CCTRegistry) throws -> Any? {

    let componentKey: String = String(reflecting: type.self)
    if !fromRegistry.components.keys.contains(componentKey) {
        throw CCTError.unableToResolveDependency("Cannot resolve unregistered type: \(type)")
    }

    let component: CCTComponent = fromRegistry.components[componentKey]!
    var resolvedInstance = component.instance
    if resolvedInstance != nil {
        return resolvedInstance!
    }

    let initializer: CCTComponentFactory? = component.constructionInfo
    if initializer == nil {
        throw CCTError.unableToResolveDependency("Cannot find construction info for type: \(type)")
    }

    resolvedInstance = try resolveDependencies(
        component: component, fromRegistry: fromRegistry, andConstruct: initializer!)

    component.instance = resolvedInstance
    return resolvedInstance
}

func resolveDependencies(component: CCTComponent,
                         fromRegistry: CCTRegistry,
                         andConstruct: CCTComponentFactory) throws -> Any? {

    let dependencies = component.dependencies
    if dependencies == nil || dependencies!.isEmpty {
        return andConstruct.create()
    }
    return try resolveConstructableDependencies(dependencies: dependencies!, fromRegistry: fromRegistry, andConstruct: andConstruct)
}

func resolveConstructableDependencies(dependencies: [Any.Type],
                                      fromRegistry: CCTRegistry,
                                      andConstruct: CCTComponentFactory) throws -> Any? {
    var depInstances: [Any] = []
    
    for dep in dependencies {
        do {
            let instance = try resolveComponent(type: dep, fromRegistry: fromRegistry)
            depInstances.append(instance!)
        } catch {
            throw CCTError.unableToResolveDependency("Failed to resolve depenency: \(dep)")
        }
    }

    return andConstruct.create(with: depInstances)
}

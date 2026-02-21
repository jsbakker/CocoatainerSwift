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
    let component = fromRegistry.getComponentRegistry(key: componentKey)

    let cachedInstance = component?.instance
    if cachedInstance != nil {
        return cachedInstance!
    }

    let initializer: CCTComponentFactory? = component?.constructionInfo
    if initializer == nil {
        throw CCTError.unableToResolveDependency("Cannot find construction info for type: \(type)")
    }

    let constructedInstance = try resolveDependencies(
        component: component!, fromRegistry: fromRegistry, andConstruct: initializer!)

    component?.instance = constructedInstance
    return constructedInstance
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
        let instance = try resolveComponent(type: dep, fromRegistry: fromRegistry)
        depInstances.append(instance!)
    }

    return andConstruct.create(with: depInstances)
}

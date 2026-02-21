//
//  CCTContainer.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

public class CCTContainer {
    private var model: CCTRegistry
    private var parent: CCTContainer?

    public init(parent: CCTContainer? = nil) {
        self.model = CCTRegistry()
        if parent != nil {
            self.addParent(parent!)
        }
    }

    deinit {
        self.parent = nil
    }

    public func addParent(_ parent: CCTContainer) {
        self.parent = parent
        self.model.addParent(parent.model)
    }

    public func start(autoResolve: Bool) throws {
        if autoResolve {
            try resolveAll()
        }
        self.model.traverseAndExecute { key, component in
            if component.instance == nil {
                return
            }
            let instance = component.instance!
            if let startable = instance as? CCTStartable {
                startable.start()
            }
        }
    }

    public func register(type: Any.Type, withInstance: Any) throws {

        try self.model.addComponent(type: type, instance: withInstance)
    }

    public func register(type: Any.Type, constructWith: CCTComponentFactory) throws {

        try self.registerDependencies(dependencies: [], forType: type, constructWith: constructWith)
    }

    public func register(type: Any.Type, dependentOn: [Any.Type], constructWith: CCTComponentFactory) throws {

        for dep in dependentOn {
            if dep == type {
                throw CCTError.unableToResolveDependency("Cannot register a dependency cycle for type: \(type)")
            }
        }
        try self.registerDependencies(dependencies: dependentOn, forType: type, constructWith: constructWith)
    }

    public func resolve<T>(_ type: T.Type) throws -> T {

        guard let instance: T = try self.resolveComponent(type: type) as? T else {
            throw CCTError.unableToResolveDependency("Could not convert the resolved type to: \(T.self)")
        }
        return instance
    }

    private func resolveComponent(type: Any.Type) throws -> Any? {

        do {
            let instance = try CocoatainerSwift.resolveComponent(type: type, fromRegistry: self.model)
            if instance != nil {
                return instance
            }
        } catch {
            if self.parent != nil {
                let instance = try self.parent?.resolveComponent(type: type)
                if instance != nil {
                    return instance
                }
            }
        }
        throw CCTError.unableToResolveDependency("Cannot resolve or create instance of type: \(type)")
    }

    private func registerDependencies(dependencies: [Any.Type],
                                      forType: Any.Type,
                                      constructWith: CCTComponentFactory) throws {

        try self.model.addComponent(type: forType, dependencies: dependencies, initWithDepsArray: true, constructionInfo: constructWith)
    }

    private func resolveAll() throws {
        try self.model.traverseAndExecute { key, component in
            if component.instance == nil {
                do {
                    let _ = try self.resolveComponent(type: component.typeInfo!)
                } catch {
                    throw CCTError.unableToResolveDependency(
                        "Error when traversing dependencies on type: \(component.typeInfo!.self)")
                }
            }
        }
    }
}

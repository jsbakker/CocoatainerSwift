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

/// Create an object of this class to register and resolve types that live within its scope.
/// Containers can be nested to support multiple scopes.
public class CCTContainer {
    private var model: CCTRegistry
    private var parent: CCTContainer?

    /// Initialize the container.
    /// - Parameters:
    ///     - parent: Set another container as a parent scope (optional)
    public init(parent: CCTContainer? = nil) {
        self.model = CCTRegistry()
        if parent != nil {
            self.setParent(parent!)
        }
    }

    deinit {
        self.parent = nil
    }

    /// Set another container as a parent scope (optional). A child scope can resolve objects
    /// from its parent, but parent cannot from child, since a child scope is shorter lived than
    /// its parent's scope.
    /// - Parameters:
    ///     - parent: The parent container.
    public func setParent(_ parent: CCTContainer) {
        self.parent = parent
        self.model.setParent(parent.model)
    }

    /// Call the start() function on all resolved objects in the container that implement CCTStartable.
    /// - Parameters:
    ///     - autoResolve: Automatically ensure that all objects registered in the container are resolved first.
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

    /// Register a type into the container (to an existing object instance).
    /// The instance will be cached so it can be requested at a later time.
    /// - Parameters:
    ///     - type: The class or protocol to register, and therefore later resolve. Use `typename.self`.
    ///     - withInstance: An existing, instantiated object representing the type being registered. Supports inheritance.
    public func register(type: Any.Type, withInstance: Any) throws {

        try self.model.addComponent(type: type, instance: withInstance)
    }

    /// Register a type into the container, so it can be constructed when it is requested at a later time.
    /// - Parameters:
    ///     - type: The class or protocol to register, and therefore later resolve. Use `typename.self`.
    ///     - constructWith: Provide a closure, later used to construct the type.
    public func register(type: Any.Type, constructWith: CCTComponentFactory) throws {

        try self.registerDependencies(dependencies: [], forType: type, constructWith: constructWith)
    }

    /// Register a type into the container, so it can be constructed when it is requested at a later time.
    /// - Parameters:
    ///     - type: The class or protocol to register, and therefore later resolve. Use `typename.self`.
    ///     - dependentOn: An array of types that the later resolved object will be dependent on for construction.
    ///     - constructWith: Provide a `.withArgs({deps in` closure, later used to construct the type.
    public func register(type: Any.Type, dependentOn: [Any.Type], constructWith: CCTComponentFactory) throws {

        for dep in dependentOn {
            if dep == type {
                throw CCTError.unableToResolveDependency("Cannot register a dependency cycle for type: \(type)")
            }
        }
        try self.registerDependencies(dependencies: dependentOn, forType: type, constructWith: constructWith)
    }

    /// Resolve the requested type from the container (or its parent or ancestor).
    /// The object will be constructed if a cached version is not present.
    /// - Parameters:
    ///     - type: The protocol or class to resolve. Use `typename.self` to specify.
    /// - Returns: An object of that type or the registered class that implements/inherits the requested type.
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

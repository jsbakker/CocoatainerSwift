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
        self.parent = parent
    }

    deinit {
        self.parent = nil
    }

    public func addParent(_ parent: CCTContainer) {
        self.parent = parent
        self.model.addParent(parent.model)
    }

    public func start(autoResolve: Bool) {
        if autoResolve {
            resolveAll()
        }
        self.model.traverseAndExecute { component in
            if component.instance == nil {
                return
            }
            let instance = component.instance!
            if let startable = instance as? CCTStartable {
                startable.start()
            }
        }
    }

    public func registerComponent(abstraction: Any.Type, withInstance: Any) {

        self.model.addComponent(abstraction: abstraction, instance: withInstance)
    }

    public func registerComponent(abstraction: Any.Type, initsWith: CCTComponentFactory) {

        self.registerDependencies(dependencies: [], forAbstraction: abstraction, withInitializer: initsWith)
    }

    public func registerComponent(abstraction: Any.Type, dependentOn: [Any.Type], initsWith: CCTComponentFactory) {

        self.registerDependencies(dependencies: dependentOn, forAbstraction: abstraction, withInitializer: initsWith)
    }

//    public func resolveG1<T>(type: T) -> T {
//        guard let result = self.resolveComponent(abstraction: T.self) as? T else {
//            fatalError("Could not resolve type: \(T.self)")
//        }
//        return result
//    }

    public func resolveComponent(abstraction: Any.Type) throws -> Any? {

        var instance = try CocoatainerSwift.resolveComponent(abstraction: abstraction, fromRegistry: model)
        if instance != nil {
            return instance
        }

        if parent != nil {
            instance = try self.parent?.resolveComponent(abstraction: abstraction)
        }

        if instance != nil {
            return instance
        }

        // TODO: Throw
        return nil
    }

    private func registerDependencies(dependencies: [Any.Type],
                                      forAbstraction: Any.Type,
                                      withInitializer: CCTComponentFactory) {

        for dep in dependencies {
            if dep == forAbstraction {
                // TODO: throw
            }
        }

        self.model.addComponent(abstraction: forAbstraction, dependencies: dependencies, initWithDepsArray: true, constructionInfo: withInitializer)
    }

    private func resolveAll() {
        self.model.traverseAndExecute { component in
            if component.instance == nil {
                do {
                    let _ = try self.resolveComponent(abstraction: component.abstraction!)
                } catch {
                    //
                }
            }
        }
    }
}

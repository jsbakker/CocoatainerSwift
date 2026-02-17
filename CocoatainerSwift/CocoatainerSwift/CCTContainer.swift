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

    public func registerComponent(type: Any.Type, withInstance: Any) {

        self.model.addComponent(type: type, instance: withInstance)
    }

    public func registerComponent(type: Any.Type, constructWith: CCTComponentFactory) {

        self.registerDependencies(dependencies: [], forType: type, constructWith: constructWith)
    }

    public func registerComponent(type: Any.Type, dependentOn: [Any.Type], constructWith: CCTComponentFactory) {

        self.registerDependencies(dependencies: dependentOn, forType: type, constructWith: constructWith)
    }

//    public func resolveG1<T>(type: T) -> T {
//        guard let result = self.resolveComponent(abstraction: T.self) as? T else {
//            fatalError("Could not resolve type: \(T.self)")
//        }
//        return result
//    }

    public func resolveComponent(type: Any.Type) throws -> Any? {

        var instance = try CocoatainerSwift.resolveComponent(type: type, fromRegistry: model)
        if instance != nil {
            return instance
        }

        if parent != nil {
            instance = try self.parent?.resolveComponent(type: type)
        }

        if instance != nil {
            return instance
        }

        // TODO: Throw
        return nil
    }

    private func registerDependencies(dependencies: [Any.Type],
                                      forType: Any.Type,
                                      constructWith: CCTComponentFactory) {

        for dep in dependencies {
            if dep == forType {
                // TODO: throw
            }
        }

        self.model.addComponent(type: forType, dependencies: dependencies, initWithDepsArray: true, constructionInfo: constructWith)
    }

    private func resolveAll() {
        self.model.traverseAndExecute { component in
            if component.instance == nil {
                do {
                    let _ = try self.resolveComponent(type: component.typeInfo!)
                } catch {
                    //
                }
            }
        }
    }
}

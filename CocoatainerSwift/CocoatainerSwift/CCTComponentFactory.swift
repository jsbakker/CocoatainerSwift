//
//  CCTComponentFactory.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

// Used for constructor blocks
public typealias InitializerWithArgs = ([Any]) -> Any
public typealias InitializerNoArgs = () -> Any

/// Helper closures for providing arguments to call constructors with no args or argument array.
public enum CCTComponentFactory {
    /// Define closure `constructsWith: .withArgs { deps in ... }`
    case withArgs(InitializerWithArgs)
    /// Define closure `constructsWith: .noArgs { ... }`
    case noArgs(InitializerNoArgs)

    // Helper method inside the enum to handle the execution logic
    public func create(with arguments: [Any] = []) -> Any {
        switch self {
        case .withArgs(let closure):
            return closure(arguments)
        case .noArgs(let closure):
            return closure()
        }
    }
}

//
//  CCTStartable.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

/// Implement your type as startable if you want it to run and live in
/// the container without having to "resolve" it for the user code.
public protocol CCTStartable {
    /// If a registered type implements this, there is an option to
    /// "start" it after the object has been created.
    func start()
}


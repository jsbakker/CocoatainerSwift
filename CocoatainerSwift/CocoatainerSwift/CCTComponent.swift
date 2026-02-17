//
//  CCTComponent.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

class CCTComponent {

    init() {
        self.typeInfo = nil
        self.dependencies = nil
        self.initWithDepsArray = false
        self.constructionInfo = nil
        self.instance = nil
    }

    deinit {
        self.typeInfo = nil
        self.dependencies = nil
        self.initWithDepsArray = false
        self.constructionInfo = nil
        self.instance = nil
    }

    var typeInfo: Any.Type?
    var dependencies: [Any.Type]?
    var initWithDepsArray: Bool
    var constructionInfo: CCTComponentFactory?
    var instance: Any?
}

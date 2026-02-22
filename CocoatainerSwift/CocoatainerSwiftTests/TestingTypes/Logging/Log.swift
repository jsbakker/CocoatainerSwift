//
//  Log.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

protocol Log {
    func write(_ message: String)
    func getLines() -> [String]
    func clear()
}

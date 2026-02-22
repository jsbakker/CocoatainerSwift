//
//  ArrayLog.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

class ArrayLog: Log {
    private var lines: [String] = []

    func write(_ message: String) {
        lines.append(message)
    }

    func getLines() -> [String] {
        return lines
    }

    func clear() {
        lines.removeAll()
    }
}

//
//  StartupLogger.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-19.
//
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation
import CocoatainerSwift

protocol UsesLogA {
}

protocol UsesLogB {
}

class DescopeLogger {
    var log: Log

    init(log: Log) {
        self.log = log
    }
}

class DescopeLoggerA: DescopeLogger, UsesLogA {
    deinit {
        log.write("Deinit: \(DescopeLoggerA.self)")
    }
}

class DescopeLoggerB: DescopeLogger, UsesLogB {
    deinit {
        log.write("Deinit: \(DescopeLoggerB.self)")
    }
}

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

class StartupLogger: CCTStartable {
    var log: Log

    init(log: Log) {
        self.log = log
    }

    func start() {
        log.write("Starting: \(StartupLogger.self)")
    }
}

class StartupLoggerA: StartupLogger {
}

class StartupLoggerB: StartupLogger {
}

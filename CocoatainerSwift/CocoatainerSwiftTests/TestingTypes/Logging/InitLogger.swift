//
//  InitLogger.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-20.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

class InitLogger {
    var log: Log

    init(log: Log) {
        self.log = log
        log.write("init: \(type(of: self))")
    }
}

class InitLoggerA: InitLogger {
}

class InitLoggerB: InitLogger {
}

class InitLoggerC: InitLogger {
}

class InitLoggerX: InitLogger {
}

class InitLoggerY: InitLogger {
}

class InitLoggerZ: InitLogger {
}

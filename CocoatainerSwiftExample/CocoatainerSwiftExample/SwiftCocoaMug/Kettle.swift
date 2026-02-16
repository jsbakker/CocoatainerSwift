//
//  Kettle.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import CocoatainerSwift

public class Kettle: HotWaterSource, CCTStartable
{
    let FullCup = 250

    deinit {
        print("This water got cold and looks old. I will dump it out.")
    }

    public func start() {
        heat()
    }

    public func heat() {
        print("Boiling water to 100 degrees C.")
    }

    public func pourCup() -> Int {
        print("Pouring a cup of hot water.")
        return FullCup
    }
}

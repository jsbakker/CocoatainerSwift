//
//  CocoaPowder.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import CocoatainerSwift

public class CocoaPowder: Mixture, CCTStartable
{
    var topping: Topping

    public init(topping: Topping)
    {
        self.topping = topping
    }

    deinit
    {
        print("This cocoa powder has coagulated at the bottom.")
    }

    public func start()
    {
        print("Creating \(self) mix with \(topping.name()) topping.")
    }

    public func shovel()
    {
        print("Shovel three tablespoons of mixture.")
    }
}

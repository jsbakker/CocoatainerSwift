//
//  CocoaMug.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import CocoatainerSwift

public class CocoaMug: LiquidVessel, CCTStartable
{
    var source: HotWaterSource
    var mixture: Mixture

    var millilitres: Int

    public init(source: HotWaterSource, mixture: Mixture)
    {
        self.source = source
        self.mixture = mixture
        self.millilitres = 0
    }

    deinit
    {
        print("Someone left this \(millilitres) ml full mug here. I will just pour it out.")
    }

    public func start()
    {
        fill()
    }

    public func fill()
    {
        mixture.shovel()
        millilitres = source.pourCup()
        print("Mug is filled to \(millilitres) ml of hot Cocoa.")
    }

    public func drink(amount: Int)
    {
        print("Drinking \(amount) ml from the mug.")
        millilitres -= amount
    }

    public func checkAmount()
    {
        print("There is \(millilitres) ml of cocoa left in the mug.")
    }
}

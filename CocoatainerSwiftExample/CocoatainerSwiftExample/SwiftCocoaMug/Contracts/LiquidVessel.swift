//
//  LiquidVessel.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

public protocol LiquidVessel
{
    func fill()
    func drink(amount: Int)
    func checkAmount()
}

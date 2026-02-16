//
//  Marshmallow.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation

public class Marshmallow: Topping
{
    deinit {
        print("This marshmallow is so soggy that it has nearly turned into liquid.")
    }

    public func name() -> String {
        return "\(self)"
    }
}

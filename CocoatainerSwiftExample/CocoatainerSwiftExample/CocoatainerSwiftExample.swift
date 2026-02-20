//
//  CocoatainerSwiftExample.swift
//  CocoatainerSwift
//
//  Created by Jeffrey Bakker on 2026-02-15.
//
//  Distributed under the MIT License.
//  See accompanying file LICENSE.md or copy at
//  http://opensource.org/licenses/MIT

import Foundation
import CocoatainerSwift

class CocoatainerSwiftExample {

    // Register abtractions (protocols) by the concrete types which implement
    // them, so when we want an abstraction, we can ask for it without requiring
    // knowlege of the implementer or how to construct one.
    static func CocoatainerExample() {

        let container = CCTContainer()

        // Protocols
        let phws = HotWaterSource.self
        let ptop = Topping.self
        let pmix = Mixture.self
        let pmug = LiquidVessel.self

        do {
            try container.register(type: phws, withInstance: Kettle())
            try container.register(type: ptop, withInstance: Marshmallow())

            // TODO: Idea
//            container.registerComponent(abstraction: pmix, implementation: Mixture.self)

            let mixDeps: [Any.Type] = [ptop]
            try container.register(
                type: pmix,
                dependentOn: mixDeps,
                constructWith: .withArgs({depsArgs in
                    let topping = depsArgs[0] as! Topping
                    return CocoaPowder(topping: topping)
                }))

            let mugDeps: [Any.Type] = [phws, pmix]
            try container.register(
                type: pmug,
                dependentOn: mugDeps,
                constructWith: .withArgs({depsArgs in
                    let source = depsArgs[0] as! HotWaterSource
                    let mixture = depsArgs[1] as! Mixture
                    return CocoaMug(source: source, mixture: mixture)
                }))

            try container.start(autoResolve: true)

            let mug = try container.resolve(pmug)

            mug.drink(amount: 20)
            mug.checkAmount()
            mug.drink(amount: 30)
            mug.checkAmount()
        } catch {
            print("There was an error resolving the mug.")
        }
    }
}

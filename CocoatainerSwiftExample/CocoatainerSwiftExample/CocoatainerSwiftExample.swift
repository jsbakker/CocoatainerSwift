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

    static func CocoatainerExample() {

        let container = CCTContainer()

        let phws = HotWaterSource.Protocol.self
        let ptop = Topping.Protocol.self
        let pmix = Mixture.Protocol.self
        let pmug = LiquidVessel.Protocol.self

        do {
            try container.registerComponent(type: phws, withInstance: Kettle())
            try container.registerComponent(type: ptop, withInstance: Marshmallow())

            // TODO: Idea
//            container.registerComponent(abstraction: pmix, implementation: Mixture.self, dependentOn: <#T##[any Any.Type]#>, constructWith: <#T##CCTComponentFactory#>)

            let mixDeps: [Any.Type] = [ptop]
            try container.registerComponent(type: pmix, dependentOn: mixDeps, constructWith: .withArgs({depsArgs in
                let topping = depsArgs[0] as! Topping
                return CocoaPowder(topping: topping)
            }))

            // TODO: Generics
    //        let powder: Mixture = container.resolveG1(type: Mixture.Protocol.self) as! Mixture
    //        print(">> mixture as powder: \(powder)")

            let mugDeps: [Any.Type] = [phws, pmix]
            try container.registerComponent(type: pmug, dependentOn: mugDeps, constructWith: .withArgs({depsArgs in
                let source = depsArgs[0] as! HotWaterSource
                let mixture = depsArgs[1] as! Mixture
                return CocoaMug(source: source, mixture: mixture)
            }))

            try container.start(autoResolve: true)

            let mug: LiquidVessel = try container.resolveComponent(type: pmug) as! LiquidVessel

            mug.drink(amount: 20)
            mug.checkAmount()
            mug.drink(amount: 30)
            mug.checkAmount()
        } catch {
            print("There was an error resolving the mug.")
        }
    }
}


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

        container.registerComponent(abstraction: phws, withInstance: Kettle())
        container.registerComponent(abstraction: ptop, withInstance: Marshmallow())

        // Idea
//        container.registerComponent(abstraction: pmix, implementation: Mixture.self, dependentOn: <#T##[any Any.Type]#>, initsWith: <#T##CCTComponentFactory#>)

        let mixDeps: [Any.Type] = [ptop]
        container.registerComponent(abstraction: pmix, dependentOn: mixDeps, initsWith: .withArgs({myArgs in
            let topping = myArgs[0] as! Topping
            return CocoaPowder(topping: topping)
        }))

        // TODO: Generics
//        let powder: Mixture = container.resolveG1(type: Mixture.Protocol.self) as! Mixture
//        print(">> mixture as powder: \(powder)")

        let mugDeps: [Any.Type] = [phws, pmix]
        container.registerComponent(abstraction: pmug, dependentOn: mugDeps, initsWith: .withArgs({myArgs in
            let source = myArgs[0] as! HotWaterSource
            let mixture = myArgs[1] as! Mixture
            return CocoaMug(source: source, mixture: mixture)
        }))

        container.start(autoResolve: true)

        let mug: LiquidVessel =
            container.resolveComponent(abstraction: pmug) as! LiquidVessel

        mug.drink(amount: 20)
        mug.checkAmount()
        mug.drink(amount: 30)
        mug.checkAmount()
    }
}


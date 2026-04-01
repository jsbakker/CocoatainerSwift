![Swift6](https://img.shields.io/badge/swift-6-blue.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

# CocoatainerSwift #

Welcome to the CocoatainerSwift project. This project is aimed at providing Swift developers with a framework for [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) / [Inversion of Control](http://en.wikipedia.org/wiki/Inversion_of_control). This is a port of the Objective-C [Cocoatainer](https://bitbucket.org/staeryatz/cocoatainer) project.
 
Why use an IoC container? Containers force you to invest time and thought into explicitly defining the different lifetime scopes of your software solution.

The Factory Pattern is great for helping enforce Dependency Inversion and assumes the responsibility of object creation, but IoC takes it a step further by creating, configuring and managing scopes in a more controlled and organized manner.

### Features ###
CocoatainerSwift provides an IoC container using constructor injection (as opposed to property injection) and does not require your classes to be written in a specific way for its dependencies to be injected. CocoataineSwift supports registering types either by abstract (protocol) or by concrete type (class). The container supports the following features:

* Adding components by pre-allocated instance
* Adding components by construction code block (via closure) with dependencies
* Multiple dependencies per component, auto-resolving when needed
* Nesting of dependencies, auto-resolving when needed
* Nesting of containers (with auto-resolving dependencies from parent)
* Startable (with option of auto-resolution of objects not referenced outside the container, i.e. object lives solely in the container)
* Error checking on registration (throws), to help prevent logical errors after resolution
* API documentation

The CocoatainerSwift framework code is covered by several dozen unit tests around the above scenarios. The workspace also contains examples projects for using it from Swift.

### Add CocoatainerSwift ###
You can add CocoatainerSwift as package to your Swift project. Open your project in Xcode, and from the menu bar, choose File, "Add Package Dependencies...". Enter "https://github.com/jsbakker/CocoatainerSwift" in the Package URL / Search field. Select the project you want to add it to, and click Add Package. It should automatically be linked against from the default target of the project.


### CocoaMug Example ###

If you wanted some hot cocoa, first you'd need [some sort of mug](CocoatainerSwiftExample/CocoatainerSwiftExample/SwiftCocoaMug/CocoaMug.swift) to put it in, get hot water from [somewhere](CocoatainerSwiftExample/CocoatainerSwiftExample/SwiftCocoaMug/Kettle.swift), and of course some [mixture](CocoatainerSwiftExample/CocoatainerSwiftExample/SwiftCocoaMug/CocoaPowder.swift), which may also contain [toppings](CocoatainerSwiftExample/CocoatainerSwiftExample/SwiftCocoaMug/Marshmallow.swift). You might not know specifically how or where to get these things, but you know what it takes to make hot cocoa. Maybe it would play out like this.

```swift
    // Register abtractions (protocols) by the concrete types which implement
    // them, so when we want an abstraction, we can ask for it without requiring
    // knowlege of the implementer or how to construct one.
    let container = CCTContainer()

    // Protocols
    let phws = HotWaterSource.self
    let ptop = Topping.self
    let pmix = Mixture.self
    let pmug = LiquidVessel.self

    do {
        try container.register(type: phws, withInstance: Kettle())
        try container.register(type: ptop, withInstance: Marshmallow())

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
    }
```

The above might happen inside of some configuration module, and the below could be happening in some client code.
```swift
    do {
        let mug = try container.resolve(pmug)

        // Pass mug to a CocoaDrinker
    }
...

    // Later on inside of CocoaDrinker
    mug.drink(amount: 20)
    mug.checkAmount()
    mug.drink(amount: 30)
    mug.checkAmount()
```

When the above code is run, its output is like so
```
Boiling water to 100 degrees C.
Shovel three tablespoons of mixture.
Pouring a cup of hot water.
Mug is filled to 250 ml of hot Cocoa.
Creating CocoatainerSwiftExample.CocoaPowder mix with CocoatainerSwiftExample.Marshmallow topping.
Drinking 20 ml from the mug.
There is 230 ml of cocoa left in the mug.
Drinking 30 ml from the mug.
There is 200 ml of cocoa left in the mug.
Someone left this 200 ml full mug here. I will just pour it out.
This water got cold and looks old. I will dump it out.
This cocoa powder has coagulated at the bottom.
This marshmallow is so soggy that it has nearly turned into liquid.
```
The above messages are printed at various times, e.g. via init(), deinit, start() and drink(). The order of the messages in this example give us insight into the lifecycle of the objects and order of operations in the container.

### Examples By the Block ###
To create a Cocoatainer container
```swift
let container = CCTContainer()
```

To register a class (concrete) with no dependencies to an initializer block
```swift
try container.register(
    type: MyClass.self,
    constructWith: .noArgs({
        return MyClass()
    }))
```

To do the above with 1 dependency it would look like
```swift
try container.register(
    type: ClassB.self,
    dependentOn: [ClassA.self],
    constructWith: .withArgs({depsArgs in
        let dep = depsArgs[0] as! ClassA
        return ClassB(depA: dep)
    }))
```

To register a pre-allocated instance of a class
```swift
try container.register(type: MyClass.self, withInstance: MyClass())

// OR

let instance: MyClass = MyClass()
try container.register(type: MyClass.self, withInstance: instance)
```

To **resolve** an instance of a registered class
```swift
let instance = try config.resolve(ClassB.self)
```

To register a protocol (abstract) with 2 dependencies to an initializer block
```swift
let myDeps: [Any.Type] = [ProtocolA.self, ProtocolB.self]
try container.register(
    type: ProtocolC.self,
    dependentOn: myDeps,
    constructWith: .withArgs({depsArgs in
        let depA = depsArgs[0] as! ProtocolA
        let depB = depsArgs[1] as! ProtocolB
        return ConcreteImplementsProtocolC(a: depA, b: debB)
    }))
```

To resolve a component by protocol
```swift
let concreteInstance = try config.resolve(MyProtocol.self)
```

This example below is container scope nesting. Note, that an inner (descendant) container can resolve objects from the outer (ancestor) containers, but the outer containers cannot resolve objects from the inner. This is because the outer scope is wider than inner scopes, so there is no guarantee the inner scope is active.
```swift
let outerScope = CCTContainer()

try outerScope.register(type: Log.self, withInstance: ArrayLog())
let log = try outerScope.resolve(Log.self)

autoreleasepool { // inner scope
    let innerScope = CCTContainer()
    innerScope.setParent(outerScope)

    do {
        try innerScope.register(
            type: UsesLogA.self,
            dependentOn: [Log.self],
            constructWith: .withArgs({deps in
                let dep: Log = deps[0] as! Log
                return DescopeLoggerA(log: dep)
            }))

        let testObject = try innerScope.resolve(UsesLogA.self)
        #expect(testObject is DescopeLoggerA)
        #expect(log.getLines().count == 0)
    } catch {
        Issue.record(error)
    }
} // end of inner scope

// DescopeLoggerA will scope out and print a dealloc message here, while Log is still in scope
```

### Getting Familiar ###

Before using Cocoatainer in your own project, you may want to familiarize yourself with the framework. The following will help getting the Cocoatainer test harness and example code running.

* Download the repo
* In the root folder, open the CocoatainerSwift.xcworkspace file in XCode.
* Under the CocoatainerExample project, the example code is called in the main.m file. Running it will print to the Console. Look at the CocoaMug example for practical uses of the container.
* Under the CocoatainerSwift project, in the CocoatainerSwiftTests folder there are several files, each containing several unit tests on the container. Many of the types are only setup for the purpose of testing the container, and may not be setup with the best practices in mind.

### License ###

Copyright (C)2015-2026 Jeffrey Bakker. All rights reserved.
Released under the MIT license (see LICENSE.md for full text).

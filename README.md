# CocoatainerSwift #

Welcome to the CocoatainerSwift project. This project is aimed at providing Swift developers with a framework for [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) / [Inversion of Control](http://en.wikipedia.org/wiki/Inversion_of_control). This is a port of the Objective-C [Cocotainer](https://bitbucket.org/staeryatz/cocoatainer) project.
 
CocoatainerSwift provides an IoC container using constructor injection (as opposed to property injection) and does not require your classes to be written in a specific way for its dependencies to be injected. CocoataineSwift supports registering components either by abstract (protocol) or by concrete type (class). The container supports the following features:

* Adding components by pre-allocated instance
* Adding components by construction code block (via closure) with dependencies
* Multiple dependencies per component, auto-resolving when needed
* Nesting of dependencies, auto-resolving when needed
* Nesting of containers (with auto-resolving dependencies from parent)
* Startable (with option of auto-resolution of objects not referenced outside the container, i.e. object lives solely in the container)
* TODO:Port Error checking on registration (throws), to help prevent logical errors after resolution
* TODO:Port API docs via XCode Quick Help tab

TODO:Port The Cocoatainer framework code is covered by several dozen unit tests around the above scenarios. The workspace also contains examples projects for using it from Swift.

### CocoaMug Example ###

If you wanted some hot cocoa, first you'd need [some sort of mug](https://foo) to put it in, get hot water from [somewhere](https://foo), and of course some [mixture](https://foo), which may also contain [toppings](https://foo). You might not know specifically how or where to get these things, but you know what it takes to make hot cocoa. Maybe it would play out like this.

```swift
    let container = CCTContainer()

    let phws = HotWaterSource.Protocol.self
    let ptop = Topping.Protocol.self
    let pmix = Mixture.Protocol.self
    let pmug = LiquidVessel.Protocol.self

    container.registerComponent(abstraction: phws, withInstance: Kettle())
    container.registerComponent(abstraction: ptop, withInstance: Marshmallow())

    let mixDeps: [Any.Type] = [ptop]
    container.registerComponent(abstraction: pmix, dependentOn: mixDeps, initsWith: .withArgs({myArgs in
        let topping = myArgs[0] as! Topping
        return CocoaPowder(topping: topping)
    }))

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
```
The above might happen inside of some configuration module, and the below could be happening in some client code.
```swift
    let mug: LiquideVessel = config.resolveComponent(abstraction: LiquidVessel.Protocol.self) as! LiquidVessel

    // Pass mug to a CocoaDrinker

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
```
TODO:Port to Swift
```

### Getting Familiar ###

Before using Cocoatainer in your own project, you may want to familiarize yourself with the framework. The following will help getting the Cocoatainer test harness and example code running.

* Download the repo
* In the root folder, open the CocoatainerSwift.xcworkspace file in XCode.
* Under the CocoatainerExample project, the example code is called in the main.m file. Running it will print to the Console. Look at the CocoaMug example for practical uses of the container.
* TODO:Port Under the CocoatainerSwift project, in the CocoatainerTests folder there are several files, each containing several unit tests on the container. Many of the types are only setup for the purpose of testing the container, and may not be setup with the best practices in mind.

### License ###

Copyright (C)2015-2026 Jeffrey Bakker. All rights reserved.  
Released under the MIT license (see LICENSE.md for full text).

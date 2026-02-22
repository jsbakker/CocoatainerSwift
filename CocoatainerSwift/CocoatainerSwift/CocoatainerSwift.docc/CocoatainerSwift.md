# ``CocoatainerSwift``

This framework provides Swift developers with a container for [Dependency Injection](http://en.wikipedia.org/wiki/Dependency_injection) / [Inversion of Control](http://en.wikipedia.org/wiki/Inversion_of_control). This is a port of the Objective-C [Cocoatainer](https://bitbucket.org/staeryatz/cocoatainer) project.

Why use an IoC container? Containers force you to invest time and thought into explicitly defining the different lifetime scopes of your software solution.

The Factory Pattern is great for helping enforce Dependency Inversion and assumes the responsibility of object creation, but IoC takes it a step further by creating, configuring and managing scopes in a more controlled and organized manner.

## Features

CocoatainerSwift provides an IoC container using constructor injection (as opposed to property injection) and does not require your classes to be modified or written specifically for its dependencies to be injected. CocoataineSwift supports registering components either by abstract (protocol) or by concrete type (class). The container supports the following features:

* Adding components by pre-allocated instance
* Adding components by construction code block (via closure) with dependencies
* Multiple dependencies per component, auto-resolving when needed
* Nesting of dependencies, auto-resolving when needed
* Nesting of containers (with auto-resolving dependencies from parent)
* Startable (with option of auto-resolution of objects not referenced outside the container, i.e. object lives solely in the container)
* Error checking on registration (throws), to help prevent logical errors after resolution
* API documentation

The CocoatainerSwift framework code is covered by several dozen unit tests around the above scenarios. The workspace also contains examples projects for using it from Swift.


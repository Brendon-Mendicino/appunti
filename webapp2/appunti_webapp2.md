# Kotlin
## Types
All types are references types in Kotlin, they will be optimized later by the compiler if possible, this removes the problems that Java was carrying, like the difference between boxed and unboxed type`int` vs `Integer`, ...).

## Null Safety
Java is affected by Null values, they are part of the language to signal the abcence of a value, Kotlin improves on this by embedding in the language the possiblity for a type to be Null directly inside the type. Kotlin has two types of values (the third one will be discussed later), **non-null-types** and **null-types** obtained by appending a `?` at the end of the value. Kotlin puts the type `Any` at the top of the class hierarchy (every class inheriths Any), like `Object` in Java, while at the bottom of the hierarchy it puts `Nothing` (every class is inherited by Nothing). As we said earlier every type has it's nullable counter-part, in fact `Any?` and `Nothing?` are both types, the `null` value is the only instance of the `Nothing?` type. On the other hand `Nothing` contains no possible value, using the kind of abstraction the compiler can do assumption based on the code for optimizations or for checking, e.g. an exception as no possible value, we use the `Nothing` type to mark this return value, or if the main contains an infinite loop and that function is never supposed to return, the return value can specified to be `Nothing`. The `Noghtin` type is like the concept of 0 in math.

## Using nullable types
- **safe-call operator** (`?.`): call the method/paramter if the object is not null
- **elvis operator** (`?:`): returns the value on the right if the object on the left is null
- **non-null operator** (`!!`): move the null-check at runtime

```kotlin
var a: String = "abc"
var b: String? = "abc"
b = null
var len: Int? = b?.lenght
```
In Kotlin everything has a return value, `void` is replaced with `Unit`, which is a class and the only possible instance of that class. Like Rust also in Kotlin every scope has a return value, e.g. `val a = if (0 == 0) \{ 1 \} else { 2 }`, in this case `a` will have value of 1.

Kotlin assumes that nothing is inheritalbe unless it's explicit, this avoid many of the problem on inheritance. In Kotlin there are two kind of attributes, variables (`var`) which are values that can change, values (`val`) which means that the value is not reassignable, and not immutable.

Functions types: in Kotlin the type of a function is defnied as the set of types of the paramters inside parethesis and the return value after the arrow (`->`): `(String, Int) -> Unit`. To declare a function we use the keyword `fun`, to assign a function to a variable we use the (`::`) before its name, `val a: (String) -> Unit = ::greet`. This allows function in kotlin to be: **higher order functions** and **first class citizens**.

## Classes
Classes have a default constructor defined with parenthesis after the name of the class, the `init` scope is run after the constructor is called, moreover secondory constructors can be defined with the `constructor` keyword, in the end they must call the primary constructor to build the object.

Properties of a class can have the `set()` and `get()` methods, this are methods which allows to read and write properties of a class, also by adding additional logic, this is done to render our programs more readable.

## Delegates
Delegates are useful to have properties provided by somebody else, they can be used with the keyword `by`.
- One of these properties can be Lazy, where the initialization is delegated to the class Lazy, this is useful when a property creation is very expensive and very rare in our application.
- by Observable, the value can be subscribed by a third-party, invokes a listener when the property changes.
- by Vetoable, can observe the change before the change is happened, we can e.g. allow or block the operation based on some conditions.
```kotlin
val lazyValue: String by lazy { 
  print("computed!")
  "Hello"
}

fun main() {
  println(lazyValue) // -> "computed!" + "Hello"
  prtinln(lazyValue) // -> "Hello"
}
```


## Equality
When are two objects are the same? Equality in logic has three properties:
- Reflexive (anything is equal to itself)
- Symmetry (if a = b then b = a)
- Transitivity (if a = b and b = c then a = c)
Kotlin by defautl will rely on the native equal (from Java) which means comparing the pointers of the object (Identy equality), and it is derived from the `Any?` class. This is difficult when dealing with subclasses, when is an object equal to another? The answer to this question is not immediate, it depends on the domain we are dealing with.

In Kotlin two when objects that are equal they need to have the same `hashCode()`, the opposite is not true.


## Comparing
We need to implement the `Comparable` interface for a class, it only contains a method called `compareTo(other: T): Int`, if the return value is positive this is bigger than the other, if negative then it's the opposite.

## Singletons
We can declare a singleton with the object keyword, instad of class. There is only one instance.
```kotlin
object MySingl {
  private var _counter = 0
  fun increament() { ++_counter }
  val counter = _counter
}

MySingl.increment()
println(MySingl.counter) // -> 1
MySingl.increment()
println(MySingl.counter) // -> 2
```


## Companion Object
Replaces the `static` keyword in java. This allows to have properties to be already initialized when calling an object, this will be an object that will be automatically instanciated at the program creation. Companion objects are not bound to a single instace of a class, it can accessed by globally by anyone.


## Extension Function
This are special funciton that can extend the methods of a class. This is just a syntactic sugar for the programmer, in the end it will be converted to just a function with the class as the first parameter.

```kotlin
fun <T> List<T>.second(): T? = if (this.size >= 2) this[1] else null

val list = listOf("one", "two", "three")
println(list.second()) // -> two
```


## Inheritance
Kotlin discourages the use of inhritance, in fact by default class cannot be extended. Inheritance breaks a lot of things. Other than that we also need to explicetly specify which methods can be ovverridden, using the `open` keyword. And in subclasses we need to use the `override` keyword to reimplement the method of a parent class.

```kotlin
open class Base(val p: Int) {
  open fun method1(): Int = p

  fun method2(): String = "Cannot be overridden"
}

class Derived(p: Int) : Base(p) {
  override fun method1(): Int = p * 2

  // I can't write this.
  // the method is interpreted as final (Java)
  //override fun method2(): String = ...
}
```


## Dataclass
Dataclasses are very useful, in many cases. It's a class with some restriction and some benefits.

**Restrition**:
- cannot be extended
- cannot be abstract
- cannot be sealed or inner

**Benefits**:
- implementation of: equals, hashCode, toString, copy (create a clone of existing object), component1(), ..., componentN()

The `componentX` allows to implement a destructuring operation. `data class Point(val x: Int, val y: Int); val (x, y) = Point(1, 2)`


## Enum
Enum is a way to create enumerations which allows to limit the possible alternatives. Enum classes can also store properties.

```kotlin
enum class HttpStatusCode(val value: Int) {
  OK(200), NotFound(404), ...
}
```

## Sealed Class
Like rust Enum types, it's algebreic sum type. This is possible because sealed classes can be extended only insid the same file. At compilation all possible subclasses will be known.

```kotlin
sealed class Result
data class Success(val data: List) : Result()
data class Failure(val error: Throwable?) : Result()

fun processResult(result: Result): List = when (result) {
  is Success -> result.data // I can treat `result` as `Success` class
  is Failure -> listOf()    // The same, but with `Failure`
}
```

```kotlin
sealed class Option<out T>
data class Some<out T>(val data: T) : Option<T>
object None : Option<Nothing>

...
```

## Generics
Following Java, generics are implemented as type erasure. Only during compilation generics are known, they are forgetten at run-time. Since java and kotlin have a reflection system, what the JMV will do is to convert the list of type `<T>` to a list of type `<\*>`, which is a list of anything.

We put restrictios using the `when` keyword

```kotlin
fun <T> sort(l: List<T>) where T: CharSequence, T: Comparable<T> { ... }
```

```kotlin
class Box<T>(val content: T)

val b1 = Box("test")
val b2 = Box(42)

val s: String = b1.content
val i: Int = b2.content
// val b = b1 is Box<Int>
// Cannot check for instance of erased type: Box<Int>
```

## Variance in generic
How is it possible to handle subclasses and supersclass of a generic type `T`? With generic we can use the concepts of **covariant** and **contravariant** types. Where **covarient** `<out T>` means that you can use subclasses of `T`, **contravariant** `<in T>` means that you can use superclasses of `T`.

```kotlin
interface Source<out T> {
  fn next(): T
}
```

```kotlin
interface Sink<in T> {
  fn put(t: T)
}
```

## Scoped functions
Extension function that can operate on generic types. Heavily used in Kotlin library "`let`, `run`, `apply`, `with`, `also`, ..." These are also called scoped funtion with receiver.


## Annotations
Annotations are a special kind of class (declared with the `class annotation` keyword), used to define some metadata associated with a function, class, parameter, etc. Annotations gives us a set of APIs for the reflection system to inspect the objects created by us.

Usage:
- Used to declare our intentions to other programmers that will read the code (e.g. `@Suppress`)
- Used to generate extra code at compile-time or at run-time

Annotation classes can be annotated as well. THere are few predifined.
- `@Target(vararg at: AnnotationTarget)`: domain to of our class were it can be applied
- `@Retention(ar: AnnotationRetention)`: the compiler will generate code from the annotation, but it will swallow it. It can be embedded in the byte code and then swallowed later. Or it can be craeted at run-time (using regflection).
- `@Repeatable`: annotation can be applied multiple times.
- `@MustBeDocumented`: 

In Kotlin to disambiguate some cases there is a special syntax
```kotlin
class Person(@get:GetterAnnotation val name: String)
class Person(@field:FieldAnnotation val name: String)
class Person(@param:ConstructorParamAnnotation val name: String)
```

### Processing Annotation at Runtime

Processing Annotation at runtime via reflection.
```kotlin
@Retention(RUNTIME)
@Target(FIELD)
annotation class RelevantField

data class SampleClass(var a: Int, @field:RelevantField var b: String)

fun getRelavnat(obj: Any): List<String> {
  return obj.javaClass
    .declaredFields
    .filter {
      it.isAnnotationPresent(RelevaltField::class.java)
        && (it.canAcess(obj) || it.trySetAccessible())
    }
    .map { "${it.name}: ${it.get(obj)}" }
}
```

***IMPORTANT!***: It's important to remember that annotations don't act any modificaions on the code by themselves, but other components will act on those elements with the presence of annotations.


# Web Applications Architecture

Relieable applications properties:

- Idempotence: a given block should not duplicate the effect or messages.
- Immutability: design our system in such a way that nothing in never overridden nor it is deleted. It we want to deleted something we add something that tells us what we want to delete (like Git versions).
- Location Independence: the behaviour of an application should not depend on where the application is located.
- Versioning: keep track of our application changes.

When building web applications there also many fallacies that are believed to be true, but they never are:

- The network is **reliable**
- **Latency** is zero
- **Bandwidth** is infinite
- The network is **secure**
- **Topology** does not change
- There is one **administrator**
- **Transport** cost is zero
- The network is **homogeneous**

To address unreliable network (API calls), implementing idempotent APIs helps us:

- REST based architectures
- POST associated an ID to a request

Nowadys web applications uses HTTP(S) methods to exchange data with their clients. Typycally web application are disgned in a way such that those clients can perform some business logic (The **Business Login** is how the information is managed by the application).

Usually the approach that we use is a *tier level*:

1. **Client tier** (Front-End): Usually a web-browser or mobile applicationa, which does HTTP(S) requests over the internet.
1. **Web Tier** (Back-End): Is in itself split in many tiers
  1. **Presentation Layer** (Public Part): exposed to the internet, handling messages (Request, Responses), forwarding them to the service layer. Informations exchanged are **DTO**s (Data Transfer Object), which is usually represented as a json object.
  1. **Service Layer**: can contact the data access layer, delegate part of its information to another server, e.g. for back payments we forward the traffic to another server (PayPal, ...).
  1. **Data Access Layer** (Private Part): where the mojority of things happen, inside the data is represented as **Domain Model**s which is how the data is represented internally, how the disgner has concieved that service.
1. **Data Tier** (Back-End): is where the data is stored and where the data constraints are checked.

Infomation exachanged:
(Public) DTOs: Data Transfer Objects, data trensfered to the internet, encoded in such a way that it's convenient to exchange, in modern systems the majority of data is transfered as json.

(Private) Domain Models: data kept internally, this is how the designer of the system interpreted how data should be handled and represented. This modularity allows for both Public and Private services to evolve separately from each other.

The Web Tiers should be designed in a stateless way. All that is manipulated is ephemeral, if a state must be present it should be by means of databaseses. In this way we can create many WebTier, load balancers can create how many of them as they want to distibute the traffic in the most appropriate way.

### Presentation Layer

Encodes/Decodes answers as they come, and checks their formal validity, if it accepts it forward the data to layer below.

### Service Layer

Implements the application business logic, defines the contract between the user and the application. Each requirement is mapped `1 to 1` to a method that can be accessed. Typically those methods are used in a transactional way, if one operation fails then it should be rolled back. It manipulates DTOs (usually a data class with fields for the different operations), and internally it converts them to an **Entity** representation. Services should not leak the internal details of how the data layer is composed.

### Domain Model

It represent domain concepts, it is suitable for the data representation in our data layer. If we use *MySql* the data representation will be different from a *MongoDB* data representation.

### Data Access Layer 

It is responsible for persisting Entities or Documents coming from the Service Layer. Typycally it consists of a single application (DMBS) which is able to execute commands.

### Data Tier

Consists of one or more database, which could also have different technologies between them.

## Request Journey

1. DNS request when a user contacts a URL, then I get an IP address
1. Usually the IP address I receive is one of a **Load Balancer**, after a policy I will get to one of many web app servers.
1. The request is analyzed by a web application
1. The web application directly contancs a database
1. The web application can also contact a cache for fast retreival
1. The web application can use **Job Queues**, which can be executed in a deferred later (The jobs can be deferred on a different server).
1. It can also use **Full Text Search**, to deal with the user **Natural Queries**.
1. After the request has been analyzed it can be forwared to a different service (like a payment service).
1. Some request can be forwarded to a **Data Warehouse**, where some analic can extracted from them, usually data is not stored immediatly but it is stored on a queue awaiting to be analyzed.
1. A copy of this data can also be shipped to some **Cloud Infrastructure**.
1. Some caching can be used to reduce latancy between Server and Client using a CDN netword (Conted Delivery Network).

## Distributed Systems

When we deal with distributed system we also need to deal with a **Distributed State**, every process can have their own copy of the data, in those cases it's very difficoult to have strong consistency, which means that states needs to be propagated to all the service, in those cases the is said to be **eventually consistent**, but in those transition is where the problems accurr. We can also have distributed transactions which introduce locking, which also introduce the problem of not being able to scale.


# Spring Boot

When Spring was first created, to model the set of actinos that were possible, object-oriented programming was used and a network of objects is used to solve this problem.

The framework allows us to create multiple components, that will be interconnected between each others, the engine will do the work to connect them accordingly, this is possible because when the framework loads classes it will inspect them and check if they contain annotations. The idea of linkable classes are called `Bean`s. Each `Bean` will be loaded by a `Container` or `ApplicationContext`, which will inspect them and act accordingly. This is why `Bean`s are the basic building block of a Spring application. Spring as soon as it recognice a `Bean` it can perform an operation called `Wireing`, which means to provide objects were they are needed, without specifing how to do it (it can also be done through a user-provided one). This also allows spring to compile the project into a unique big jar file called **uber-jar**. To create a Spring application we can use [Spring initializr](https://start.spring.io).

## Program structure

We create a class marked with `@SpringBootApplication`, if we mark methods with `@Bean` those methods will be responsible with creating objects.

One very difficoult task to do is to be able to build a complex architecture inside our program, the way spring does this is by using 3 fundamental ideas:
- **Inversion of Control**
- **Dependency Injection**
- **Aspect Oriented Programming**

The reason why these concepts are important, is to explain some problem that it's possible to encounter when designing relationships.

### Class Coupling:

It's when a class depends upon another, it means that one is thighty couplen to another, wich we cannot create those classes in a separate way, one depends upon the other.

We can use **Inversion of Control** to decouple classes dependencies. It abstrct the functionality of the depenging class.
```kotlin
interface Quest { fun embark() }

class RescueDamselQuest: Quest {
  override fun embark() {
    println("...")
  }
}

class BreaveKnight(private val quest: Quest) : Knight {
  override fun embarkOnQuest() {
    quest.embark()
  }
}
```

In this way a knight only knows that it has a quest, but the given details are not known, in this way we abstract the logic and the usage can be generic. In this way the `Quest` passed to the constructor can any kind of quest.

Who supplies the proper class that implements the interface? Here the **Dependecy Injection** comes to help to inject the dependency of a class that did IoC. For example in Spring there is an `ApplicationContext` that will automatically inject the dependencies, it sees that the a constructor needs a class that implements the `Quest` interface it will automatically recognice and insert the `RescueDamselQuest`. In Spring if we mark a class with `@Component` annotation it will be automatcally injected as a dependency.

If Spring we have more than one implementation it cannot infer which one to inject, we can solve this for example by annotating one of them as `@Primary`.


The **Aspect Oriented Programming** is a paradigm based on knowing that often our code is responsible to perform behavieours not strictly related to a specific class. A set of classes have a common problem, but in the way they are used need a common way of operating. We can take a set of common concerns and factorize them in a single place (*cross-cutting concerns*). For example in spring we can create `@Advice` which we can repeat code for other annotated pieces of code. This allows to preform actions *before* the invocation or after the *invocation*, e.g. in the case of **transactions** we want to start the commit before and commit after the invocation.

```kotlin
@Target(AnnotationTarget.FUNCTION)
annotation class Timed

@Aspect
@Component
class LogAspect { 
  @Around("@annotation(Timed)")
  fun log(joint: ProceedingJoinPoint): Any? {
    val start = System.nanoTime();
    try {
      return joint.proceed() // this represent in an abstract way the wrapping of the annotated method
    } finally {
      val end = System.nanoTime()
      println("Execution time: ${end-start} ns")
    }
  }
}
```

Whenever we will use the `@Timed` annotation, the additional code will be automatically generated and inserted dynamically.

```kotlin
@Component
class BraveKnight(private val quest: Quest) : Knight {
  
  @Timed
  override fun embarkOnQuest() {
    quest.embark()
  }
}
```

### Application Context

Where are the dependencies kept? The Main is responsible to instantiate the `ApplcationContext` where all the dependencies are stored. In Spring there are specialized classes that already implements the `@Component` annotation, those components are:

- `@Controller`/`@RestController`: Component that contains method to receive and return HTTP request/responses, every method annotated with `*Mapping("<url endpoint>")` is and endpoint of the application where the `*` is any of the HTTP methods.
- `@Service`: Components that contains the business logic of our application.
- `@Reposiotry`: typycally each repository correspond to each table in the database and it is the one responsible to perform operations on it.
- `@Configuration`: Component that contains method marked `@Bean` will trigger the creation of ther `Bean`s, which can be Autowired.

### Autoconfiguration

Many objects are instantiated when the program is run, for example in the default configuration there is a Tomcat server started by spring to create the server, which in spring is also a `@Component` and will be automatically created. Libraries can tell Spring to create other Components. This is possible because Spring has an `Autoconfiguration` where it will pick the default dependecy provided by the libraries, in case the user did not provide anything.

### Lifecycle

Every component has a specific lifetime, in spring we can specify how long a `Bean` should live, for example can bound a lifetime the life of the application or it can be bound to request, when the handling of request that `Bean` will be removed, we can bound the lifetime to a request from a spedcific user and it will maintain that `Bean` for 10 minutes if no new requests comes. We can specify the lifetime using the `@Scope` annotation (which if not specified is `Singleton` by default), we can also specify a method that will be called when the `Bean` is created or destroyed with `@Bean(initMethod="...", destroyMethod = "...")`.

### Autowiring by constructor

If more implementations to create a single `Bean` are provided we can attach each instance to a `Profile`, and in the configuration depeding on what we are doing (deployment, testing, ...), the appropriate `Bean` will be selected. We can also specify `@Qualifier("...")` on the autowired `Bean` thus allowing to inject 

### Application Properties

We can read the keys in the application properties file using `lateinit var` in case we need a configuration that we can change

```kotlin
@Value("\${server.port}")
lateinit var port: String
```




# Spring WebMVC

In Spring we already defined a layerd architecture, where a `Controller` is the component responsible for handling the HTTP connections, where that one will exchenge `DTO`s with a `Service`, which internally it will translate that `DTO` to suite the `DataSource` representation.

How the connections typycally happens in SpringMVC is that each request is handled by a single thread, if the number of request outwheights the number of threads they remain in the socket until some thread frees and collects the request, if no request is coming we still have all the available created threads on yield, which it still comsumes memory.

Spring supports two way to build web application (two ways of handling concurrency).

- **MVC**: create many threads to handle each request
- **WebFlux**: we can use asynchronous programming, by usgin all the available thread of a system we can split the load among them, instead of creating thousends of thread that will handle each request.

## Servlet (Java Enterprise Edition):

An abstraction to be the unit of computation (a class that handles a request and produces a response). Some more specific subclasses exist (`HTTPServlet`). The approach servlet took it's the same that SpringMVC uses: one-request-per-thread.

## Exposing a web resource

```kotlin
@Controller
class MainController {
  @GetMapping("/")
  fun index(): String {
    // home.html will be served to the user, under the `resource` folder
    return "home"
  }
}
```

The page is served tanks to a bean called `viewResolver`. This was relevant many years ago, now has been replace mostly by a `@RestController`, where we just provide some REST mappings.

All the parameter are automatically filled by Spring, like `@RequestParam`, this will be mapped the type given in the constructor of the controller method.

## Showing HTML content

The way we introduce variable into the HTML is by using **Thymeleaf**, which is a very prowerfull templating engine.

```kotlin
@Controller 
class HomeController {
  @GetMappign("/")
  fun home(): ModelAndView = ModelAndView("home", mapOf("date" to LocalDateTime.now()))
}
```

```html
<!DOCTYPE html> 
<html xmlns:th="http://www.thymeleaf.org">
<body>
  <h1>Home</h1>
  <p th:text="Now is ${date}"></p>
</body>
</html>
```

## Processing data

We can supply data to a controller using: `@RequestParam`, `@RequestBody`, `@PathVariable`. It's also possible to supply request parameters inside an object, Spring will automatically grab all the request parameters and assign them to the provided objects and the sub-objects in the function parameters.

## Validation

We use spring validation to validate request from the user, using `@Valid`, `@Min`, `@Max`, `@Size` on the fields of a kotlin data class, this allows for an easy validation of the user requests.

```kotlin
data class ReqDTO(
  @field:Size(max = 255)
  @field:NotBlank
  val test: String,
  @field:Valid
  val sub: SubReqDTO,
)

data class SubReqDTO(
  @field:Size(max = 255)
  @field:NotBlank
  val sub: String,
)
```


# Service Layer

The service layer is right below the controllers, it will accept the request and exchange data with the data layer.

## DTOs (Data Transfer Objects)

DTOs are the objects that the server exchanges with the client, when the DTO will enter the service layer, they will be converted to an internal model representation, which suits the DB internal entities.

## Defining a service

The service is defined as an interface, this allows as to provide a set of methods that each will be mapped to a requirement of our application.




# Async

## Blocking vs. Non Blocking

All methods that for example use the database are blocking, this means that the thread will be stuck on the call site until that function completes, we can avoid this by creating a new thread, in this way it can do other things an not wait util the function completes.

We could of a simple solution, we pass a callback to the function, and when it will finish the callback will be called, thus allowing the execution to continue freely.

The first to implement the concept of `async/await` was microsoft in C#. Later at Netflix the problems was that they could not handle high traffic spikes, they were able to solve the problem, they difined a reactive stack (RxJava), later ported to other languages.

Spring later took those concepts and created the Reactors. The use of using those reactive libraries, is very cumbersome, still better than write callbacks, but there was a way to achieve those.

At jetbrains used an old concept called **coroutines**. Coroutines help us writing asynchronous code like imperative code.

### Reactive Stack

Instead of having functions that block when called we have to make them async. To do that we have to reimplement our whole stack from the ground up (sockets, ...). 

Spring Web Flux (based on Jetty),

Servlet Stack vs. Reactive Stack: in servlet (concept of Tomcat) each request is handled by a single thread, in the reactive stack everything is asynchronous, every thread can contribute to the pipeline.

Imperative programming
```kotlin
var x = 2
var y = 3
var z = x * y
// z is 6

x = 10 // z is still 6
```

For example in excel if create a cell which created by computing a formula from the other cells, if those cells change also the result is updated accordingly, this is because the that cell only the formula is stored, and not the value, Excel has a reactive approach. A Reactive approach means to be able to respond to changes.


### The Observer Pattern

There is some source of information, and somebody is interesed to this source of information.

There is a `Subject` which internally keeps a list of subscribe. Other than that it has methods to `subscribe`, `unsubscirbe` and `notify`.

The observer pattern described in this way is very slow in a blocking way, for example if two observer comes from two different threads locking must be used. How do we notify the subscribers:
- **Synchronously**: we invoke a method, we iterate through the observers and we call the event they provided, but if that method is slow the others will not be notified.
- **Thread Pool**: we notify each observer using a thread per-each, if one observer is slow, it might start receiving event out of order, and they can start to overlap, maybe the ones that comes later finish first, we may cancel that event, but cancellation is different

### Publish and Subscribe (PUBS)

In this new patter, the subscriber does not know the identity of the publishers, but it contacts a middle channel called `Event Channel` which act as an aggregator, which means that a subscriber can receive a notification from many publishers. 

Spring provides this by default, we can annotate a class with `@EventListener` where we can specify a set of topics, in my application is creating shuch events my class will receive that event.

Problems: there is no way of cancelling those received events, there cannot be error recovery (the publisher does not know anything abount the subscriber), when the load increase the event channel may be significantly stressed.

## Reactive Frameworks

To define reactive frameworks we need to define 4 interfaces, it's a mixture between the **Observer** and **Iterator** patterns and **Functional programming**.

- `Subscriber<T>`: as long as I the class not in `onError` or in `onComplete` it can keep receiving `onNext`
```kotlin
interface Subscriber<T> {
  fun onSubscribe(s: Subscirption)

  fun onNext(t: T)

  fun onErrot(t: Throwable)

  fun onComplete()
}
```


# Coroutines and suspend functions

## Coroutines

Abstraction on top of persistent threading, allows us to schedule tasks on threads without needing to deal with threads creation. A `suspend fun` has the capability to be suspended at a certain point, and then restart when it finishes, it mean that when it reaches that poiont the thread can do other tasks while such suspending operation has completed.

A function expresses the fact that it can suspend. With coroutines we can express operations in a sequential way, while in reality those operation can be suspened to do something else and then start again from where the execution stopped. Coroutines also allow **composability** and **cancellability**.

- Composability: we can execute coroutines in parallel, the awaiting that generated those coroutines will continue when all of the subqueries finishes.
- Cancellable: it's the possibility to make the coroutine fail under some conditions, like a timeout for a web request.

Killing a running thread is very difficoult, the thread does not have any information on it's creator, this is why they must syncronize.

A coroutine before suspending sets up a way to resume, when that event will trigger that function will be marked as **resumable** and the scheduler will schedule it. A coroutine can be **Suspended**, **Resumable**, **Running**, when a **Running** coroutines reaches a suspension point, the scheduler can take a **Resumable** coroutine and put it on the os thread.

The limitation of suspending function is that it can only be called from another suspend function, for that reason kotlin provides some objects called `CoroutineScope` which provide a way of calling coroutines, and it will associate a **context** to each coroutine, this is done because in some cases it can only be called specific threads or to associate parents and childs of such coroutine. The scope will live as long as the coroutine does.

Each coroutine has an associated `Dispatcher`, which will take care of running that coroutine.

`CoroutineScope` has 3 instances:

- `launch()`: craetes a new coroutine and run as soon as possible, is bound to the caller via `Job` object where we can wait for the termination, cancel that coroutine, ...
- `async()`: returns a `Deferred` object where we can can `await` fot the termination of that coroutine and get the value of the computation.
- `runBlocking()`: this blocks the thread until all the coroutines created inside terminate, this is usually done in tests.

In spring a `CoroutineContext` contains 4 pieces:
- `CoroutineDispatcher`: which set of threads can run the coroutine
- `Job`: ...
- `CoroutineExceptionHandler`: ...
- `CoroutineName`: a provided string, used for dubugging

### Dispatchers

- `Main`: used in GUI application
- `IO`: large pool of thread for long-lasting operations like: IO, network call, db query, ...
- `Default`: used for CPU intensive operations like: encryption, json parsing, ...
- `Unconfined`: run by whichever thread is available, the use is discouraged

### Context Handling

...

### Synchronizaiton

It's possible to have synchronizaion from different coroutines

we can use a dispatcher based on a single thread with `.limitedParallelism(1)`, in this way accessing a variable there won't be any interfernce, because we deleted the possibility of having *race-conditions*. For the other cases it's possible to use `Mutex`.

```kotlin
fun main() = runBlocking {
  var mutex = Mutex()
  var n = 0
  runBlocking(Default) {
    launch {
      for (i in 1..1_000_000) {
        mutex.withLock { n += 1 }
      }
    }
    launch {
      for (i in 1..1_000_000) {
        mutex.withLock { n += 1 }
      }
    }
  }
  pritln("Final value: $n")
}
```

It's possible also to use `Semaphores` which contains a counter.


# Flows

Flows are capable of streaming values, those values are produces asynchronously. Flows by themselves does not produce anything unless there is a collector at the end, between the producer and consumer there can be other operations to modify the original flow. Some operations are intruduce to create concurrecy `buffer` and `flatMapMerge`. Flows can be **cold** or **hot**, a **cold** flow does not produce any value unless collected, while **hot** flows can emit values even if none is collecting.

```kotlin
fun stream(): Flow<Int> = flow {
  emit(1)
  emit(2)
}

// The program will print:
// 1
// 2
fun main() = runSuspending {
  stream().collect { value ->
    println(value)
  }
}
```

## `transform()`

The `transform` operator piped to a flow, allows to get the value of the flow and emit new values.

```kotlin
(1..3).asFlow()
  .map { it * 2 }
  .transform {
    emit(it - 1)
    emit(it)
  }
  .collect { pritln(it) }
// 1
// 2
// 3
// 4
// 5
// 6
```

A flow alows us to do **Local Reasoning**, it means that when collecting a flow we should not worry about how it was produced. **Context Preservation**: a flow has it's own context of execution, so it cannot leak informations on the outside, this means that no coroutine can be started inside of it, in fact a flow **shoud only emit from a single coroutine**.

```kotlin
flow {
  emit("Emitted in ${Thread.currentThread().name}")
}
.flowOn(Disptather.IO)
.map{ it -> "$it\nProcessed in ${Thread.currentThread().name}"}
.collect{ println(it) }

// Emitted in DefaultDispatcher-worker-1
// Processed in main
```

When using Spring we can convert Flows and suspend function to Flux and Mono, ....


This capability of returning items one a at a time in a reactive way, allows the communication between microservices much more conveniant. For example when we have a geteway that has to retrieve and combine objects from two different microservices, flows can help us get both flows by combining them, and return the complete object.

WebFlux allow to map request to specific methods.

```kotlin
coRouter {
  GET("/hello", ::hell)
}

suspend fun hell(request: ServerRequest) = ServerRespone
  .ok()
  .bodyValueAndWait("Hello World!")
```


## Spring R2DBC

....

`TransactionalOperator`: gurantees that all the coroutines finshes inside the logic block, if one of them fails, the transaction will be rooled back, if they all finish the transaction will be committed.

```kotlin
class PeopleRepository(val operator: TransactionalOperator) {

  fun update() = findPeople()
    .map(PepletDTO::class)
    .transactional(operator)

  // ...
}
```


# Security







# OpenID Connect

## Json Web Token (JWT)

Whenever we are logging in a OIDC IAM provider, we will get a token encoded as the standard describes in `Base64`. The JWT is divided in 3 parts

- **Header**: information about the token itself in json notation
- **Payload**: provides information about who will use this premissions and who garanted this permission
- **Signature**: the signature of the **header** and **payload**.

Payload fields:
- `sub`: defines the subject of the JWT
- `iss`: issuer of the JWT
- `aud`: the address of the intended service destined for the JWT
- `iat`: **Issued AT** (timestamp in epoch data)
- `nbf`: **Not valid BeFore**
- `exp`: **EXPiry**


# Spring Security

Declarative framework built aroud our application.

Both `Filters` and `Aspects` are governed by set of **Security Configuration**. To include security we need to add the `spring-boot-start-security` dependency. By default this plugin renders our application unusable, because it requires a login to be used, it can be configured further. Other dependencies are `spring-boot-starter-oauth2-*`, which allows us to use **OAuth2** login methods. We can also specify some `Filters` to check what comes inside the `Controller`s and what goes out of them.

Terminology:

- `Principal`: user, system or device acting in the system
- `Authentication`: who is accessing out application
- `Credentials`: whatever is used by a `Principal` to 
- `Authorization`: wether or not to give access to certain action to a `Principal`
- `Secured Resource`:
- `GrantedAuthority`: the set of actions that can be performed, any `Principal` can be assigned to a set of `GrantedAuthority` (like the authorizations on a Linux file).
- `SecurityContext`: stores information of the authenticated user, in Spring this context is bound to a thread which it knows who is invoking that function.

To configure how to the end-points should accept the various requests, we can a Spring `SecurityFilterChain`

```kotlin
@Configuration
class SecurityConfig {
  @Bean
  fun securityFilterChain(httpSecurity: HttpSecurity): SecurityFilterChain {
    return httpSecurity
      .authorizeHttpRequest {
        // Everybody
        it.requestMathers("/", "/login", "/logout").permitAll()
        // Only logged in
        it.requestMathers("/secure").authenticated()
        // Only not logged in
        it.requestMathers("/anon").anonymous()
      }
      .formLogin {}
      .logout {}
      .build()
  }
}
```

## Authentication Providers

The easiest is a `DaoAuthenticationProvider` which will use a database internally to check if the db contains that username and encrypted password, this is possible for trivial applications.

Depending on which part of the OAuth2 chain we are we use two different providers: `OidcAuthorizaionCodeAuthenticationProvider`, `JwtAuthenticationProvider`

## OIDC Authorization Code Flow.

The only two public end-poitns of our applications will be the `IAM` and the `OAuth2 Client`, all our services will be **hidded** behind the `OAuth2 Client`. When a browser will perform a request on our services, it will redirect (`3xx`) the request to the `IAM`. Once the `IAM` has authenticated the user, it will respond with a `302` redirecting the browser to the `OAuth2 Client` with a **nonce** inside the request parameters, with that nonce the `OAuth2 Clien` can get a **token** created by the `IAM`, when this finishes the `OAuth2 Client` create a **cookie** associated with the current session (token), when the browser will make a request the `OAuth2 Client` will translate the cookie to a **token**, the `OAuth2 Resource Server` will check the token for permissions, and finally will respond to the browser with a response.

Still there is a problem if a browser tries to logout, the `OAuth2 Client` will delete the cookie and the token, and the browser will be redirected to the `IAM` again, but the `IAM` contain already a session, which will not be deleted, and so it will get me a new **nonce** and, immediately, redirect the browser to the `OAuth2 Client`. So we didn't really logout, to specifically do this there is a special, function we can call on the `IAM` ...

## Resource Server

OAuth2 Resource Server provides information, it will attach a security token to each of the user request only if the token is validated.

- `issuer`: address of the IAM

In the security configuration the `sessionManagement` we declare it as `STATELESS` because it will be handled by the `OAuth2 Client`.

## Contact Resource Server from the Client

The **client** must map application requests to the **resource server** (send authenticaed requests to the resource server), thus a **Gateway** function must be implemented. This can be done easily with the spring cloud gateway library.

How do we tell the gateway (inside the client) where to send our requests?

```yaml
spring:
  cloud:
    gateway:
      mvc:
        routes:
          - id: service1
            # uri of the resource server
            uri: http://localhost:8081
            predicates:
              # Paths to match, only the specified paths will be
              # forwared to the resource server
              - Path=/api/v1/**
            filters:
              # How many parts of the uri needs to be stripped
              # from the request
              - StripPrefix=2
              # Include in the header (which will be forwared)
              # `authorization-beares` followed by the jwt.
              - TokenRelay
```
`application.yaml` of the client


## Accessing the principal

OAuth2 client we don't want to use sessions ...

Each method of a service can annotated with

- `@PreAuthorize`: evaluate **SpEL**, invoke the method if the check pass
- `@PostAuthorize`: block if the response after the method is invoked, if there is a transaction it will be rolledback, e.g. in a bank accoutn we can say after the method is invoked the balance has to be greater than zero, doing it apriori is difficoult, in this way is way easier to check
- `@PreFilter`: evaluate **SpEL**, expression evaluated on a collection of elements
- `@PostFilter`:
- `@Secured`: we check that who invoked this method has a certain role


When we disign a Single Page Application, we have a problem, because IAM login and SPA don't really works togheter. The SPA has to distinguis wether the user logged in or not.

In the client application we need to identify that the user is not authenticated, 

SPA authN flow:
1. request:
1. we try to access a resource, but are not authorized
1. the JS will replace our URL with the of the IAM authentication
1. When we provide the credientials to the IAM
1. we will be redirected back to the SPA, which was completely destroyed
1. this time we have cookie
1. the SPA will show approprieate components

When this approach is used the SPA is called **BFF** (Backend For Frontend)


The JS comunicating with the Server using a session is convenient, this allows for some attacks, one of this is called CSRF, where another web application can send request on the server on your behalf. This can be done because we have a valid session on the browser, we can prevent this by using some counter measures, all operations that can change something on the server we attach a `csrfToken` to the request, this can be done view the `SecurityFilterChain`.

When the JS will perform a request to change something on the server we attach a HTTP header `XSRF-TOKEN`, thanks to that the spring server will be able to validate the request, thus avoid someone else to perform request not performed by us.




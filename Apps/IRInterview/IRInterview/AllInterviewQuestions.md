# 🧠 Swift Interview: `struct` vs `class`

## ❓ Question: What is the **core difference** between a `struct` and a `class` in Swift?

At the core:

- `struct` ➝ **Value Type**  
- `class` ➝ **Reference Type**

Which means:

- A `struct` creates a **copy** when assigned or passed.
- A `class` shares a **reference**, not a copy — instances **point to the same memory**.

---

## 🔍 Follow-up #1: Can you explain the **difference between value and reference types** using the following examples?

```swift
class Person {
    var name: String
    init(name: String) { self.name = name }
}

let personA = Person(name: "Ahmet")
let personB = personA
personB.name = "Mehmet"

print(personA.name) // Output: Mehmet ✅
```

```swift
struct User {
    var name: String
}

var userA = User(name: "Ayşe")
var userB = userA
userB.name = "Fatma"

print(userA.name) // Output: Ayşe ✅
```

### 🎯 Explanation

- In the `class` example, `personA` and `personB` refer to the **same memory address**.
- In the `struct` example, `userB` is an **independent copy**, modifying it **does not affect** `userA`.

---

## 🔍 Follow-up #2: What’s the difference in **mutability semantics**?

- `struct` requires the `mutating` keyword in methods that change its properties:

```swift
struct Counter {
    var count = 0

    mutating func increment() {
        count += 1
    }
}
```

- `class` instances don’t need this — they're **implicitly mutable**, because they're reference types.

---

## 🔍 Follow-up #3: Does ARC (Automatic Reference Counting) apply to both?

**No.**

- ARC is exclusive to **reference types** (`class`, `closure`, `actor`, etc).
- `struct` values are stack-allocated or managed via COW — **no ARC** needed.

---

## 🔍 Follow-up #4: How about **inheritance**?

- ✅ `class` supports **inheritance**
- ❌ `struct` does **not** — only **protocol conformance** is allowed.

> _“Inheritance hierarchies? Class. Protocol-oriented composition? Struct.”_

---

## 🔍 Follow-up #5: Any **performance differences** between struct and class?

### ✅ `struct`  
- Allocated on the **stack**
- Fast memory access (LIFO)
- No ARC overhead
- Inline memory layout
- Fits well in CPU cache ➝ blazing fast

### ❌ `class`  
- Allocated on the **heap**
- Requires **ARC**, which implies:
  - Reference counting
  - Indirection (pointer dereferencing)
  - Possible locking ➝ thread overhead
- Prone to cache misses

> ⚠️ ARC is fast, but not free. Avoiding it altogether with value types is usually cheaper.

---

## 🔍 Follow-up #6: When should you prefer `struct` vs `class`?

| Use Case | Prefer |
|----------|--------|
| Immutable data | `struct` ✅ |
| Identity & reference semantics required | `class` ✅ |
| Inheritance is needed | `class` ✅ |
| Thread-safety by design | `struct` ✅ |
| Large, complex, shared objects | `class` ✅ |
| Transient, lightweight models | `struct` ✅ |

---

## 🔍 Follow-up #7: Can you explain the **copying behaviour** difference?

### `struct`  
- **Copied entirely** on assignment
- Each instance is **independent**

### `class`  
- **Reference is copied**, not the object
- Multiple variables can **mutate the same instance**

> 🧠 But Swift uses **Copy-on-Write (COW)** for common structs like `Array`, `String`, `Dictionary`.  
It only creates a real copy **when a mutation occurs**.

```swift
var arrayA = [1, 2, 3]
var arrayB = arrayA

arrayB.append(4) // Only now the copy happens
```

# 🧠 Swift Interview: `Access Control`

## ❓ Question: What is Access Control in Swift and why is it important?

Access Control is a mechanism in Swift that enables **data encapsulation** by restricting access to parts of your code. You can specify how and where a class, struct, property, or method can be accessed.

### Access Levels:
- `open` / `public`: Accessible from outside the module.
- `internal` (default): Accessible within the same module.
- `fileprivate` / `private`: Hidden from external code for safety and encapsulation.

Access control helps:
- Protect objects from unwanted modifications.
- Enforce encapsulation in modular architectures.
- Improve code maintainability and clarity.

---

## 🔍 Follow-up #1: What's the difference between `private` and `fileprivate`?

- `private`: Restricts access **to the enclosing scope** (e.g., within the same class or extension).
- `fileprivate`: Allows access **within the same file**, even across different types or extensions.

---

## 🔍 Follow-up #2: What is `internal` and how does it compare to `private` and `fileprivate`?

- `internal` allows access **within the same module** (app, framework, or Swift Package).
- Unlike `private` and `fileprivate`, it permits broader access across multiple files in the module.
- Ideal for **modular design** where components share logic internally without exposing it publicly.

---

## 🔍 Follow-up #3: What’s the difference between `open` and `public`?

Both allow access from outside the module, but their extensibility differs:

```swift
public var foo: Int
```

This is risky in frameworks: the property can be **read and written** externally. To restrict mutation:

```swift
// Inside a Framework
public class Cart {
    public private(set) var items: [Item] = []

    public func add(_ item: Item) {
        items.append(item)
    }
}

// In another module
let cart = Cart()
cart.add("Omer")
cart.items = ["Ali", "Veli"] // ❌ Error – items is read-only outside
print(cart.items.count)      // ✅
```

🧠 Note: `private(set)` is only applicable to **stored properties**.

| Modifier | Subclassing | Overriding | Module Access |
|----------|-------------|------------|----------------|
| `public` | ❌ No        | ❌ No       | ✅ Yes         |
| `open`   | ✅ Yes       | ✅ Yes      | ✅ Yes         |

```swift
// Library Module
open class Animal {
    public init() {}

    open func speak() -> String { "Animal sound" }  // Can be overridden
    public func walk() -> String { "Walking..." }   // Cannot be overridden
    func sleep() -> String { "Sleeping..." }        // internal
    private func secret() -> String { "Shh..." }    // private
}

// Another Module
class Cat: Animal {
    override func speak() -> String { "Meow" }
}

let cat = Cat()
print(cat.speak())      // ✅ Meow
print(cat.walk())       // ✅ Accessible
// cat.sleep()          // ❌ Not accessible (internal)
// cat.secret()         // ❌ Not accessible (private)
```

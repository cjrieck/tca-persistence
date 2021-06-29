# Persistence PoC

Demonstrates a solution for attaining opt-in state persistence and restoration.

## Package Components

### Persistence

An object that saves and loads objects marked with the `PersistedObject` protocol.

#### Declaration

```swift
struct Persistence<Object> where Object: PersistedObject
```

#### Overview

This object is used in conjunction with a `PersistenceStorage` object which provides a storage interface. You may also want to save multiple, unique objects either to the same or unique storage instances. This can be achieved with unique instances of this object for each unique state object you wish to persist.

### PersistenceStorage

An object for interacting with a storage solution. It provides an interface to save and load data to your storage solution.

#### Declaration

```swift
struct PersistenceStorage
```

#### Overview

//

### PersistedObject

A protocol for marking objects that you want to persist via the `Persistence` object.

#### Declaration

```swift
protocol PersistedObject: Codable
```

#### Overview

Mark any object that you wish you persist either fully or partially via the `Persistence` object with this protocol. This protocol provides extra, default implementation to assist in full and partial state persistence/restoration just by conforming to it.


### @PersistedProperty

A property wrapper for marking properties you wish to persist and restore.

#### Declaration

```swift
struct PersistedProperty<Value> where Value: Codable
```

#### Overview

Mark any property on your `PersistedObject` with this property wrapper to save and restore that property when saving and loading the parent state respectively.

An example of opting into persistence for select properties on some state may look something like

```swift
struct MapState: PersistedObject {
  private enum PersistenceKeys: String, CodingKey {
    case searchedLocations
  }
  
  @PersistedProperty(codingKeyName: PersistenceKeys.searchedLocations)
  var searchedLocations: [Location] = []
  var currentLocation: Location = .init()
}
```

This implementation would result in the `searchedLocations` property getting persisted between app sessions while the `currentLocation` property would get reset to its' initial value as defined on the state itself.

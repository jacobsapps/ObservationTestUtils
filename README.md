# ObservationTestUtils

Test utilities for writing unit tests on `@Observable` view models.

### Testing Observation

There is a trick to testing properties on `@Observable` view models.

Built into the Observation framework is a global function, `withObservationTracking`, which by Apple's own documentation, "Tracks access to properties."

This function takes two closures:
1. `apply` accesses properties on an `@Observable` entity.
2. `onChange` executes when values captured by `apply` change. 

With this understanding in place, we can write unit tests to handle our view model being changed:

```
func test_listenerSentBeersSuccessfully_setsBeers() {
    sut = BeerViewModel(repository: mockBeerRepository)
    let sampleBeers = [Beer.sample()]
    mockBeerRepository.beersPublisher.send(.success(sampleBeers))
    let exp = expectation(description: #function)
    withObservationTracking {
        _ = sut.beers
    } onChange: {
        exp.fulfill()
    }
    waitForExpectations(timeout: 1.0)
    XCTAssertEqual(sampleBeers, sut.beers)
}
```

### The withObservationTracking Helper Function

This is lovely and all, but we aren't exactly waving goodbye to boilerplate with these tests. We're actually using even more lines than the Combine-based tests.

But through the magic of keypaths, we can ameilorate this issue.
 
A helper function, resplendent with doc comments, is in order:

```
/// Waits for changes to a property at a given key path of an `@Observable` entity.
///
/// Uses the Observation framework's global `withObservationTracking` function to track changes to a specific property.
/// By using wildcard assignment (`_ = ...`), we 'touch' the property without wasting CPU cycles.
///
/// - Parameters:
///   - keyPath: The key path of the property to observe.
///   - parent: The observable view model that contains the property.
///   - timeout: The time (in seconds) to wait for changes before timing out. Defaults to `1.0`.
///
func waitForChanges<T, U>(to keyPath: KeyPath<T, U>, on parent: T, timeout: Double = 1.0) {
    let exp = expectation(description: #function)
    withObservationTracking {
        _ = parent[keyPath: keyPath]
    } onChange: {
        exp.fulfill()
    }
    waitForExpectations(timeout: timeout)
}
```

Here, our `BeerViewModel` serves as `T` and key paths for both `beers` and `showAlert` work for `U`.

Now our success case is a beautiful 5 lines of code:

```
func test_listenerSentBeersSuccessfully_setsBeers() {
    sut = BeerViewModel(repository: mockBeerRepository)
    let sampleBeers = [Beer.sample()]
    mockBeerRepository.beersPublisher.send(.success(sampleBeers))
    waitForChanges(to: \.beers, on: sut)
    XCTAssertEqual(sampleBeers, sut.beers)
}
```

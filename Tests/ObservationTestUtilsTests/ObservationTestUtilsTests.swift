import XCTest
import Observation
@testable import ObservationTestUtils

@Observable
final class ViewModel {
    
    var property: Int = 0
    
    @MainActor
    func loadProperty() {
        increment()
    }

    func loadPropertyAsync() async {
        let task = Task {
            await increment()
        }
        _ = await MainActor.run {
            task
        }
    }
    
    @MainActor
    private func increment() {
        property += 1
    }
}

final class ObservationTestUtilsTests: XCTestCase {

    var sut: ViewModel!
    
    override func setUp() {
        super.setUp()
        sut = ViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_viewModel_loadProperty() {
        Task {
            await sut.loadProperty()
        }
        waitForChanges(to: \.property, on: sut)
        XCTAssertEqual(sut.property, 1)
    }
    
    func test_viewModel_loadPropertyAsync() async {
        Task {
            await sut.loadPropertyAsync()
        }
        await awaitChanges(to: \.property, on: sut)
        XCTAssertEqual(sut.property, 1)
    }
}

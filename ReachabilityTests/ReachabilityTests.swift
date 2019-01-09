@testable import Reachability
import TestExtensions
import XCTest

final class ReachabilityTests: XCTestCase {
    private var reachability: Reachability!
    //swiftlint:disable weak_delegate
    private var delegate: MockReachabilityDelegate!

    override func setUp() {
        super.setUp()
        delegate = MockReachabilityDelegate()
        reachability = Reachability()
    }

    override func tearDown() {
        delegate = nil
        reachability = nil
        super.tearDown()
    }

    func testReachabilityCallbackIfConnectionPreset() {
        waitSync()

        // test
        XCTAssertTrue(reachability.isReachable)
    }

    func testReachabilityDelegateCalledOnConnectionChange() {
        // sut
        reachability.setDelegate(delegate)

        waitSync()

        // test
        let invocation = delegate.invocations
            .find(MockReachabilityDelegate.reachabilityDidChange1.name).first
        let isReachable = invocation?
            .parameter(for: MockReachabilityDelegate.reachabilityDidChange1.params.isReachable) as? Bool
        XCTAssertEqual(isReachable, true)
    }

    func testReachabilityIfNoConnectionPreset() {
        // mocks
        reachability = Reachability(host: "www.thisishopefullynotarealwebsite.co.uk")
        reachability.setDelegate(delegate)

        waitSync()

        // test
        XCTAssertFalse(reachability.isReachable)
    }
}

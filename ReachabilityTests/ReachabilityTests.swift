@testable import Reachability
import TestExtensions
import XCTest

final class ReachabilityTests: XCTestCase {
    private var reachability: Reachability!
    //swiftlint:disable weak_delegate
    private var delegate: MockReachabilityDelegate! = MockReachabilityDelegate()

    override func tearDown() {
        reachability = nil
        delegate = nil
        super.tearDown()
    }

    func testReachabilityCallbackIfConnectionPreset() {
        reachability = Reachability()
        reachability.setDelegate(delegate)
        wait(for: 1.0) {
            XCTAssertTrue(self.reachability.isReachable)
        }
    }

    func testReachabilityDelegateCalledOnConnectionChange() {
        reachability = Reachability()
        reachability.setDelegate(delegate)
        wait(for: 1.0) {
            let invocation = self.delegate.invocations
                .find(MockReachabilityDelegate.reachabilityDidChange1.name).first
            let isReachable = invocation?
                .parameter(for: MockReachabilityDelegate.reachabilityDidChange1.params.isReachable) as? Bool
            XCTAssertEqual(isReachable, true)
        }
    }

    func testReachabilityIfNoConnectionPreset() {
        let unreachableHost = "www.thisishopefullynotarealwebsite.co.uk"
        reachability = Reachability(host: unreachableHost)
        reachability.setDelegate(delegate)
        wait(for: 1.0) {
            XCTAssertFalse(self.reachability.isReachable)
        }
    }
}

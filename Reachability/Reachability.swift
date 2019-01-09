// swiftlint:disable file_header

//
//  Reachability.swift
//  Etcetera
//
//  Copyright © 2018 Nice Boy LLC. All rights reserved.
//

import Foundation
import SystemConfiguration

public protocol Mockable {} // Sourcery

// sourcery: name = Reachability
public protocol Reachable: Mockable {
    var isReachable: Bool { get }

    func setDelegate(_ delegate: ReachabilityDelegate)
}

public protocol ReachabilityDelegate: AnyObject, Mockable {
    func reachabilityDidChange(_ reachability: Reachable, isReachable: Bool)
}

/// A class that reports whether or not the network is currently reachable.
public final class Reachability: NSObject, Reachable {
    /// Synchronous evaluation of the current flags.
    public var isReachable: Bool {
        return flags?.contains(.reachable) == true
    }

    private let reachability: SCNetworkReachability?
    private weak var delegate: ReachabilityDelegate?
    private var lock = os_unfair_lock()
    private var _flags: SCNetworkReachabilityFlags?
    private var flags: SCNetworkReachabilityFlags? {
        get {
            os_unfair_lock_lock(&lock)
            let value = _flags
            os_unfair_lock_unlock(&lock)
            return value
        }
        set {
            os_unfair_lock_lock(&lock)
            _flags = newValue
            os_unfair_lock_unlock(&lock)
            DispatchQueue.main.async {
                self.delegate?.reachabilityDidChange(self, isReachable: self.isReachable)
            }
        }
    }

    public init(host: String = "www.google.com") {
        guard host.isValid else {
            assertionFailure("invalid host name")
            reachability = nil
            super.init()
            return
        }
        self.reachability = SCNetworkReachabilityCreateWithName(nil, host)
        super.init()
        guard let reachability = reachability else { return }

        // Populate the current flags asap.
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        _flags = flags

        // Then configure the callback.
        let callback: SCNetworkReachabilityCallBack = { _, flags, infoPtr in
            guard let info = infoPtr else { return }
            let this = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
            this.flags = flags
        }
        let selfPtr = Unmanaged.passUnretained(self).toOpaque()
        var context = SCNetworkReachabilityContext(
            version: 0, info: selfPtr, retain: nil, release: nil, copyDescription: nil
        )
        SCNetworkReachabilitySetCallback(reachability, callback, &context)
        SCNetworkReachabilitySetDispatchQueue(reachability, .global())
    }

    deinit {
        guard let reachability = reachability else { return }
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
    }

    public func setDelegate(_ delegate: ReachabilityDelegate) {
        self.delegate = delegate
    }
}

// MARK: - String

private extension String {
    var isValid: Bool {
        return URL(string: self) != nil
    }
}

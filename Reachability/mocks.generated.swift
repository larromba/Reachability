// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

// MARK: - Sourcery Helper

public protocol _StringRawRepresentable: RawRepresentable {
  var rawValue: String { get }
}

public struct _Variable<T> {
  let date = Date()
  var variable: T

  init(_ variable: T) {
    self.variable = variable
  }
}

public final class _Invocation {
  let name: String
  let date = Date()
  private var parameters: [String: Any] = [:]

  init(name: String) {
    self.name = name
  }

  fileprivate func set<T: _StringRawRepresentable>(parameter: Any, forKey key: T) {
    parameters[key.rawValue] = parameter
  }
  public func parameter<T: _StringRawRepresentable>(for key: T) -> Any? {
    return parameters[key.rawValue]
  }
}

public final class _Actions {
  enum Keys: String, _StringRawRepresentable {
    case returnValue
    case defaultReturnValue
    case error
  }
  private var invocations: [_Invocation] = []

  // MARK: - returnValue

  public func set<T: _StringRawRepresentable>(returnValue value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.returnValue)
  }
  public func returnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.returnValue) ?? invocation.parameter(for: Keys.defaultReturnValue)
  }

  // MARK: - defaultReturnValue

  fileprivate func set<T: _StringRawRepresentable>(defaultReturnValue value: Any, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: value, forKey: Keys.defaultReturnValue)
  }
  fileprivate func defaultReturnValue<T: _StringRawRepresentable>(for functionName: T) -> Any? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.defaultReturnValue) as? (() -> Void)
  }

  // MARK: - error

  public func set<T: _StringRawRepresentable>(error: Error, for functionName: T) {
    let invocation = self.invocation(for: functionName)
    invocation.set(parameter: error, forKey: Keys.error)
  }
  public func error<T: _StringRawRepresentable>(for functionName: T) -> Error? {
    let invocation = self.invocation(for: functionName)
    return invocation.parameter(for: Keys.error) as? Error
  }

  // MARK: - private

  private func invocation<T: _StringRawRepresentable>(for name: T) -> _Invocation {
    if let invocation = invocations.filter({ $0.name == name.rawValue }).first {
      return invocation
    }
    let invocation = _Invocation(name: name.rawValue)
    invocations += [invocation]
    return invocation
  }
}

public final class _Invocations {
  private var history = [_Invocation]()

  fileprivate func record(_ invocation: _Invocation) {
    history += [invocation]
  }

  public func isInvoked<T: _StringRawRepresentable>(_ name: T) -> Bool {
    return history.contains(where: { $0.name == name.rawValue })
  }

  public func count<T: _StringRawRepresentable>(_ name: T) -> Int {
    return history.filter {  $0.name == name.rawValue }.count
  }

  public func all() -> [_Invocation] {
    return history.sorted { $0.date < $1.date }
  }

  public func find<T: _StringRawRepresentable>(_ name: T) -> [_Invocation] {
    return history.filter {  $0.name == name.rawValue }.sorted { $0.date < $1.date }
  }
}

// MARK: - Sourcery Mocks

public class MockReachabilityDelegate: NSObject, ReachabilityDelegate {
    public let invocations = _Invocations()
    public let actions = _Actions()

    // MARK: - reachabilityDidChange

    public 
    func reachabilityDidChange(_ reachability: Reachable, isReachable: Bool) {
        let functionName = reachabilityDidChange1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: reachability, forKey: reachabilityDidChange1.params.reachability)
        invocation.set(parameter: isReachable, forKey: reachabilityDidChange1.params.isReachable)
        invocations.record(invocation)
    }

    public 
    enum reachabilityDidChange1: String, _StringRawRepresentable {
      case name = "reachabilityDidChange1"
      public enum params: String, _StringRawRepresentable {
        case reachability = "reachabilityDidChange(_reachability:Reachable,isReachable:Bool).reachability"
        case isReachable = "reachabilityDidChange(_reachability:Reachable,isReachable:Bool).isReachable"
      }
    }
}

public class MockReachability: NSObject, Reachable {
    public 
    var isReachable: Bool {
        get { return _isReachable }
        set(value) { _isReachable = value; _isReachableHistory.append(_Variable(value)) }
    }
    var _isReachable: Bool!
    var _isReachableHistory: [_Variable<Bool>] = []
    public let invocations = _Invocations()
    public let actions = _Actions()

    // MARK: - setDelegate

    public 
    func setDelegate(_ delegate: ReachabilityDelegate) {
        let functionName = setDelegate1.name
        let invocation = _Invocation(name: functionName.rawValue)
        invocation.set(parameter: delegate, forKey: setDelegate1.params.delegate)
        invocations.record(invocation)
    }

    public 
    enum setDelegate1: String, _StringRawRepresentable {
      case name = "setDelegate1"
      public enum params: String, _StringRawRepresentable {
        case delegate = "setDelegate(_delegate:ReachabilityDelegate).delegate"
      }
    }
}

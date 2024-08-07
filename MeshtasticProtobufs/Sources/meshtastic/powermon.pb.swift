// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: meshtastic/powermon.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// Note: There are no 'PowerMon' messages normally in use (PowerMons are sent only as structured logs - slogs).
///But we wrap our State enum in this message to effectively nest a namespace (without our linter yelling at us)
public struct PowerMon {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  /// Any significant power changing event in meshtastic should be tagged with a powermon state transition.
  ///If you are making new meshtastic features feel free to add new entries at the end of this definition.
  public enum State: SwiftProtobuf.Enum {
    public typealias RawValue = Int
    case none // = 0
    case cpuDeepSleep // = 1
    case cpuLightSleep // = 2

    ///
    ///The external Vext1 power is on.  Many boards have auxillary power rails that the CPU turns on only
    ///occasionally.  In cases where that rail has multiple devices on it we usually want to have logging on
    ///the state of that rail as an independent record.
    ///For instance on the Heltec Tracker 1.1 board, this rail is the power source for the GPS and screen.
    ///
    ///The log messages will be short and complete (see PowerMon.Event in the protobufs for details).
    ///something like "S:PM:C,0x00001234,REASON" where the hex number is the bitmask of all current states.
    ///(We use a bitmask for states so that if a log message gets lost it won't be fatal)
    case vext1On // = 4
    case loraRxon // = 8
    case loraTxon // = 16
    case loraRxactive // = 32
    case btOn // = 64
    case ledOn // = 128
    case screenOn // = 256
    case screenDrawing // = 512
    case wifiOn // = 1024

    ///
    ///GPS is actively trying to find our location
    ///See GPSPowerState for more details
    case gpsActive // = 2048
    case UNRECOGNIZED(Int)

    public init() {
      self = .none
    }

    public init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .none
      case 1: self = .cpuDeepSleep
      case 2: self = .cpuLightSleep
      case 4: self = .vext1On
      case 8: self = .loraRxon
      case 16: self = .loraTxon
      case 32: self = .loraRxactive
      case 64: self = .btOn
      case 128: self = .ledOn
      case 256: self = .screenOn
      case 512: self = .screenDrawing
      case 1024: self = .wifiOn
      case 2048: self = .gpsActive
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    public var rawValue: Int {
      switch self {
      case .none: return 0
      case .cpuDeepSleep: return 1
      case .cpuLightSleep: return 2
      case .vext1On: return 4
      case .loraRxon: return 8
      case .loraTxon: return 16
      case .loraRxactive: return 32
      case .btOn: return 64
      case .ledOn: return 128
      case .screenOn: return 256
      case .screenDrawing: return 512
      case .wifiOn: return 1024
      case .gpsActive: return 2048
      case .UNRECOGNIZED(let i): return i
      }
    }

  }

  public init() {}
}

#if swift(>=4.2)

extension PowerMon.State: CaseIterable {
  // The compiler won't synthesize support with the UNRECOGNIZED case.
  public static let allCases: [PowerMon.State] = [
    .none,
    .cpuDeepSleep,
    .cpuLightSleep,
    .vext1On,
    .loraRxon,
    .loraTxon,
    .loraRxactive,
    .btOn,
    .ledOn,
    .screenOn,
    .screenDrawing,
    .wifiOn,
    .gpsActive,
  ]
}

#endif  // swift(>=4.2)

#if swift(>=5.5) && canImport(_Concurrency)
extension PowerMon: @unchecked Sendable {}
extension PowerMon.State: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "meshtastic"

extension PowerMon: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = _protobuf_package + ".PowerMon"
  public static let _protobuf_nameMap = SwiftProtobuf._NameMap()

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let _ = try decoder.nextFieldNumber() {
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: PowerMon, rhs: PowerMon) -> Bool {
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension PowerMon.State: SwiftProtobuf._ProtoNameProviding {
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "None"),
    1: .same(proto: "CPU_DeepSleep"),
    2: .same(proto: "CPU_LightSleep"),
    4: .same(proto: "Vext1_On"),
    8: .same(proto: "Lora_RXOn"),
    16: .same(proto: "Lora_TXOn"),
    32: .same(proto: "Lora_RXActive"),
    64: .same(proto: "BT_On"),
    128: .same(proto: "LED_On"),
    256: .same(proto: "Screen_On"),
    512: .same(proto: "Screen_Drawing"),
    1024: .same(proto: "Wifi_On"),
    2048: .same(proto: "GPS_Active"),
  ]
}

//
//  ETHRlp.swift
//  token
//
//  Created by James Chen on 2016/10/27.
//  Copyright © 2016 imToken PTE. LTD. All rights reserved.
//

import Foundation

// Wiki: https://github.com/ethereum/wiki/wiki/RLP
@objc public class RLP : NSObject {
  static let shortLengthLimit        = 56
  static let longLengthLimit         = pow(256, 8)
  static let primitivePrefixOffset   = 0x80
  static let listPrefixOffset        = 0xc0

  typealias Byte = UInt8
  typealias ByteArray = [UInt8]

 @objc public static func encode(_ input: Any) -> String {
    let bytes: ByteArray = encodeToByteArr(input)
    return Hex.hex(from: bytes)
  }

  @objc static func encodeToByteArr(_ input: Any) -> ByteArray {
    if let string = input as? String {
      if string.hasPrefix("#") {
        return encodeBigNumber(bigNum: BigNumberTest.parse(string))
      } else {
        return encodeString(string: string)
      }
    }

    if let bigNum = (input as? BigNumberTest) ?? BigNumberTest(input) {
      return encodeBigNumber(bigNum: bigNum)
    }

    if let array = input as? [Any] {
      return encodeList(list: array)
    }

    return []
  }
}

private extension RLP {
  static func encodeBytes(bytes: ByteArray) -> ByteArray {
    if bytes.count == 1 && Int(bytes.first!) < primitivePrefixOffset {
      return bytes
    } else {
      return encode(length: bytes.count, offset: primitivePrefixOffset) + bytes
    }
  }

  static func encodeString(string: String) -> ByteArray {
    return encodeBytes(bytes: Array(string.utf8))
  }

  static func encodeBigNumber(bigNum: BigNumberTest) -> ByteArray {
    return encodeBytes(bytes: bigNum.serialize())
  }

  static func encodeList(list: [Any]) -> ByteArray {
    var result = ByteArray()
    for item in list {
      let encodedItem: ByteArray = encodeToByteArr(item)
      result += encodedItem
    }
    return encode(length: result.count, offset: listPrefixOffset) + result
  }

  static func encode(length: Int, offset: Int) -> ByteArray {
    if length < shortLengthLimit {
      return [Byte(length + offset)]
    } else if Decimal(length) < longLengthLimit {
      let hex = String(length, radix: 16)
      let binary = Hex.toBytes(Hex.pad(hex))
      return [Byte(binary.count + offset + shortLengthLimit - 1)] + binary
    }

    return []
  }
}

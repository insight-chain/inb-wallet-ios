//
//  BigNumber.swift
//  test
//
//  Created by insightChain_iOS开发 on 2019/6/5.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

import Foundation
import BigInt

@objc public class BigNumberTest:NSObject{
    private let value: BigUInt
    private let padding:Bool
    private let bytesLength:Int
    
    private init(value:BigUInt, padding:Bool, bytesLength:Int){
        self.value = value;
        self.padding = padding;
        self.bytesLength = bytesLength;
    }
    
    init?(_ v: Any) {
        self.padding = false
        self.bytesLength = 0
        
        if let int = v as? Int64 {
            self.value = BigUInt(int)
        } else if let int = v as? Int {
            self.value = BigUInt(int)
        } else if let int = v as? UInt8 {
            self.value = BigUInt(int)
        } else {
            return nil
        }
    }
    func serialize() -> [UInt8] {
        var bytes = value.serialize().bytes
        if padding {
            while bytes.count < bytesLength {
                bytes.insert(0x00, at: 0)
            }
        }
        return bytes
    }
    
    
    @objc public static func parse(_ text:String, padding:Bool = false, paddingLen:Int = -1) -> BigNumberTest{
        var padding = padding
        var value: BigUInt
        var bytesLen: Int = 0
        
        if text.hasPrefix("#") {
            let t = text.tk_substring(from: 1)
            value = BigUInt(extendedGraphemeClusterLiteral: t)
            bytesLen = bytesLength(of: t)
        } else if Hex.hasPrefix(text) {
            let t = Hex.removePrefix(text)
            value = BigUInt(t, radix: 16)!
            bytesLen = bytesLength(of: t)
        } else {
            if text.tk_isDigits {
                // NOTE: if text is a hex string without alhpabet this won't work.
                // It's just a simple guess. Better to pass in hex always prefixed with "0x".
                
                value = BigUInt(Hex.removePrefix(text), radix: 10)!
                padding = false
            } else if Hex.isHex(text) {
                let t = Hex.removePrefix(text)
                value = BigUInt(t, radix: 16)!
                bytesLen = bytesLength(of: t)
            } else {
                // Parse fail!
                value = BigUInt(0)
            }
        }
        
        bytesLen = paddingLen != -1 ? paddingLen : bytesLen
        
        return BigNumberTest(value: value, padding: padding, bytesLength: bytesLen)
    }
    
    @objc private static func bytesLength(of string: String) -> Int {
        return (string.count + 1) / 2
    }
}

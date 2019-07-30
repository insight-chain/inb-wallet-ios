//
//  Keccak256_bridge.swift
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/21.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

import Foundation
import CryptoSwift

@objc public class Keccak256_bridge : NSObject{
    public override init() {
    }
    // Encrypt and return as hex
   
    @objc public func encrypt(hex: String) -> String {
        return encrypt(data: hex.tk_dataFromHexString()!)
    }
    
    @objc public func encrypt(data: Data) -> String {
        return SHA3(variant: .keccak256).calculate(for: data.bytes).toHexString()
    }
}

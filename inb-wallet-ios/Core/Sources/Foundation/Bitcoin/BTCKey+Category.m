//
//  BTCKey+Category.m
//  inb-wallet-ios
//
//  Created by insightChain_iOS开发 on 2019/6/28.
//  Copyright © 2019 insightChain_iOS开发. All rights reserved.
//

#import "BTCKey+Category.h"
#import "CoreBitcoin.h"

@implementation BTCKey (Category)
-(BTCAddress *)addressOn:(Network)network segWit:(NSString *)segWit{
    if ([segWit isEqualToString:@"P2WPKH"]) {
        if (network == network_main) {
            return [self witnessAddress];
        }else{
            return [self witnessAddressTestnet];
        }
    }else{
        if (network == network_main) {
            return [self address];
        }else{
            return [self addressTestnet];
        }
    }
}
@end

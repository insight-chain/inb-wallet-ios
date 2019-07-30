//
//  WalletIDValidator.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletIDValidator.h"
@interface WalletIDValidator()

@property(nonatomic, strong) NSString *walletID;
@property(nonatomic, strong) NSString *formatRegex;
@end

@implementation WalletIDValidator

-(instancetype)initWithWalletID:(NSString *)walletID{
    if (self = [super init]) {
        self.walletID = walletID;
    }
    return self;
}

-(NSString *)validate{
    if (!self.isValid) {
        @throw Exception(@"GenericError", @"paramError");
    }
    return self.walletID;
}

-(BOOL)isValid{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.formatRegex];
    return  [predicate evaluateWithObject:self.walletID];
}

-(NSString *)formatRegex{
    return @"^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$";
}

@end

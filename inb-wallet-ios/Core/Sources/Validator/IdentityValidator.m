//
//  IdentityValidator.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/6/1.
//  Copyright © 2019 apple. All rights reserved.
//

#import "IdentityValidator.h"
#import "Identity.h"

@interface IdentityValidator()
@property(nonatomic, strong) NSString *identifier;

@end

@implementation IdentityValidator
-(instancetype)init{
    return [self initWithIdentifier:nil];
}
-(instancetype)initWithIdentifier:(NSString *)identifier{
    if (self = [super init]) {
        _identifier = identifier;
    }
    return self;
}

-(BOOL)isValid{
    Identity *identity = Identity.currentIdentity;
    if (!identity) {
        return NO;
    }
    if(self.identifier != nil){
        return identity.identifier == self.identifier;
    }
    return YES;
}
-(Identity *)validate{
    Identity *identity = Identity.currentIdentity;
    if (!identity) {
        @throw [NSException exceptionWithName:@"IdentityError" reason:@"invalidIdentity" userInfo:nil];
    }
    if (self.identifier != nil && identity.identifier != self.identifier) {
        @throw [NSException exceptionWithName:@"IdentityError" reason:@"invalidIdentity" userInfo:nil];
    }
    return identity;
}
@end

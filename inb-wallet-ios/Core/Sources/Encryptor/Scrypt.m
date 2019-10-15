//
//  Scrypt.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/20.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Scrypt.h"

#import "NSData+HexString.h"

#import "libscrypt.h"

@interface Scrypt()
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *salt;
@property(nonatomic, assign) int n;
@property(nonatomic, assign) int r;
@property(nonatomic, assign) int p;
@property(nonatomic, assign) int dklen;// = 32
@end

@implementation Scrypt

-(instancetype)initWith:(NSString *)password salt:(NSString *)salt n:(int)n r:(int)r p:(int)p{
    if(self = [super init]){
        self.password = password;
        self.salt = salt;
        self.n = n;
        self.r = r;
        self.p = p;
        self.dklen = 32;
    }
    return self;
}
-(NSString *)encrypt{
    
    NSData *passwordData = [self.password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *saltData = [NSData hexStringToData:self.salt];
//    void *bytes = NULL;
    uint8_t bytes[self.dklen];
//    NSMutableData *muta = [NSMutableData dataWithCapacity:self.dklen];
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    int result = libscrypt_scrypt(passwordData.bytes,
                                  passwordData.length,
                                  saltData.bytes,
                                  saltData.length,
                                  ((UInt64)self.n),
                                  ((UInt32)self.r),
                                  ((UInt32)self.p),
                                  bytes,
                                  self.dklen);
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"---- 方法耗时: %f ms", endTime * 1000.0);
    if(result == 0){
        NSData *da = [NSData dataWithBytes:bytes length:self.dklen];
        return [da dataToHexString];
    }else{
        @throw Exception(@"解密", @"失败");
        return nil;
    }
    
}
@end

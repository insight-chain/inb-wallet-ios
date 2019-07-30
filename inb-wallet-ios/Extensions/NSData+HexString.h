//
//  NSData+HexString.h
//  wallet
//
//  Created by apple on 2019/3/25.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (HexString)
-(NSString *)dataToHexString;

+(NSData *)hexStringToData:(NSString *)hexString;

+(NSData *)random:(int)length;
@end

NS_ASSUME_NONNULL_END

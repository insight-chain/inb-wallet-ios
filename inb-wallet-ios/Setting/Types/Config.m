//
//  Config.m
//  wallet
//
//  Created by apple on 2019/3/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import "Config.h"

static Config *current;
static UInt64 dbMigrationSchemaVersion = 77;

static NSString *const currencyID = @"currencyID";

@interface Config()
@property(nonatomic, strong) NSUserDefaults *defaults;
@property(nonatomic, assign) int currency; //货币
@end

@implementation Config

#pragma mark ---- Getter
-(NSUserDefaults *)defaults{
    return [NSUserDefaults standardUserDefaults];
}
+(Config *)current{
    return [[Config alloc] init];
}
+(UInt64)dbMigrationSchemaVersion{
    return dbMigrationSchemaVersion;
}

@end

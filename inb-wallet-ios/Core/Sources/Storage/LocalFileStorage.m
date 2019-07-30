//
//  LocalFileStorage.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/5/22.
//  Copyright © 2019 apple. All rights reserved.
//

#import "LocalFileStorage.h"

#import "Identity.h"

#import "WalletIDValidator.h"

static NSString *identityFileName = @"identity.json";
@interface LocalFileStorage()

@property(nonatomic, strong) NSURL *walletsDirectory;

@end

@implementation LocalFileStorage

-(Identity *)tryLoadIdentity{
    NSDictionary *jsonObject = [self tryLoadJSON:identityFileName];
    if(!jsonObject){
        return nil;
    }
    return [[Identity alloc] initWithJSON:jsonObject];
}

-(NSArray<BasicWallet *> *)loadWalletByIDs:(NSArray *)walletIDs{
    NSMutableArray *wallets = [NSMutableArray array];
    for (NSString *walletID in walletIDs) {
        NSString *st = [[[WalletIDValidator alloc] initWithWalletID:walletID] validate];
        NSDictionary *json = [self tryLoadJSON:st];
        BasicWallet *wallet = [[BasicWallet alloc] initWithJSON:json];
        [wallets addObject:wallet];
    }
    return wallets;
}
-(BOOL)deleteWalletByID:(NSString *)walletID{
    NSString *iii = [[[WalletIDValidator alloc] initWithWalletID:walletID] validate];
    if (!iii) {
        return NO;
    }
    return [self deleteFile:iii];
}

-(BOOL)cleanStorage{
    NSError *err;
    [[NSFileManager defaultManager] removeItemAtURL:self.walletsDirectory error:&err];
    if (err) {
        return NO;
    }
    return YES;
}

-(BOOL)flushWallet:(Keystore *)keystore{
    NSString *cc = [[[WalletIDValidator alloc] initWithWalletID:keystore.ID] validate];
    if (cc) {
        return [self writeContent:[keystore dump] fileName:cc];
    }
    return NO;
}
-(BOOL)flushIdentity:(IdentityKeystore *)keystore{
    return [self writeContent:[keystore dump:NO] fileName:identityFileName];
}
-(NSDictionary *)tryLoadJSON:(NSString *)fileName{
    NSString *fileContent = [self readFrom:fileName];
    if (!fileContent) {
        return nil;
    }
    NSData *data = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        return nil;
    }
    return jsonObject;
}
-(NSString *)readFrom:(NSString *)fileName{
    NSString *filePath = [self.walletsDirectory URLByAppendingPathComponent:fileName].path;
    if (filePath) {
        NSError *err;
        return  [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
        if (err) {
            return nil;
        }
    }else{
        return nil;
    }
}
-(BOOL)writeContent:(NSString *)content fileName:(NSString *)fileName{
    NSString *filePath = [self.walletsDirectory URLByAppendingPathComponent:fileName].path;
    NSError *error;
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return NO;
    }
    return YES;
}
-(BOOL)deleteFile:(NSString *)filename{
    NSString *filePath = [self.walletsDirectory URLByAppendingPathComponent:filename].path;
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error) {
        return NO;
    }
    return YES;
}

-(NSURL *)walletsDirectory{
    NSString *walletsPath = [NSString stringWithFormat:@"%@/Documents/wallets",NSHomeDirectory()];
    NSURL *walletsDirectory = [NSURL fileURLWithPath:walletsPath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:walletsPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:walletsDirectory.path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return walletsDirectory;
}

@end

//
//  WalletInfoViewModel.m
//  wallet
//
//  Created by insightChain_iOS开发 on 2019/4/2.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WalletInfoViewModel.h"

@implementation WalletInfoViewModel

//-(instancetype)initWithWalletInfo:(WalletInfo *)wallet{
//    if (self = [super init]) {
//        _wallet = wallet;
//    }
//    return self;
//}
//
//-(NSMutableAttributedString *)assets_inb{
//    NSString *str = [NSString stringWithFormat:@"%.2f INB", self.wallet.currentAccount.assets_inb];
//    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedFontSize(30),
//                                                                                                           NSForegroundColorAttributeName:[UIColor whiteColor]
//                                                                                                           }];
//    [mutStr setAttributes:@{NSFontAttributeName:AdaptedFontSize(20),
//                            NSForegroundColorAttributeName:[UIColor whiteColor]
//                            } range:[str rangeOfString:@"INB"]];
//    return mutStr;
//}
//-(NSString *)assets_cny{
//    NSString *str = [NSString stringWithFormat:@"≈ %.2f CNY", self.wallet.currentAccount.assets_cny];
//    return str;
//}
//-(NSMutableAttributedString *)assets_inb_hiden{
//    NSString *str = [NSString stringWithFormat:@"**** INB"];
//    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:AdaptedFontSize(30),
//                                                                                                           NSForegroundColorAttributeName:[UIColor whiteColor]
//                                                                                                           }];
//    [mutStr setAttributes:@{NSFontAttributeName:AdaptedFontSize(20),
//                            NSForegroundColorAttributeName:[UIColor whiteColor]
//                            } range:[str rangeOfString:@"INB"]];
//    return mutStr;
//}
//-(NSString *)assets_cny_hiden{
//    NSString *str = [NSString stringWithFormat:@"≈ **** CNY", self.wallet.currentAccount.assets_cny];
//    return str;
//}
//-(NSString *)cpu_total{
//    return [NSString stringWithFormat:@"%.0fms", self.wallet.currentAccount.cpu_total];
//}
//-(NSString *)cpu_remaining{
//    return [NSString stringWithFormat:@"%.0fms", self.wallet.currentAccount.cpu_remaining];
//}
//-(NSString *)mortgage{
//    return [NSString stringWithFormat:@"%.4f INB", self.wallet.currentAccount.mortgage];
//}
@end

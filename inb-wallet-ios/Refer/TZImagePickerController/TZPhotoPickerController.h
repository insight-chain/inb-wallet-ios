//
//  TZPhotoPickerController.h
//  TZImagePickerController
//
//  Created by yuchao on 17/11/2.
//  Copyright © 2017年 yuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FAGlobal.h"

@class TZAlbumModel;
@interface TZPhotoPickerController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) TZAlbumModel *model;
@end


@interface TZCollectionView : UICollectionView

@end

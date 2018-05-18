//
//  IMShopCartNumberCount.h
//  TXH
//
//  Created by Raymon on 2016/3/13.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IMShopCartNumberChangeType) {
    IMShopCartNumberChangeTypeAdd = 1,
    IMShopCartNumberChangeTypeSub,
    IMShopCartNumberChangeTypeInput
};

@interface IMShopCartNumberCount : UIView

// 总数
@property (nonatomic, assign) NSInteger totalNum;

// 当前显示价格
@property (nonatomic, assign) NSInteger currentCountNumber;

// 数量改变回调
@property (nonatomic, copy) void(^IMShopCartNumberChangeBlock)(NSInteger count, IMShopCartNumberChangeType type);

@end

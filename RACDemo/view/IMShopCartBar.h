//
//  IMShopCartBar.h
//  TXH
//
//  Created by Raymon on 2016/3/9.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMShopCartBar : UIView

// 结算
@property (nonatomic, strong) UIButton *balanceButton;
// 全选
@property (nonatomic, strong) UIButton *selectAllButton;
// 价格
@property (nonatomic, strong) UILabel *allMoneyLabel;
// 删除
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, assign) BOOL      isNormalState;

@property (assign, nonatomic) float     money;

@property (nonatomic, assign) BOOL      isSelectBalance;



@end

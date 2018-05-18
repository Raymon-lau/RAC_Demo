//
//  IMShopCartHeaderView.h
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMShopCartHeaderView : UITableViewHeaderFooterView

// 活动标签
@property (nonatomic, copy) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *gotoPassLabel;;

@property (strong, nonatomic) NSDictionary *infoDic;

// 选择店铺商品
@property (nonatomic, strong) UIButton *selectStoreGoodsButton;

// 去凑单
@property (strong, nonatomic) UIButton *gotoPassaButton;

//点击天目的按钮
@property (strong, nonatomic) UIButton *headerButton;

// 获取headerView的高度
+ (CGFloat)getShopCartHeaderHeight;

@end

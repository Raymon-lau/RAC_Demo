//
//  IMShopCartCell.h
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMShopCartModel, IMShopCartNumberCount;
@interface IMShopCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectShopGoodsButton;

@property (weak, nonatomic) IBOutlet IMShopCartNumberCount *numberCount;

@property (weak, nonatomic) IBOutlet UILabel *showCartNum;

@property (nonatomic, strong) IMShopCartModel *model;

@property (nonatomic, assign) BOOL isEdit;


+ (CGFloat)getCartCellHeightWith:(IMShopCartModel *)model;

@end

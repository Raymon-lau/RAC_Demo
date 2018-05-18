//
//  IMShopCartCell.m
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartCell.h"
#import "IMShopCartNumberCount.h"
#import "IMShopCartModel.h"

@interface IMShopCartCell ()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSKULabel;
@property (weak, nonatomic) IBOutlet UIImageView *isGoodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *isNoGoodsTip;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UIView *activityMessageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityConstraint;
@property (weak, nonatomic) IBOutlet UILabel *discountPrice;
@property (weak, nonatomic) IBOutlet UILabel *discountNumber;
@property (weak, nonatomic) IBOutlet UILabel *priceSymbol;

@end

@implementation IMShopCartCell{
    UIImageView *_iconView;
    UILabel *_activityTitleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.isGoodsImageView.hidden = YES;
    // 商品数量标签 默认NO
    self.showCartNum.hidden = YES;
    self.isNoGoodsTip.hidden = YES;
    // 购物数量加减View 默认YES
    self.numberCount.hidden = NO;
    _totalPrice.textColor = [UIColor redColor];
    self.activityConstraint.constant = 0;
    [self creatUI];
}

- (void)creatUI{
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.5, 15, 15)];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    _activityTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconView.frame) + 5, 0, kScreenWidth - 80, 16)];
    _activityTitleLabel.font = [UIFont systemFontOfSize:13.0];
    
    [_activityMessageView addSubview:_iconView];
    [_activityMessageView addSubview:_activityTitleLabel];
    
//    _discountNumber.layer.borderColor = kDiscountBackColorOrange.CGColor;
    _discountNumber.backgroundColor = [UIColor orangeColor];
//    _discountNumber.layer.borderWidth = 1;
}

- (void)setModel:(IMShopCartModel *)model{
    self.goodsNameLabel.text             = model.ItemName;
    self.goodsPricesLabel.text           = [NSString stringWithFormat:@"￥%.2f",[model.SPrice floatValue]];
    self.numberCount.totalNum            = 999;
    self.showCartNum.text                = [NSString stringWithFormat:@"x %@",model.ItemNumber];
    self.numberCount.currentCountNumber  = [model.ItemNumber integerValue];
    self.goodsSKULabel.text              = model.SkuProp;
    self.goodsImageView.image = [UIImage imageNamed:@""];
    float shopPrice = [model.ItemNumber integerValue] * [model.SPrice floatValue];
    self.totalPrice.text = [NSString stringWithFormat:@"小计:￥%.2f",shopPrice];
    _discountNumber.hidden = YES;
    _discountPrice.hidden = YES;
    _priceSymbol.hidden = YES;

    [self changeGoodsStatusWithModel:model];
}

- (void)changeGoodsStatusWithModel:(IMShopCartModel *)model{
    self.isGoodsImageView.image = [UIImage imageNamed:model.ItemPic];
    self.isGoodsImageView.hidden = NO;
    self.totalPrice.hidden = NO;
    if (_isEdit) {
        self.numberCount.hidden = NO;
        self.showCartNum.hidden = YES;
    }else{
        self.numberCount.hidden = NO;// yes
        self.showCartNum.hidden = YES;// NO
    }
    self.selectShopGoodsButton.selected  = model.isSelect;

}

+ (CGFloat)getCartCellHeightWith:(IMShopCartModel *)model{
    if ([model.ActivityTypeId integerValue] == 1) {
        if ([model.MappingStatus isEqualToString:@"2"]){// 下架商品
            return 130;
        }else if ([model.MappingStatus isEqualToString:@"3"]){// 无货
            return 130;
        }else{
            return 160;
        }

    }else{
        if ([model.MappingStatus isEqualToString:@"2"]){// 下架商品
            return 110;
        }else if ([model.MappingStatus isEqualToString:@"3"]){// 无货
            return 110;
        }else{
            return 140;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

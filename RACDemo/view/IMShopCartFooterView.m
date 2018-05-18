//
//  IMShopCartFooterView.m
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartFooterView.h"
#import "IMShopCartModel.h"

@implementation IMShopCartFooterView
{
    UILabel *_priceLabel;
    UIView  *_sepView;

}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initCartFooterView];
    }
    return self;
}

- (void)initCartFooterView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.text = @"小计:￥15.80";
    _priceLabel.font = [UIFont systemFontOfSize:13.0];
    _priceLabel.textColor = [UIColor redColor];
//    [self addSubview:_priceLabel];
    
    _sepView = [[UIView alloc] initWithFrame:CGRectZero];
    _sepView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:_sepView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _priceLabel.frame = CGRectMake(40, 0.5, kScreenWidth - 60, 30);
    _sepView.frame = CGRectMake(0, 0, kScreenWidth, 10);
}

- (void)setShopGoodsArray:(NSMutableArray *)shopGoodsArray{
    _shopGoodsArray = shopGoodsArray;
    NSArray *pricesArray = [[[_shopGoodsArray rac_sequence] map:^id(IMShopCartModel *model) {
        return @([model.ItemNumber integerValue] * [model.SPrice floatValue]);
    }] array];
    float shopPrice = 0;
    for (NSNumber *prices in pricesArray) {
        shopPrice += prices.floatValue;
    }
    _priceLabel.text = [NSString stringWithFormat:@"小计:￥%.2f",shopPrice];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CGFloat)getShopCartFooterHeight{
    return 10;
}

@end

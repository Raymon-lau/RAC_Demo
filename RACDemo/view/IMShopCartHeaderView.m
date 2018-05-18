//
//  IMShopCartHeaderView.m
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartHeaderView.h"
#import "IMShopCartModel.h"

@implementation IMShopCartHeaderView
{
    UIButton *_storeNameButton;
    UIImageView *_detailImage;
    UIView *_gotoPassView;//去凑单的view
    UIImageView *_storeIcon;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setHeaderUI];
    }
    return self;
}

- (void)setHeaderUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectStoreGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStoreGoodsButton.frame = CGRectZero;
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"shopping_cart_not_selected"]
                                 forState:UIControlStateNormal];
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"shopping_cart_selection"]
                                 forState:UIControlStateSelected];
    self.selectStoreGoodsButton.backgroundColor=[UIColor clearColor];
    [self addSubview:self.selectStoreGoodsButton];
    
    // 店铺名字
    _storeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _storeNameButton.frame = CGRectZero;
//    [_storeNameButton setImage:[UIImage imageNamed:@"mall_little_Logo"] forState:UIControlStateNormal];
    [_storeNameButton setTitle:@"店铺名字_____"
                          forState:UIControlStateNormal];
    [_storeNameButton setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
    _storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _storeNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
     _storeNameButton.titleLabel.lineBreakMode =  NSLineBreakByTruncatingTail;
    _storeNameButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
   // _storeNameButton.enabled = NO;//禁用
    _storeNameButton.userInteractionEnabled = NO;
    [self addSubview:_storeNameButton];
    
    // 店铺图标
    _storeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_little_Logo"]];
    _storeIcon.frame = CGRectZero;
    [self addSubview:_storeIcon];
    
    // 配送提示
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _tipLabel.font = [UIFont systemFontOfSize:13.0];
    _tipLabel.text = @"(满300配送)";
    _tipLabel.textColor = [UIColor redColor];
    [self addSubview:_tipLabel];
    
    _gotoPassView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth - 70, 0, 50, 30) ];
//    [self addSubview:_gotoPassView];
    _gotoPassLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _gotoPassLabel.font = [UIFont systemFontOfSize:13.0];
//    _gotoPassLabel.text = @"去凑单";
    _gotoPassLabel.textColor = [UIColor redColor];
     [_gotoPassView addSubview:_gotoPassLabel];
    
    // 去凑单
    _gotoPassaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _gotoPassaButton.frame = CGRectMake(0, 0, 50, 30);
    _gotoPassaButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _gotoPassaButton.titleLabel.textColor = [UIColor redColor];
    [_gotoPassView addSubview:_gotoPassaButton];
    
    // 详情图标
    _detailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail"]];
    [self addSubview:_detailImage];
    _headerButton = [[UIButton alloc]initWithFrame:CGRectMake(70, 0, kScreenWidth - 70 - 70, 30)];
    [_headerButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self addSubview:_headerButton];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.selectStoreGoodsButton.frame = CGRectMake(0, 0, 36, 30);
    _storeIcon.frame = CGRectMake(40, 6, 18, 18);
    _storeNameButton.frame = CGRectMake(60, 0, kScreenWidth/2 - 70, 30);
    _storeNameButton.width = 100;
    if (_storeNameButton.width >= kScreenWidth/2 - 70) {
        _storeNameButton.width = kScreenWidth/2 - 70;
    }
    _tipLabel.frame = CGRectMake(CGRectGetMaxX(_storeNameButton.frame), 0, kScreenWidth/2 - 50, 30);
    _detailImage.frame = CGRectMake(kScreenWidth - 20, 8, 10, 15);
}

- (void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    [_storeNameButton setTitle:infoDic[@"ShopName"] forState:UIControlStateNormal];
    _tipLabel.text = infoDic[@"StartOrderAmountText"];
//    [_storeNameButton rm_setImageWithString:infoDic[@"ShopLogo"]];
    _storeIcon.image = [UIImage imageNamed:infoDic[@"shopLogo"]];
    NSString *str = [NSString stringWithFormat:@"%@",infoDic[@"ShopId"]];
    [_gotoPassaButton setTitle:str forState:UIControlStateNormal];
    [_headerButton setTitle:str forState:UIControlStateNormal];
    _gotoPassView.hidden = NO;
}

+ (CGFloat)getShopCartHeaderHeight{
    return 30;
}

@end

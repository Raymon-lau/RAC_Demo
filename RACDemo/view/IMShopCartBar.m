//
//  IMShopCartBar.m
//  TXH
//
//  Created by Raymon on 2016/3/9.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartBar.h"

static NSInteger const BalanceButtonTag = 1000;

static NSInteger const DeleteButtonTag  = 1001;

static NSInteger const SelectButtonTag = 1002;

@interface UIImage (RM)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end

@implementation UIImage (RM)

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

@end

@implementation IMShopCartBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBarUI];
    }
    return self;
}

- (void)setBarUI{
    self.backgroundColor = [UIColor clearColor];
    // 背景
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.userInteractionEnabled = NO;
    effectView.frame = self.bounds;
    [self addSubview:effectView];
    
    CGFloat width = kScreenWidth * 2 / 7;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = RGB(210, 210, 210);
    [self addSubview:lineView];
    
    // 结算
    _balanceButton = [self creatButtonWithFrame:CGRectMake(kScreenWidth - width - 5, 5, width, self.frame.size.height - 10)
                                          title:@"去结算"
                                      buttonTag:BalanceButtonTag];
    [self addSubview:_balanceButton];
    
    // 删除
    _deleteButton = [self creatButtonWithFrame:CGRectMake(kScreenWidth - width - 5, 5, width, self.frame.size.height - 10)
                                         title:@"删除"
                                     buttonTag:DeleteButtonTag];
    _deleteButton.enabled = NO;
    _deleteButton.hidden = YES;
    _deleteButton.backgroundColor = [UIColor redColor];
    [self addSubview:_deleteButton];
    
    // 全选
    _selectAllButton = [self creatButtonWithFrame:CGRectMake(0, 5, 78, self.frame.size.height - 10)
                                            title:@"全选"
                                        buttonTag:SelectButtonTag];
    [_selectAllButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_selectAllButton setImage:[UIImage imageNamed:@"shopping_cart_not_selected"] forState:UIControlStateNormal];
    [_selectAllButton setImage:[UIImage imageNamed:@"shopping_cart_selection"] forState:UIControlStateSelected];
    [_selectAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self addSubview:_selectAllButton];
    
    // 价格
    _allMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 0, kScreenWidth - width * 2 - 10, self.height)];
    _allMoneyLabel.text = [NSString stringWithFormat:@"合计:￥%@",@(00.00)];
    _allMoneyLabel.font = [UIFont systemFontOfSize:15.0];
    _allMoneyLabel.textColor = [UIColor redColor];
    _allMoneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_allMoneyLabel];
    
    WEAK
    [RACObserve(self, money) subscribeNext:^(id x) {
        NSNumber *number = (NSNumber *)x;
        self.allMoneyLabel.text = [NSString stringWithFormat:@"合计:￥%.2f",number.floatValue];
    }];
    
    // RAC BLIND
    RACSignal *comBineSignal = [RACSignal combineLatest:@[RACObserve(self, money)]
                                                 reduce:^id(NSNumber *money){
                                                     if (money.floatValue == 0) {
                                                         self.selectAllButton.selected = NO;
                                                     }
                                                     return @(money.floatValue > 0);
                                                 }];
    RAC(self.balanceButton, enabled) = comBineSignal;
    RAC(self, isSelectBalance) = comBineSignal;
    RAC(self.deleteButton, enabled) = comBineSignal;
    
    [RACObserve(self, isNormalState) subscribeNext:^(id x) {
        NSNumber *number = (NSNumber *)x;
        STRONG
        BOOL isNormal = number.boolValue;
        strongSelf.balanceButton.hidden = !isNormal;
        strongSelf.allMoneyLabel.hidden = !isNormal;
        strongSelf.deleteButton.hidden = isNormal;
    }];
}

- (UIButton *)creatButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                         buttonTag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (tag != SelectButtonTag) {
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.tag = tag;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    return button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

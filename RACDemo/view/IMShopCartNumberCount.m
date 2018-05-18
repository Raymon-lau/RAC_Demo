//
//  IMShopCartNumberCount.m
//  TXH
//
//  Created by Raymon on 2016/3/13.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartNumberCount.h"

static CGFloat const widthInNumberCount = 30;

@interface IMShopCartNumberCount ()

// 加
@property (nonatomic, strong) UIButton *addButton;
// 减
@property (nonatomic, strong) UIButton *subButton;
// 数字按钮
@property (nonatomic, strong) UITextField *numberTextField;

@property (nonatomic, strong) UIButton *clickAddButton;

@property (nonatomic, strong) UIButton *clickSubButton;

@end

@implementation IMShopCartNumberCount

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self creatUI];
}

#pragma mark - set UI
- (void)creatUI{
    self.backgroundColor = [UIColor clearColor];
    self.currentCountNumber = 0;
    self.totalNum = 0;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthInNumberCount * 3, widthInNumberCount)];
    backView.backgroundColor = [UIColor clearColor];
    backView.layer.cornerRadius = 5;
    backView.layer.borderColor = [UIColor redColor].CGColor;
    backView.layer.borderWidth = 1;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    WEAK
    // 减
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, widthInNumberCount, widthInNumberCount);
    [_subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_subButton setTitle:@"-" forState:UIControlStateNormal];
    [_subButton setTitle:@"-" forState:UIControlStateDisabled];
    
    // 减的点击层
    _clickSubButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _clickSubButton.frame = CGRectMake(0, 0, widthInNumberCount, self.height - 10);
    _clickSubButton.backgroundColor = [UIColor clearColor];
    _clickSubButton.tag = 2;

    [[self.clickSubButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        strongSelf.currentCountNumber --;
        if (strongSelf.currentCountNumber <= 0) {
//            [RMUtils showMessage:STR_ALERT_SHOPCART_CANNOTSUB];
            strongSelf.currentCountNumber = 1;
        }
        if (strongSelf.IMShopCartNumberChangeBlock) {
            strongSelf.IMShopCartNumberChangeBlock(self.currentCountNumber, IMShopCartNumberChangeTypeSub);
        }
    }];
    [backView addSubview:_subButton];
    [self addSubview:_clickSubButton];
    
    // 内容
    self.numberTextField = [[UITextField alloc] init];
    self.numberTextField.frame = CGRectMake(CGRectGetMaxX(_subButton.frame), 0, widthInNumberCount, _subButton.frame.size.height);
    self.numberTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.numberTextField.text=[NSString stringWithFormat:@"%@",@(0)];
    self.numberTextField.backgroundColor = [UIColor whiteColor];
    self.numberTextField.textColor = [UIColor greenColor];
    self.numberTextField.adjustsFontSizeToFitWidth = YES;
    self.numberTextField.textAlignment=NSTextAlignmentCenter;
    self.numberTextField.tintColor = [UIColor magentaColor];
    self.numberTextField.layer.borderColor = [UIColor redColor].CGColor;
    self.numberTextField.layer.borderWidth = 1;
    self.numberTextField.font= [UIFont systemFontOfSize:17.0];
    [backView addSubview:self.numberTextField];
    
    // 加
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberTextField.frame), 0, widthInNumberCount, widthInNumberCount);
    
    [_addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_addButton setTitle:@"+" forState:UIControlStateNormal];
    [_addButton setTitle:@"+" forState:UIControlStateDisabled];
    
    // 加的点击层
    _clickAddButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _clickAddButton.frame = CGRectMake(CGRectGetMaxX(_numberTextField.frame), 0, self.width - CGRectGetMaxX(_numberTextField.frame), self.height - 10);
    _clickAddButton.backgroundColor = [UIColor clearColor];
    _clickAddButton.tag = 3;
    [[self.clickAddButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG
        strongSelf.currentCountNumber ++;
        if (strongSelf.currentCountNumber >= 999) {
//            [RMUtils showMessage:STR_ALERT_SHOPCART_CANNOTADD];
            strongSelf.currentCountNumber = 999;
        }
        if (strongSelf.IMShopCartNumberChangeBlock) {
            strongSelf.IMShopCartNumberChangeBlock(self.currentCountNumber, IMShopCartNumberChangeTypeAdd);
        }
    }];
    [backView addSubview:_addButton];
    [self addSubview:_clickAddButton];
    
    // 内容改变
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.numberTextField] subscribeNext:^(NSNotification *x) {
        STRONG
        UITextField *textField = [x object];
        NSString *text = textField.text;
        NSInteger changeNum = 0;
        if (text.integerValue > strongSelf.totalNum && self.totalNum != 0) {
            strongSelf.currentCountNumber = strongSelf.totalNum;
            strongSelf.numberTextField.text = [NSString stringWithFormat:@"%@",@(strongSelf.totalNum)];
            changeNum = strongSelf.totalNum;
        }else if (text.integerValue < 1){
            strongSelf.numberTextField.text = @"1";
            changeNum = 1;
        }else{
            strongSelf.currentCountNumber = text.integerValue;
            changeNum = strongSelf.currentCountNumber;
        }
        if (strongSelf.IMShopCartNumberChangeBlock) {
            strongSelf.IMShopCartNumberChangeBlock(changeNum, IMShopCartNumberChangeTypeInput);
        }
    }];
    
    // 捆绑加减的enable
    RACSignal *subSignal = [RACObserve(self, currentCountNumber) map:^id(NSNumber * subvalue) {
        return @(subvalue.integerValue > 0);
    }];
    RACSignal *addSignal = [RACObserve(self, currentCountNumber) map:^id(NSNumber * addvalue) {
        return @(addvalue.integerValue < self.totalNum + 1);
    }];
    RAC(self.subButton, enabled) = subSignal;
    RAC(self.addButton, enabled) = addSignal;
    
    // 内容颜色显示
    RACSignal *numColorSignal = [RACObserve(self, totalNum) map:^id(NSNumber * totalvalue) {
        return  totalvalue.integerValue == 0 ? [UIColor redColor] : [UIColor blackColor];
    }];
    RAC(self.numberTextField, textColor) = numColorSignal;
    
    RACSignal *textSigal = [RACObserve(self, currentCountNumber) map:^id(NSNumber * value) {
        return [NSString stringWithFormat:@"%@",value];
    }];
    RAC(self.numberTextField, text) = textSigal;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

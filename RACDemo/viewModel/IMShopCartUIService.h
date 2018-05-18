//
//  IMShopCartUIService.h
//  TXH
//
//  Created by Raymon on 2016/3/9.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMShopCartViewModel;
@protocol IMShopCartUIServiceDelegate <NSObject>

- (void)shopCartUIServiceButtonDidClick:(UIButton *)sender;

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface IMShopCartUIService : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IMShopCartViewModel *viewModel;

@property (nonatomic, copy) NSString *proUserId;


@property (nonatomic, assign) BOOL isNormalState;

@property (weak, nonatomic) id <IMShopCartUIServiceDelegate> delegate;

@end 

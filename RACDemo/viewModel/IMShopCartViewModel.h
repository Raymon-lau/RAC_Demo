//
//  IMShopCartViewModel.h
//  TXH
//
//  Created by Raymon on 2016/3/9.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IMShopCartController, IMReplaceCartController;
@interface IMShopCartViewModel : NSObject

@property (nonatomic, weak) UIViewController    *cartVC;

@property (nonatomic, weak) IMReplaceCartController *replaceCarVC;

@property (nonatomic, strong) NSMutableArray        *cartData;

@property (nonatomic, weak) UITableView             *cartTableView;

@property (nonatomic, strong) NSMutableArray        *shopCartData;

@property (nonatomic, copy) NSString                *proUserId;

//@property (nonatomic, assign) BOOL                  isEdit;

@property (nonatomic, assign) BOOL                  isReplaceCart;

// carbar 属性变化
@property (nonatomic, assign) float                 allPrices;

// 全选状态
@property (nonatomic, assign) BOOL                  isSelectAll;

// 购物车商品数量
@property (nonatomic, assign) NSInteger             cartGoodsCount;

// 当前所选商品数量
@property (nonatomic, assign) NSInteger             currentSelectedCartGoodsCount;

// 存放店铺选中
@property (nonatomic, strong) NSMutableArray        *shopSelectArray;

// 存放店铺基本信息
@property (nonatomic, strong) NSMutableArray        *shopInfoArray;

// 存放购物车所有信息
@property (nonatomic, strong) NSDictionary          *shopCartAllDataDic;

// 删除选中的商品
- (void)deleteGoodsBySelect;

// 删除当前滑动的商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)indexPath;

// 获取数据
- (void)getData;

// 获取代下单数据
- (void)getReplaceData;

// 获取价格总和
- (float)getAllPrices;

// 获取当前所选购物车数量
- (void)getCurrentShopCartNumberAtSection:(NSUInteger)section;

// 选择店铺时重置当前购物车shul
- (void)resentCurrentShopCartNumberAtSection:(NSUInteger)section isSelect:(BOOL)isSelect;

// 选中某行
- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath;

// 改变某行的价格
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath;

// 选择所有商品
- (void)selectAll:(BOOL)isSelect;

// 结算当前选中商品
- (void)balanceAccountsSuccess:(void(^)(id response))success;

// 恢复选中状态
- (void)recoverSelectedStatus;

@property (copy, nonatomic) NSString *ShopItems;

@end

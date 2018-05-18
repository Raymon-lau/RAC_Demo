//
//  IMShopCartViewModel.m
//  TXH
//
//  Created by Raymon on 2016/3/9.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartViewModel.h"
#import "IMShopCartModel.h"

@interface IMShopCartViewModel (){
    NSArray *_shopGoodsCount;       // 店铺商品数量
    NSArray *_goodsPicArray;        // 商品图片
    NSArray *_goodsPriceArray;      // 商品价格
    NSArray *_goodsQuantityArray;   // 商品数量
    NSString *_selectShopItem;
}
@property (strong, nonatomic) NSMutableDictionary *cartDict;
@end

@implementation IMShopCartViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cartData = [NSMutableArray array];
        self.shopCartData = [NSMutableArray array];
        self.shopInfoArray = [NSMutableArray array];
        self.shopCartAllDataDic = [NSDictionary dictionary];
    }
    return self;
}

- (NSInteger)random{
    NSInteger from  = 0;
    NSInteger to    = 5;
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - make data
- (void)requestshopCartDataSuccess:(void(^)(NSArray *array,NSDictionary *dictionary))success{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"modelData" ofType:@"plist"];
    NSDictionary *objDic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.shopCartAllDataDic = objDic;
    NSArray *shopListList = objDic[@"ShopList"];
    success(shopListList,objDic);
    [self.cartTableView reloadData];
}

- (void)getData{
    [self requestshopCartDataSuccess:^(NSArray *array, NSDictionary *objDic) {
        // 店铺数据个数
        NSInteger allCount = array.count;
        NSInteger allGoodsCount = 0;
        NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
        NSMutableArray *shopSelectArray = [NSMutableArray arrayWithCapacity:allCount];
        // 创造店铺数据
        for (int i = 0; i < allCount; i ++) {
            NSDictionary *dictionary = array[i];
            NSArray *itemList = dictionary[@"ItemList"];
            NSDictionary *infoDictionary = dictionary[@"ShopInfo"];
            // 创造店铺下商品数据
            NSInteger goodsCount = [itemList count];
            NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:goodsCount];
            for (int x = 0; x < goodsCount; x ++) {
                NSDictionary *itemDic = itemList[x];
                IMShopCartModel *cartModel = [IMShopCartModel modelWithDictionary:itemDic];
                [goodsArray addObject:cartModel];
                allGoodsCount += [cartModel.ItemNumber integerValue];
            }
            [storeArray addObject:goodsArray];
            [shopSelectArray addObject:infoDictionary[@"IsSelected"]];
            [self.shopInfoArray addObject:infoDictionary];
        }
        self.cartData = storeArray;
        self.shopSelectArray = shopSelectArray;
        self.cartGoodsCount = allGoodsCount;
        self.currentSelectedCartGoodsCount = 0;
        self.allPrices = 0.00;
        if (self.cartData.count) {
            [self.cartDict setObject:@"1" forKey:@"cart"];
        }else {
             [self.cartDict setObject:@"0" forKey:@"cart"];
        }
    }];
}


- (float)getAllPrices{
    __block float allPrices     = 0;
    NSInteger shopCount         = self.cartData.count;
    NSInteger shopSelectCount   = self.shopSelectArray.count;
    if (shopSelectCount == shopCount && shopCount != 0) {
        self.isSelectAll = YES;
    }
    NSArray *pricesArray = [[[self.cartData rac_sequence] map:^id(NSArray *value) {
        return [[[value rac_sequence] filter:^BOOL(IMShopCartModel *model) {
            if (!model.isSelect) {
                self.isSelectAll = NO;
            }
            return model.isSelect;
        }] map:^id(IMShopCartModel *model) {
                return @([model.ItemNumber integerValue] * [model.SPrice floatValue]);
        }];
    }] array];
    for (NSArray *prices in pricesArray) {
        for (NSNumber *price in prices) {
            allPrices += price.floatValue;
        }
    }
    return allPrices;
}

- (void)getCurrentShopCartNumberAtSection:(NSUInteger)section{
    NSMutableArray *goodsArray  = self.cartData[section];
    for (IMShopCartModel *model in goodsArray) {
        if (model.isSelect) {
            self.currentSelectedCartGoodsCount += [model.ItemNumber integerValue];
        }else{
            // 添加判断是否下架/无货    "MappingStatus": "1",//商品状态（1正常，2下架，3无货）
            if ([model.MappingStatus integerValue] == 1) {
                self.currentSelectedCartGoodsCount -= [model.ItemNumber integerValue];
            }
        }
    }
}

- (void)resentCurrentShopCartNumberAtSection:(NSUInteger)section isSelect:(BOOL)isSelect{
    NSMutableArray *goodsArray  = self.cartData[section];
    for (IMShopCartModel *model in goodsArray) {
        if (isSelect) {
            if (model.isSelect && [model.MappingStatus integerValue] == 1) {
                self.currentSelectedCartGoodsCount -= [model.ItemNumber integerValue];
            }
        }
    }
}

- (void)selectAll:(BOOL)isSelect{
    __block float allPrices = 0;
    __block NSInteger goodsNum = 0;
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
        return @(isSelect);
    }] array] mutableCopy];
    self.cartData = [[[[self.cartData rac_sequence] map:^id(NSMutableArray * value) {
        return [[[[value rac_sequence] map:^id(IMShopCartModel *model) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
            if (model.isSelect && [model.MappingStatus isEqualToString:@"1"]) {
                allPrices += [model.ItemNumber integerValue] * [model.SPrice floatValue];
                goodsNum += [model.ItemNumber integerValue];
            }
            return model;
        }] array] mutableCopy];
    }] array] mutableCopy];
    self.allPrices = allPrices;
    isSelect ? (self.currentSelectedCartGoodsCount = goodsNum) : (self.currentSelectedCartGoodsCount = 0);
    [self.cartTableView reloadData];
}

- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath{
    NSInteger section           = indexPath.section;
    NSInteger row               = indexPath.row;
    
    NSMutableArray *goodsArray  = self.cartData[section];
    NSInteger shopCount         = goodsArray.count;
    IMShopCartModel *model      = goodsArray[row];
    [model setValue:@(isSelect) forKey:@"isSelect"];
    NSInteger goodsNum = [model.ItemNumber integerValue];
    isSelect ? (self.currentSelectedCartGoodsCount += goodsNum) : (self.currentSelectedCartGoodsCount -= goodsNum);
    // 判断是否到达足够数量
    NSInteger isSelectShopCount = 0;
    for (IMShopCartModel *model in goodsArray) {
        if (model.isSelect) {
            isSelectShopCount ++;
        }
    }
    [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount == shopCount ? YES : NO)];
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    // 重新计算价格
    self.allPrices = [self getAllPrices];
}

- (void)recoverSelectedStatus{
    __block float allPrices = 0;
    __block NSInteger goodsNum = 0;
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
        return @(NO);
    }] array] mutableCopy];
    self.cartData = [[[[self.cartData rac_sequence] map:^id(NSMutableArray * value) {
        return [[[[value rac_sequence] map:^id(IMShopCartModel *model) {
            [model setValue:@(NO) forKey:@"isSelect"];
            if (model.isSelect && [model.MappingStatus isEqualToString:@"1"]) {
                allPrices += [model.ItemNumber integerValue] * [model.SPrice floatValue];
                goodsNum += [model.ItemNumber integerValue];
            }
            return model;
        }] array] mutableCopy];
    }] array] mutableCopy];
    self.allPrices = allPrices;
    self.currentSelectedCartGoodsCount = 0;
    [self.cartTableView reloadData];
}

- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath{
    NSInteger section           = indexPath.section;
    NSInteger row               = indexPath.row;
    
    IMShopCartModel *model = self.cartData[section][row];
    if (model.isSelect) self.currentSelectedCartGoodsCount -= [model.ItemNumber integerValue];
    [model setValue:@(quantity) forKey:@"ItemNumber"];
    if (model.isSelect) self.currentSelectedCartGoodsCount += [model.ItemNumber integerValue];
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    // 重新计算价格
    self.allPrices = [self getAllPrices];
}

// 左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)indexPath{
    NSInteger section           = indexPath.section;
    NSInteger row               = indexPath.row;
    
    NSMutableArray *shopArray = self.cartData[section];
    if (shopArray.count == 0) {
        // 删除数据
        [self.cartData removeObjectAtIndex:section];
        // 删除 shopSelectArray
        [self.shopSelectArray removeObjectAtIndex:section];
        [self.cartTableView reloadData];
        if (self.cartData.count) {
            [self.cartDict setObject:@"1" forKey:@"cart"];
        }else {
            [self.cartDict setObject:@"0" forKey:@"cart"];
        }
//        [[NSNotificationCenter defaultCenter]postNotificationName:kIMShopCartControllerEmptyNotification object:nil userInfo:self.cartDict];
//        [[NSNotificationCenter defaultCenter]postNotificationName:kIMReplaceCartControllerEmptyNotification object:nil userInfo:self.cartDict];
    }else{
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
    IMShopCartModel *model      = shopArray[row];
    
    self.cartGoodsCount -= [model.ItemNumber integerValue];
    
    // 重新计算价格
    self.allPrices = [self getAllPrices];
}

// 选择删除
- (void)deleteGoodsBySelect{
    NSString *delectItem = [self handleDelectDataForRequest];
//    NSDictionary *content = @{@"CartIds":delectItem,@"ActionVersion":ACTIONVERSION,@"IsActionTest":ACTION_TEST};// @"ShopItems":delectItem
//    NSDictionary *param = [RMRequestTools ParamNetWithRGuid:URL_KEY_MALL_REMOVEITEMSFROMCART Content:content isAddressMessage:YES];
//    [RMRequestManager postNetWithUrl:kRequestHeadNetURL params:param success:^(id response) {
//        NSLog(@"%@",response);
//        [self deleteSelectedData];
//    } failure:nil];

}

- (void)deleteSelectedData{
    // 删除数据
    NSInteger index1 = -1;
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    for (NSMutableArray *shopArray in self.cartData) {
        index1 ++;
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for (IMShopCartModel *model in shopArray) {
            index2 ++;
            if (model.isSelect) {
                [selectIndexSet addIndex:index2];
            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        if (selectCount == shopCount) {
            [shopSelectIndex addIndex:index1];
            self.cartGoodsCount -= selectCount;
        }
        [shopArray removeObjectsAtIndexes:selectIndexSet];
    }
    [self.cartData removeObjectsAtIndexes:shopSelectIndex];
    // 2.删除
    [self.shopSelectArray removeObjectsAtIndexes:shopSelectIndex];
    
    [self.cartTableView reloadData];
    // 3.carbar 回复默认
    self.allPrices = 0;
    // 重新计算价格
    self.allPrices = [self getAllPrices];
    if (self.cartData.count) {
        [self.cartDict setObject:@"1" forKey:@"cart"];
    }else {
        [self.cartDict setObject:@"0" forKey:@"cart"];
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:kIMShopCartControllerEmptyNotification object:nil userInfo:self.cartDict];
//    [[NSNotificationCenter defaultCenter]postNotificationName:kIMReplaceCartControllerEmptyNotification object:nil userInfo:self.cartDict];
}
// 结算
- (void)balanceAccountsSuccess:(void (^)(id))success{
    NSString *shopItem = [self handleSelectDataForRequest];
    _selectShopItem = shopItem;
    NSDictionary *content = [NSDictionary dictionary];
}
//删除需要的数据结构model.ShopId_model.SkuId
- (NSString *)handleDelectDataForRequest{
    NSInteger index1 = -1;
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    NSMutableArray *goodsArray = [NSMutableArray array];
    for (NSMutableArray *shopArray in self.cartData) {
        index1 ++;
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for (IMShopCartModel *model in shopArray) {
            index2 ++;
            if (model.isSelect) {
                [selectIndexSet addIndex:index2];
            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        if (selectCount == shopCount) {
            [shopSelectIndex addIndex:index1];
            self.cartGoodsCount -= selectCount;
        }
        NSArray *array = [[shopArray objectsAtIndexes:selectIndexSet] mutableCopy];
        [goodsArray addObjectsFromArray:array];
    }
//    NSLog(@"%@",goodsArray);
    NSMutableArray *muArray = [NSMutableArray array];
    [goodsArray enumerateObjectsUsingBlock:^(IMShopCartModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *string = [NSString stringWithFormat:@"%@_%@",model.ShopId,model.SkuId];
        NSString *string = [NSString stringWithFormat:@"%@",model.CartId];
        [muArray addObject:string];
    }];
//    NSLog(@"%@",muArray);
    NSString *shopItem = [muArray componentsJoinedByString:@","];
    return shopItem;
}

- (NSString *)handleSelectDataForRequest{
    NSInteger index1 = -1;
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    NSMutableArray *goodsArray = [NSMutableArray array];
    for (NSMutableArray *shopArray in self.cartData) {
        index1 ++;
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for (IMShopCartModel *model in shopArray) {
            index2 ++;
            if (model.isSelect && [model.MappingStatus isEqualToString:@"1"]) {
                [selectIndexSet addIndex:index2];
            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        if (selectCount == shopCount) {
            [shopSelectIndex addIndex:index1];
            self.cartGoodsCount -= selectCount;
        }
        NSArray *array = [[shopArray objectsAtIndexes:selectIndexSet] mutableCopy];
        [goodsArray addObjectsFromArray:array];
    }
//    NSLog(@"%@",goodsArray);
    NSMutableArray *muArray = [NSMutableArray array];
    [goodsArray enumerateObjectsUsingBlock:^(IMShopCartModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSString *string = [NSString stringWithFormat:@"%@_%@~%@",model.ShopId,model.SkuId,model.ItemNumber];
        NSString *string = [NSString stringWithFormat:@"%@",model.CartId];
        [muArray addObject:string];
    }];
    NSLog(@"%@",muArray);
    NSString *shopItem = [muArray componentsJoinedByString:@","];
    return shopItem;
}

- (NSString *)ShopItems {
    return _selectShopItem;
}

- (NSMutableDictionary *)cartDict {
    if (_cartDict) {
        return _cartDict;
    }
    _cartDict = [NSMutableDictionary dictionary];
    return _cartDict;
}
@end

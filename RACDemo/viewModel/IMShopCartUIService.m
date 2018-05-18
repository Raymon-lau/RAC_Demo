//
//  IMShopCartUIService.m
//  TXH
//
//  Created by Raymon on 2016/3/9.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartUIService.h"
#import "IMShopCartViewModel.h"
#import "IMShopCartHeaderView.h"
#import "IMShopCartFooterView.h"
#import "IMShopCartModel.h"
#import "IMShopCartCell.h"
#import "IMShopCartNumberCount.h"

@implementation IMShopCartUIService

#pragma mark - UITableView Delegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.cartData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IMShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMShopCartCell"
                                                           forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(IMShopCartCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    IMShopCartModel *model = self.viewModel.cartData[section][row];
    // cell选中
    WEAK
    [[[cell.selectShopGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        UIButton *button = (UIButton *)x;
        STRONG
        button.selected = !button.selected;
        [strongSelf.viewModel rowSelect:button.selected IndexPath:indexPath];
    }];
    // 数量改变
    cell.numberCount.IMShopCartNumberChangeBlock = ^(NSInteger changeCount, IMShopCartNumberChangeType type){
        STRONG
        [strongSelf changeCartNumberWithShopModel:model
                                  changeNum:changeCount
                                       Type:type
                                    Success:^{
            [strongSelf.viewModel rowChangeQuantity:changeCount indexPath:indexPath];
        }];
    };
    [RACObserve(self, isNormalState) subscribeNext:^(id x) {
        NSNumber *number = (NSNumber *)x;
        BOOL isNormal = number.boolValue;
        cell.isEdit = !isNormal;
        // 是否显示购物车数量标签
//        [model.MappingStatus isEqualToString:@"1"] ? (cell.numberCount.hidden = isNormal): (cell.numberCount.hidden = YES);
//        [model.MappingStatus isEqualToString:@"1"] ? (cell.showCartNum.hidden = !isNormal): (cell.showCartNum.hidden = YES);
    }];
    cell.model = model;
}

- (void)changeCartNumberWithShopModel:(IMShopCartModel *)model
                            changeNum:(NSInteger)changeNum
                                 Type:(IMShopCartNumberChangeType)type
                              Success:(void(^)(void))success{
    success();

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    IMShopCartModel *model = self.viewModel.cartData[section][row];
    return [IMShopCartCell getCartCellHeightWith:model];
}

#pragma mark - headerView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [IMShopCartHeaderView getShopCartHeaderHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableArray *shopArray = self.viewModel.cartData[section];
    IMShopCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"IMShopCartHeaderView"];
    headerView.infoDic = self.viewModel.shopInfoArray[section];
    // 店铺全选
    [[[headerView.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(id x) {
        UIButton *button = (UIButton *)x;
        button.selected = !button.selected;
        BOOL isSelect = button.selected;
        [self.viewModel resentCurrentShopCartNumberAtSection:section isSelect:isSelect];
        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
        for (IMShopCartModel *model in shopArray) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
        }
        [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [self.viewModel getCurrentShopCartNumberAtSection:section];
        self.viewModel.allPrices = [self.viewModel getAllPrices];
    }];
    //去凑单
    [headerView.gotoPassaButton addTarget:self action:@selector(gotoPassaButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    // 店铺选择状态
    [headerView.headerButton addTarget:self action:@selector(gotoPassaButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    headerView.selectStoreGoodsButton.selected = [self.viewModel.shopSelectArray[section] boolValue];
    [self headerView:headerView judgeDeliveryPriceWith:shopArray insection:section];
    return headerView;
}

- (void)gotoPassaButtonDidClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(shopCartUIServiceButtonDidClick:)]) {
        [self.delegate shopCartUIServiceButtonDidClick:sender];
    }
}
#pragma mark - footerView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [IMShopCartFooterView getShopCartFooterHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSMutableArray *shopArray = self.viewModel.cartData[section];
    IMShopCartFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"IMShopCartFooterView"];
//    footerView.shopGoodsArray = shopArray;
    return footerView;
}

#pragma mark - delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel deleteGoodsBySingleSlide:indexPath];
    }
}

#pragma mark - judgeDeliveryPrice
- (void)headerView:(IMShopCartHeaderView *)headerView
judgeDeliveryPriceWith:(NSArray *)shopArray
         insection:(NSInteger)section{
    NSArray *pricesArray = [[[shopArray rac_sequence] map:^id(IMShopCartModel *model) {
        return model.isSelect ? @([model.ItemNumber integerValue] * [model.SPrice floatValue]) : @(0);
    }] array];
    float shopPrice = 0;
    for (NSNumber *prices in pricesArray) {
        shopPrice += prices.floatValue;
    }
    IMShopCartModel *cartModel = [shopArray firstObject];
    if (shopPrice >= [cartModel.StartOrderAmount floatValue]) {
//        NSLog(@"配送价够了");
        headerView.tipLabel.hidden = YES;
        headerView.gotoPassLabel.hidden = YES;
    }else{
        headerView.tipLabel.hidden = NO;
        headerView.gotoPassLabel.hidden = NO;
    }
}


@end

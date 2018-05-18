//
//  IMShopCartFooterView.h
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMShopCartFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSMutableArray *shopGoodsArray;

// footview高度
+ (CGFloat)getShopCartFooterHeight;

@end

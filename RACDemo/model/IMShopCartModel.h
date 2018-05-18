//
//  IMShopCartModel.h
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMShopCartModel : NSObject
/**
 *  商品model
 */
@property (nonatomic, strong) NSString  *SkuId;

@property (nonatomic, strong) NSString  *ItemName;

@property (nonatomic, strong) NSString  *ItemPic;

@property (nonatomic, copy) NSString *SPrice;

@property (nonatomic, copy) NSString *SkuProp;

@property (nonatomic, copy) NSString *ItemNumber;

@property (nonatomic, copy) NSString *ItemTotalAmount;

@property (nonatomic, copy) NSString *MappingStatus;

@property (nonatomic, copy) NSString *goodsIsSelected;

@property (nonatomic, copy) NSString *CartId;

@property (nonatomic, copy) NSString *ActivityRemark;

@property (nonatomic, copy) NSString *ActivityTypeId;

@property (nonatomic, copy) NSString *ActivityId;

@property (nonatomic, copy) NSString *ActivityRemarkIcon;

@property (nonatomic, copy) NSString *DDDJIcon;

@property (nonatomic, copy) NSString *IsReplaceOrder;

@property (nonatomic, copy) NSString *OldPrice;

@property (nonatomic, copy) NSString *Discount;




/**
 *  店铺model
 */
@property (nonatomic, copy) NSString *ShopId;

@property (nonatomic, copy) NSString *ShopName;

@property (nonatomic, copy) NSString *ShopLogo;

@property (nonatomic, copy) NSString *StartOrderAmount;

@property (nonatomic, copy) NSString *StartOrderAmountText;

@property (nonatomic, copy) NSString *IsNeedAddItem;

@property (nonatomic, copy) NSString *shopIsSelected;

@property (nonatomic, copy) NSString *OffShelveImage;

@property (nonatomic, copy) NSString *OffShelveText;

@property (nonatomic, copy) NSString *OutOfStockImage;

@property (nonatomic, copy) NSString *OutOfStockText;

@property (nonatomic, copy) NSString *NeedAddItemText;



//商品是否被选中
@property (nonatomic, assign) BOOL      isSelect;

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

@end

//
//  IMShopCartModel.m
//  TXH
//
//  Created by Raymon on 2016/3/10.
//  Copyright © 2016年 tianxiahuo. All rights reserved.
//

#import "IMShopCartModel.h"

@implementation IMShopCartModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    IMShopCartModel *model = [[IMShopCartModel alloc] init];
    [model setValuesForKeysWithDictionary:dictionary];
    return model;
}

@end

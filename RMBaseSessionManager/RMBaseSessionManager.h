//
//  RMBaseSessionManager.h
//  RMBaseSessionManager
//
//  Created by Raymon on 2018/5/20.
//  Copyright © 2018年 Raymon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "RACSignal.h"
#import "AFNetworking.h"

typedef void (^ResultBlock)(NSString *str);

typedef NS_ENUM(NSInteger, HTTPMethodType){
    HTTPMethodTypeGET = 0,
    HTTPMethodTypePOST,
    HTTPMethodTypePUT,
};

@interface RMBaseSessionManager : AFHTTPSessionManager

@property (nonatomic, copy) ResultBlock resBlock;
+ (RMBaseSessionManager *)sharedInstance;

- (RACSignal *)HTTPRequeatHttpMed:(HTTPMethodType)method URLStr:(NSString *)url Params:(NSDictionary *)params;

@end

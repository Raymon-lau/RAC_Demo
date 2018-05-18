//
//  RMBaseSessionManager.m
//  RMBaseSessionManager
//
//  Created by Raymon on 2018/5/20.
//  Copyright © 2018年 Raymon. All rights reserved.
//

#import "RMBaseSessionManager.h"
#import "RACSubscriber.h"
#import "RACDisposable.h"
#import "RACSignal.h"
#import "RACSignal+Operations.h"


@implementation RMBaseSessionManager

+ (RMBaseSessionManager *)sharedInstance
{
    static RMBaseSessionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RMBaseSessionManager alloc] init];
    });
    return instance;
}

- (RACSignal *)HTTPRequeatHttpMed:(HTTPMethodType)method URLStr:(NSString *)url Params:(NSDictionary *)params{
    if (method == HTTPMethodTypeGET) {
        RACSignal *requestSignal =[self rac_getRequestWith:url params:params];
        return [self handleErrorWithSignal:requestSignal];
    }else if (method == HTTPMethodTypePOST){
        RACSignal *requestSignal = [self rac_postRequestWith:url params:params];
        return [self handleErrorWithSignal:requestSignal];
    }else if(method == HTTPMethodTypePUT){
        RACSignal *requestSignal = [self rac_putRequestWith:url params:params];
        [self handleErrorWithSignal:requestSignal];
    }
    return nil;
}

- (RACSignal *)rac_getRequestWith:(NSString *)url params:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功:%@",responseObject);
            NSArray *dictArray = responseObject[@"books"];
            [subscriber sendNext:dictArray];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败:%@",error);
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)rac_postRequestWith:(NSString *)url params:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功:%@",responseObject);
            NSArray *dictArray = responseObject[@"books"];
            [subscriber sendNext:dictArray];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败:%@",error);
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

// 其实可以全用这个接口去请求,只要修改@"get"即可,但是由于项目服务端接口格式问题,我们项目的post接口格式af暂时提示无法支持,所以这里就单独写了,大家可以自行测试下
- (RACSignal *)rac_putRequestWith:(NSString *)url params:(NSDictionary *)params{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json", nil];
        manager.requestSerializer.timeoutInterval = 10.0f;
        NSURLSessionTask *op = [manager dataTaskWithRequest:[self.requestSerializer requestWithMethod:@"get" URLString:url parameters:params error:nil] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"---%@++++%@",response,responseObject);
            if (error) {
                NSLog(@"error");
                [subscriber sendError:error];
            }else{
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            }
            
        }];
        [op resume];
        return [RACDisposable disposableWithBlock:^{
            [op cancel];
        }];
        
        
    }];
}

- (RACSignal *)handleErrorWithSignal:(RACSignal *)requestSignal{
    return [requestSignal catch:^RACSignal *(NSError *error) {
        NSInteger code = error.code;
        NSLog(@"%ld",code);
        if (code < 0) {
            code = labs(code);
        }
        RACSignal *errorSignal;
        
        return errorSignal;

    }];
}


@end

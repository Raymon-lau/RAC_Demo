//
//  ViewController.m
//  RMBaseSessionManager
//
//  Created by Raymon on 2018/5/20.
//  Copyright © 2018年 Raymon. All rights reserved.
//

#import "ViewController.h"
#import "RMBaseSessionManager.h"
#import "ReactiveCocoa.h"
#import "ReactiveObjC.h"
#import "RACReturnSignal.h"
#import "RACStream.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.//
    
#pragma 1  signal
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 发送信号
        [subscriber sendNext:@"发送信号"];
        return nil;
    }];
    
    // 订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"信号内容:%@",x);
    }];
    
    
//    //把信号转化为连接类
//    RACMulticastConnection *multicastConnection =  [signal publish];
//
//    //订阅连接类信号
//    [multicastConnection.signal subscribeNext:^(id x) {
//        NSLog(@"连接类1%@",x);
//    }];
//
//    [multicastConnection.signal subscribeNext:^(id x) {
//        NSLog(@"连接类2%@",x);
//    }];
//
//
//    [multicastConnection.signal subscribeNext:^(id x) {
//        NSLog(@"连接类3%@",x);
//    }];
//    //连接
//    [multicastConnection connect];
    
#pragma 2   RACSubject
    /* 创建信号 */
    RACSubject *subject = [RACSubject subject];
    
    /* 发送信号 */
    [subject sendNext:@"发送信号"];
    
    /* 订阅信号（通常在别的视图控制器中订阅，与代理的用法类似） */
    [subject subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"信号内容：%@", x);
    }];
    
    
#pragma 3  RAC 的元祖，跟我们 OC 的数组其实是一样的，它其实就是封装了我们 OC 的数组
    /* 创建元祖 */
    RACTuple *tuple = [RACTuple tupleWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    
    /* 从别的数组中获取内容 */
    RACTuple *TempTuple = [RACTuple tupleWithObjectsFromArray:@[@"a",@"b",@"c"]];
    
    /* 利用 RAC 宏快速封装 */
    RACTuple *newTuple = RACTuplePack(@"10", @"20", @"30", @"40", @"50");
    
    NSLog(@"取元祖内容：%@---%@", tuple,tuple[0]);
    NSLog(@"第一个元素：%@---%@", TempTuple,[TempTuple first]);
    NSLog(@"最后一个元素：%@---%@", newTuple,[newTuple last]);
    
#pragma 4 遍历array和dictionary可以省去使用 for 循环来遍历
    /* 遍历数组 */
    NSArray *array = @[@"1", @"2", @"3", @"4", @"5"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"数组内容：%@", x); // x 可以是任何对象
    }];
    
    /* 遍历字典 */
    NSDictionary *dictionary = @{@"key1":@"value1", @"key2":@"value2", @"key3":@"value3"};
    [dictionary.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        
        RACTupleUnpack(NSString *key, NSString *value) = x; // x 是一个元祖，这个宏能够将 key 和 value 拆开
        NSLog(@"字典内容：%@:%@", key, value);
    }];
   
    // 替换数据
    /* 内容操作 */
    NSArray *array1 = @[@"1", @"2", @"3", @"4", @"5"];
    NSArray *newArray1 = [[array.rac_sequence map:^id _Nullable(id  _Nullable value) {
        
        NSLog(@"数组内容：%@", value);
        
        return @"0"; // 将所有内容替换为 0
        
    }] array];
    
    /* 内容快速替换 */
    NSArray *array2 = @[@"1", @"2", @"3", @"4", @"5"];
    NSArray *newArray2 = [[array.rac_sequence mapReplace:@"0"] array]; // 将所有内容替换为 0
    
#pragma 5 监听textfield状态
    // 监测textField输入状态
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 600, 100, 50)];
    UITextField *textField2 = [[UITextField alloc] initWithFrame:CGRectMake(50, 650, 100, 50)];

    textField.placeholder = @"输入框";
    textField2.placeholder = @"输入框2";
    /** flattenMap*/
    [[textField.rac_textSignal flattenMap:^__kindof RACSignal * _Nullable(NSString * _Nullable value) {
        // 监测输入框变化
        return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
    }] subscribeNext:^(id  _Nullable x) {
        // 当输入框变化的时候回调
        NSLog(@"----%@",x);
    }];
    
    /** map*/
    [[textField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return [NSString stringWithFormat:@"信号内容: %@",value];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"+++++%@",x);
    }];
    
    [self.view addSubview:textField];
    [self.view addSubview:textField2];
    
#pragma 6 button的点击事件
    UIButton *getButton = [UIButton buttonWithType:UIButtonTypeSystem];
    getButton.frame = CGRectMake(50, 550, 100, 50);
    getButton.backgroundColor = [UIColor redColor];
    [getButton setTitle:@"get" forState:UIControlStateNormal];
    [[getButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        RACSignal *signal = [[RMBaseSessionManager sharedInstance] HTTPRequeatHttpMed:HTTPMethodTypeGET URLStr:@"https://api.douban.com/v2/book/search" Params:@{@"q":textField.text}];
        [signal subscribeNext:^(id  _Nullable x) {
            NSLog(@"--------%@",x);
            [getButton setTitle:@"请求成功" forState:UIControlStateNormal];
        }];
    }];
    [self.view addSubview:getButton];
    
#pragma 7 属性/状态的实时监听
    RAC(getButton, enabled) = [RACSignal combineLatest:@[textField.rac_textSignal, textField2.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password){
        return @(username.length && password.length);
    }];
    
#pragma 8 Notification   可省去在 -(void)dealloc {} 中清除通知和监听通知创建方法的步骤
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        NSLog(@"%@ 键盘弹起", x); // x 是通知对象
    }];
    
#pragma 9  代替 Delegate 代理方法(在view中设置了这个方法执行事件后就会走回调)
//    [[view rac_signalForSelector:@selector(btnClick)] subscribeNext:^(RACTuple * _Nullable x) {
//
//        NSLog(@" view 中的按钮被点击了");
//    }];
    
#pragma 10 代替 KVO 监听
//    [[view rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
//
//        NSLog(@"属性的改变：%@", x); // x 是监听属性的改变结果
//    }];
    
    
#pragma 11 代替 NSTimer 计时器
    disposable = [[RACSignal interval:3.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
        NSLog(@"当前时间：%@", x); // x 是当前的系统时间
        
    }];
//    /* 关闭计时器 */
//    [disposable dispose];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

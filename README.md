#里面包含两个工程,请注意查看,RACDemo是项目实践内容,RMBaseSessionManager是基本使用
# RAC_Demo

// 为了实现高聚合，低耦合的编程思想而封装的扩展类
// 例如在响应事件处理业务逻辑的时候用到的action、delegate、KVO、callback等都可以通过RAC来处理.
// Signal信号是数据流,类似水龙头,数据都是线性处理的，不会出现并发情况,接收方就是接水盆,没有水盆的时候,水龙头是关闭状态

/*
// RACSubject
racsubject是一个有趣的信号类型。这是ReactiveCocoa创建的“可变状态“世界。这是一个信号，你可以手动发送新的值。因为这个原因，除了在特定的情况下，它是不推荐使用的。
Hot and Cold Signals  热信号和冷信号
信号在通常情况下是懒惰的，我们可以称之为懒加载。只有当他们被订阅的时候，才去发送信号和执行相应的操作。每添加一个新的订阅者，就需要重新去执行相应的操作。对于琐碎的操作来说，这是合理的也是可取的。我们称这类信号为热信号。
然而，有时，我们希望工作立即完成。这种类型的信号被称为热信号。使用热信号是非常罕见的。
//既能创建信号，也能发送信号
RACSubject *subject = [RACSubject subject];

// RACReplaySubject
// RACReplaySubject 可以先发送数据，然后订阅，不同于上边的信号类型
RACReplaySubject *replaySubject = [RACReplaySubject subject];


// Rac_liftSelector
相当于多线程组,当需要请求多个数据，在所有数据请求完成之后才进行更新UI或者类似的事情的时候，可以用rac_liftSelector
[self rac_liftSelector:@selector(refreshUI:::) withSignals:Signal1,Signal2,Signal3, nil];


//RACMulticastConnection
多播
多播是指在任何一个订阅用户数之间共享的一个术语。信号，默认情况下，是冷的（如我们所描述的最后一节）。当它被订阅时，不希望有一个寒冷的信号，执行工作的每一次操作。
所以我们创造了从信号的racmulticastconnection。你可以通过使用公开发布racsignal，或组播方法。前一种方法为您创建一个多播连接。后者也是这样做。这个问题上是手动从底层发送信号时，它被称为发送的值。然后，而不是任何有兴趣的潜在信号发送的值订阅连接的信号
//把信号转化为连接类
RACMulticastConnection *multicastConnection =  [signal publish];


// RACCommend
//RACCommend 处理事件，把事件数据都包装在累中处理，很方便的监听事件是否执行完成  不能返回一个空的信号
RACCommand *commend = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
NSLog(@"%@",input); //只要执行命令就会调用该方法。
return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//发送数据
[subscriber sendNext:@"执行命令产生的数据"];
//发送完成
[subscriber sendCompleted];
return nil;
}];
}];

//监听事件是否完成  当前命令内部发送数据完成，一定要主动发送完成
[commend.executing subscribeNext:^(id x) {
if ([x boolValue]== YES) {
NSLog(@"当前正在执行");
}else{
NSLog(@"执行完成／还没有执行");
}
}];


// RAC bind:^RACStreamBindBlock]
信号绑定


// RAC flattenMap 绑定信号 
过滤/创建信号


// Concat
信号之间的组合 concat


// 信号之间的组合 then

//信号的超时，延迟,重试
RACSignal *signal = [self rac_signalForSelector:@selector(commandAction:)];
[[[RACSignal interval:1 onScheduler:[RACScheduler scheduler]]takeUntil:signal] subscribeNext:^(id x) {
NSLog(@"%@",[NSDate date]);
}];

RACSignal *delaySignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
[subscriber sendNext:@"2"];
return [RACDisposable disposableWithBlock:^{
}];
}];

[[delaySignal delay:2] subscribeNext:^(id x) {
NSLog(@">>>>>>%@",[NSDate date]);
[self commandAction:nil];
}];

[[delaySignal retry] subscribeNext:^(id x) {
NSLog(@"%@",x);
} error:^(NSError *error) {
NSLog(@"%@",error);
}];

*/

//
//  ViewController.m
//  RACDemo
//
//  Created by Raymon on 2018/5/17.
//  Copyright © 2018年 Raymon. All rights reserved.
//

#import "ViewController.h"
#import "IMShopCartUIService.h"
#import "IMShopCartViewModel.h"
#import "IMShopCartBar.h"
#import "IMShopCartModel.h"


@interface ViewController ()<IMShopCartUIServiceDelegate>
{
    BOOL _isEdit;
    UIButton *_editButton;
}
//@property (strong, nonatomic) IMMessageRemindView   *cartRemindView;//购物车没有商品

@property (nonatomic, strong) IMShopCartUIService   *service;

@property (nonatomic, strong) IMShopCartViewModel   *viewModel;

@property (nonatomic, strong) UITableView           *cartTableView;

@property (nonatomic, strong) IMShopCartBar         *cartBar;

//@property (strong, nonatomic) IMPopUpView *makeupView;//去凑单弹框

@property (strong, nonatomic) NSMutableArray *makeUpArray;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建NavBar样式
    [self createBarItem];
    // 添加tableview
    [self.view addSubview:self.cartTableView];
    // 添加购物状态栏
    [self.view addSubview:self.cartBar];
    // 对购物状态栏操作进行处理
    [self RAC_HandleCartBarAction];
    // 添加购物车的通知
    [self addCartNsnotifaction];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cartBar.selectAllButton.selected = NO;
    self.cartBar.balanceButton.enabled = YES;
    // 刷新数据
    [self getNewData];
    
}
- (void)addCartNsnotifaction {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(creatRemindView:) name:kIMShopCartControllerEmptyNotification object:nil];
}

- (void)creatRemindView:(NSNotification *)notification {
    NSString *str = notification.userInfo[@"cart"];
    if ([str isEqualToString:@"2"]) {
        _editButton.hidden = YES;
        self.cartBar.hidden = YES;
    }else{
        self.cartBar.hidden = NO;
//        [str isEqualToString:@"1"] ? [self.cartRemindView removeFromSuperview] :[self.view addSubview:self.cartRemindView];
        if ([str isEqualToString:@"1"]) {
            _editButton.hidden = NO;
        }else{
            _editButton.hidden = YES;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - UI
- (void)createBarItem{
    self.title = @"购物车";
}

- (void)creatmakeupView {

}
#pragma mark --CUSTOMDELEGATE
//去凑单
- (void)shopCartUIServiceButtonDidClick:(UIButton *)sender {
    NSLog(@"点击");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
}

#pragma mark - RAC_Method
- (void)RAC_HandleCartBarAction{
    // 全选
    [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIButton *button = (UIButton *)x;
        button.selected = !button.selected;
        [self.viewModel selectAll:button.selected];
    }];
    
    // 删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [RMUtils alertWithTitle:nil message:@"是否删除该商品?" delegate:self tag:99 cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
    }];
    
    // 结算
    [[self.cartBar.balanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (!self.cartBar.isSelectBalance) {
//            [RMUtils showMessage:@"请先选择商品"];
            return;
        }
//        [self.viewModel balanceAccountsSuccess:^(id response) {
            // 结算
            NSLog(@"结算");
            
//            NSDictionary *respond = (NSDictionary *)response;
//        }];
    }];
    
    
    
    // 观察价格属性
    WEAK
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(id x) {
        STRONG
        NSNumber *number = (NSNumber *)x;
        strongSelf.cartBar.money = number.floatValue;
    }];
    
    // 全选状态
    RAC(self.cartBar.selectAllButton, selected) = RACObserve(self.viewModel, isSelectAll);
    
    // 购物车数量
    [RACObserve(self.viewModel, currentSelectedCartGoodsCount) subscribeNext:^(id x) {
        STRONG
        NSNumber *number = (NSNumber *)x;
        if (number.integerValue == 0) {
            [strongSelf.cartBar.balanceButton setTitle:@"去结算" forState:UIControlStateNormal];
        }else{
            [strongSelf.cartBar.balanceButton setTitle:[NSString stringWithFormat:@"去结算(%@)",number] forState:UIControlStateNormal];
        }
    }];
    
}

#pragma mark - RequestData
- (void)getNewData{
    [self.viewModel getData];
}

#pragma mark - Target_Action
- (void)editAction{
    _isEdit = !_isEdit;
    NSString *itemTitle = _isEdit == YES ? @"完成" : @"编辑";
    [_editButton setTitle:itemTitle forState:UIControlStateNormal];
    self.cartBar.isNormalState = !_isEdit;
    self.service.isNormalState = !_isEdit;
//    self.viewModel.isEdit      = _isEdit;
    [self.viewModel recoverSelectedStatus];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

#pragma mark - AlertViewDelegate

#pragma mark - LazyLoading
- (IMShopCartBar *)cartBar{
    if (!_cartBar) {
        _cartBar = [[IMShopCartBar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 10 - 50, kScreenWidth, 50)];
        _cartBar.isNormalState = YES;
    }
    return _cartBar;
}

- (UITableView *)cartTableView{
    if (!_cartTableView) {
        _cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 55 )
                                                      style:UITableViewStyleGrouped];
        [_cartTableView registerNib:[UINib nibWithNibName:@"IMShopCartCell" bundle:nil] forCellReuseIdentifier:@"IMShopCartCell"];
        [_cartTableView registerClass:NSClassFromString(@"IMShopCartFooterView") forHeaderFooterViewReuseIdentifier:@"IMShopCartFooterView"];
        [_cartTableView registerClass:NSClassFromString(@"IMShopCartHeaderView") forHeaderFooterViewReuseIdentifier:@"IMShopCartHeaderView"];
        _cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cartTableView.dataSource   = self.service;
        _cartTableView.delegate     = self.service;
        _cartTableView.backgroundColor = [UIColor lightTextColor];
        //        _cartTableView.bounces         = NO;
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _cartTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    }
    return _cartTableView;
}

- (IMShopCartViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[IMShopCartViewModel alloc] init];
        _viewModel.cartVC = self;
        _viewModel.cartTableView  = self.cartTableView;
    }
    return _viewModel;
}

- (IMShopCartUIService *)service{
    
    if (!_service) {
        _service = [[IMShopCartUIService alloc] init];
        _service.delegate = self;
        _service.viewModel = self.viewModel;
        _service.isNormalState = YES;
    }
    return _service;
}
- (NSMutableArray *)makeUpArray {
    if (_makeUpArray) {
        return _makeUpArray;
    }
    _makeUpArray = [NSMutableArray array];
    return _makeUpArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 // liftSelector
 }
 */

@end

//
//  CreditAssignController.m
//  TTJF
//
//  Created by wbzhan on 2018/5/16.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "TransferListController.h"
#import "NavSwitchView.h"
#import "TransferBuyDetailController.h"
#import "FDSlideBar.h"
#import "ScrollerContentView.h"
#import "MyTransferController.h"

@interface TransferListController ()<ScrollerContentViewDataSource>

Strong ScrollerContentView *transferContentView;//转让记录
Strong ScrollerContentView *buyContentView;//购买记录
Assign NSInteger sellSelectedIndex;//被选中状态
Assign NSInteger buySelectedIndex;//被选中状态
Strong NSArray *transferTitleArr;
Strong NSArray *buyTitleArr;
Assign BOOL isBuy;//购买记录
Strong NavSwitchView *switchView;//标题切换
Strong FDSlideBar *slideBar;//滑动选择bar
Strong NSMutableArray *titleArr;//slideBar数据源
Strong UIButton *leftBtn;
@end

@implementation TransferListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sellSelectedIndex = 0;
    self.buySelectedIndex = 0;
    self.transferTitleArr = @[@"全部",@"可转让",@"转让中",@"已转让"];
    self.buyTitleArr = @[@"全部",@"回款中",@"已回款"];
    [self.view addSubview:self.switchView];
    [self.switchView addSubview:self.leftBtn];
    [self.leftBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kSizeFrom750(20));
        make.width.mas_equalTo(kSizeFrom750(50));
        make.height.mas_equalTo(kSizeFrom750(88));
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.view addSubview:self.slideBar];
    [self.view addSubview:self.transferContentView];
    [self.view addSubview:self.buyContentView];
    
    // Do any additional setup after loading the view.
}
-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = InitObject(UIButton);
        [_leftBtn setImage:IMAGEBYENAME(@"icons_back") forState:UIControlStateNormal];
        _leftBtn.adjustsImageWhenHighlighted = NO;
        [_leftBtn addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}
#pragma mark lazyLoading
-(NavSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[NavSwitchView alloc]initWithFrame:RECT(0, 0, screen_width, kNavHight) Array:@[@"债权转让",@"债权购买"]];
        WEAK_SELF;
        _switchView.switchBlock = ^(NSInteger tag) {
            if (tag==0) {
                    weakSelf.slideBar.itemsTitle = weakSelf.transferTitleArr;
                    weakSelf.isBuy = NO;
                    [weakSelf.slideBar selectSlideBarItemAtIndex:weakSelf.sellSelectedIndex];
                    weakSelf.transferContentView.hidden = NO;
                    weakSelf.buyContentView.hidden = YES;

                   
            }else{
                 weakSelf.slideBar.itemsTitle =weakSelf.buyTitleArr;
                [weakSelf.slideBar selectSlideBarItemAtIndex:weakSelf.buySelectedIndex];
                weakSelf.isBuy = YES;
                weakSelf.transferContentView.hidden = YES;
                weakSelf.buyContentView.hidden = NO;
            }
        };
    }
    return _switchView;
}
#pragma mark -- 设置Slider
- (ScrollerContentView *)transferContentView {
    if (!_transferContentView) {
        
        _transferContentView = [[ScrollerContentView alloc] init];
        _transferContentView.frame = RECT(0, self.slideBar.bottom, screen_width, screen_height - self.slideBar.bottom);
        _transferContentView.dataSource = self;
        __weak typeof(self) weakSelf = self;
        [_transferContentView slideContentViewScrollFinished:^(NSUInteger index) {
            self.sellSelectedIndex = index;
            [weakSelf.slideBar selectSlideBarItemAtIndex:index];
        }];
    }
    return _transferContentView;
}
- (ScrollerContentView *)buyContentView {
    if (!_buyContentView) {
        
        _buyContentView = [[ScrollerContentView alloc] init];
        _buyContentView.frame = RECT(0, self.slideBar.bottom, screen_width, screen_height - self.slideBar.bottom);
        _buyContentView.dataSource = self;
        _buyContentView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        [_buyContentView slideContentViewScrollFinished:^(NSUInteger index) {
            self.buySelectedIndex = index;
            [weakSelf.slideBar selectSlideBarItemAtIndex:index];
        }];
    }
    return _buyContentView;
}
- (FDSlideBar *)slideBar {
    if (!_slideBar) {
        __weak typeof(self) weakSelf = self;
        _slideBar = [[FDSlideBar alloc] initWithFrame:RECT(0, kNavHight, screen_width, kTitleHeight)];
        _slideBar.itemsTitle = @[@"全部",@"可转让",@"转让中",@"已转让"];
        [_slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
            if (weakSelf.isBuy) {
                weakSelf.buySelectedIndex = idx;
                 [weakSelf.buyContentView scrollSlideContentViewToIndex:idx];
            }else
            {
                weakSelf.sellSelectedIndex = idx;
                [weakSelf.transferContentView scrollSlideContentViewToIndex:idx];
            }
        }];
    }
    return _slideBar;
}

#pragma mark -- ScrollerContentViewDataSource
- (UIViewController *)slideContentView:(ScrollerContentView *)contentView viewControllerForIndex:(NSUInteger)index {
    //显示内容的控制器
    MyTransferController *contentVC = [[MyTransferController alloc] init];
    contentVC.selectedIndex = index;
    if (contentView==self.transferContentView) {
        contentVC.isBuy = NO;
    }else{
        contentVC.isBuy = YES;
    }
    return contentVC;
}

- (NSInteger)numOfContentView:(ScrollerContentView *)contentView {
    if (contentView==self.transferContentView) {
        return self.transferTitleArr.count;
    }else{
        return self.buyTitleArr.count;
    }
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
}
*/

@end

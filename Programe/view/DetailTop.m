//
//  DetailTop.m
//  TTJF
//
//  Created by 占碧光 on 2017/12/14.
//  Copyright © 2017年 占碧光. All rights reserved.
//

#import "DetailTop.h"
#import "OneDetailModel.h"
#import "CustomProgressView.h"
@interface DetailTop ()
{
    NSTimer * myTimer;
    LoanBase * model;
}
Strong CustomProgressView *progressView;//进度条
Strong UILabel * rateLabel;//年化收益
Strong UILabel *programLimitLabel;//项目期限
Strong UILabel *programTotalLabel;//项目总额
Strong UILabel *programRemainLabel;//剩余可投金额
Strong UILabel *progressLabel;//进度
Assign CGFloat progressNum;//进度
Strong UILabel *investLabel;//投资人
Strong UIView *progressTopView;//progressView覆盖层
Strong UILabel *lab3;//项目总额
Strong UIButton *questionBtn;//问题弹框
@end

@implementation DetailTop

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)questionBtnClick:(UIButton *)sender
{
    [CommonUtils showAlerWithTitle:@"温馨提示" withMsg:@"号"];
}
//债权转让内容
-(void)loadCreditInfoWithModel:(LoanBase *)infoModel{
    self.lab3.text=@"债权价值";
    //利率
    NSString *rate = [infoModel.loan_info.apr stringByAppendingString:@"%"];
    NSMutableAttributedString *attr = [CommonUtils diffierentFontWithString:rate  rang:NSMakeRange(rate.length-1, 1) font:NUMBER_FONT(24) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.rateLabel setAttributedText:attr];
    //总额
    NSString *totalAmout = [NSString stringWithFormat:@"%@元",[CommonUtils getHanleNums:infoModel.loan_info.amount]];
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:totalAmout  rang:NSMakeRange(totalAmout.length-1, 1) font:SYSTEMSIZE(30) color:RGB(141,200,255) spacingBeforeValue:0 lineSpace:0];
    [self.programTotalLabel setAttributedText:attr1];
    //项目期限
    self.programLimitLabel.text=infoModel.loan_info.period_name;
    //剩余可投资金额
    NSString *remain = [NSString stringWithFormat:@"转让金额 %@元",[CommonUtils getHanleNums:infoModel.loan_info.credited_amount]];
    NSMutableAttributedString *attr2 = [CommonUtils diffierentFontWithString:remain  rang:[remain rangeOfString:[CommonUtils getHanleNums:infoModel.loan_info.left_amount]] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.programRemainLabel setAttributedText:attr2];
    
    self.investLabel.hidden = NO;
    self.questionBtn.hidden = NO;
    self.progressLabel.hidden = YES;
        //投资人数
    
    NSString *period = [NSString stringWithFormat:@"已还 %@ 期",infoModel.transfer_ret.period];
    NSString *totalPeriod = [NSString stringWithFormat:@"/共 %@ 期",infoModel.transfer_ret.total_period];
    NSMutableAttributedString *attr3 = [CommonUtils diffierentFontWithString:period  rang:[period rangeOfString:infoModel.transfer_ret.period] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    NSMutableAttributedString *attr4 = [CommonUtils diffierentFontWithString:totalPeriod  rang:[totalPeriod rangeOfString:infoModel.transfer_ret.total_period] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [attr3 appendAttributedString:attr4];
    [self.investLabel setAttributedText:attr3];
    
}
-(void)loadInfoWithModel:(LoanInfo *)infoModel{
    //利率
    NSString *rate = [infoModel.apr stringByAppendingString:@"%"];
   NSMutableAttributedString *attr = [CommonUtils diffierentFontWithString:rate  rang:NSMakeRange(rate.length-1, 1) font:NUMBER_FONT(24) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.rateLabel setAttributedText:attr];
    //总额
    NSString *totalAmout = [NSString stringWithFormat:@"%@元",[CommonUtils getHanleNums:infoModel.amount]];
    NSMutableAttributedString *attr1 = [CommonUtils diffierentFontWithString:totalAmout  rang:NSMakeRange(totalAmout.length-1, 1) font:SYSTEMSIZE(30) color:RGB(141,200,255) spacingBeforeValue:0 lineSpace:0];
    [self.programTotalLabel setAttributedText:attr1];
    //项目期限
    self.programLimitLabel.text=infoModel.period_name;
    
    self.progressNum=[[NSString stringWithFormat:@"%.4f",[infoModel.progress floatValue]/100] floatValue];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                               target:self
                                             selector:@selector(download)
                                             userInfo:nil
                                              repeats:YES];
    
    //剩余可投资金额
    NSString *remain = [NSString stringWithFormat:@"剩余可投%@元",[CommonUtils getHanleNums:infoModel.left_amount]];
    NSMutableAttributedString *attr2 = [CommonUtils diffierentFontWithString:remain  rang:[remain rangeOfString:[CommonUtils getHanleNums:infoModel.left_amount]] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
    [self.programRemainLabel setAttributedText:attr2];
    
//    //投资人数
//    NSString *invest = [NSString stringWithFormat:@"已经有%@位投资人",infoModel.tender_count];
//    NSMutableAttributedString *attr3 = [CommonUtils diffierentFontWithString:invest  rang:[invest rangeOfString:infoModel.tender_count] font:NUMBER_FONT(28) color:COLOR_White spacingBeforeValue:0 lineSpace:0];
//    [self.investLabel setAttributedText:attr3];


     
}
-(void)initView
{
    [self initSubView];

}

-(void)initSubView
{
    UIView * uv=[[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kSizeFrom750(270))];
    uv.backgroundColor= navigationBarColor;
    [self addSubview:uv];

    self.rateLabel= [[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(100), kSizeFrom750(45),kSizeFrom750(280),kSizeFrom750(60))];
    self.rateLabel.font = NUMBER_FONT(58);
    self.rateLabel.textColor = COLOR_White;
    [uv addSubview:self.rateLabel];
    
    UIView * line=[[UIView alloc] initWithFrame:CGRectMake(screen_width/2-kSizeFrom750(80), kSizeFrom750(60), kLineHeight, kSizeFrom750(100))];
    line.backgroundColor=RGB(141,200,255);
    [uv addSubview:line];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(self.rateLabel.left, self.rateLabel.bottom+kSizeFrom750(10),self.rateLabel.width, kSizeFrom750(30))];
    lab1.font = SYSTEMSIZE(28);
    lab1.textColor=RGB(141,200,255);
    lab1.text=@"预期利率";
    [uv addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(line.right+kSizeFrom750(30), line.top+kSizeFrom750(10),kSizeFrom750(120), kSizeFrom750(30))];
    lab2.font = SYSTEMSIZE(28);
    lab2.textColor=RGB(141,200,255);
    lab2.text=@"项目期限";
    [uv addSubview:lab2];
    
    self.programLimitLabel = [[UILabel alloc] initWithFrame:CGRectMake(lab2.right+kSizeFrom750(10), lab2.top,kSizeFrom750(120), kSizeFrom750(30))];
    self.programLimitLabel.font = SYSTEMSIZE(30);
    self.programLimitLabel.textColor=RGB(255,255,255);
    [uv addSubview:self.programLimitLabel];
    
    self.lab3 = [[UILabel alloc] initWithFrame:CGRectMake(lab2.left, lab2.bottom+kSizeFrom750(20),lab2.width, lab2.height)];
    self.lab3.font = SYSTEMSIZE(28);
    self.lab3.textAlignment=NSTextAlignmentLeft;
    self.lab3.textColor=RGB(141,200,255);
    self.lab3.text=@"项目总额";
    [uv addSubview:self.lab3];
    
    self.programTotalLabel = [[UILabel alloc] init];
    self.programTotalLabel.font = SYSTEMSIZE(28);
    self.programTotalLabel.textColor=RGB(255,255,255);
    
    [uv addSubview:self.programTotalLabel];
    
    [self.programTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.programLimitLabel.mas_left);
        make.top.mas_equalTo(self.lab3.mas_top);
        make.height.mas_equalTo(self.programLimitLabel.mas_height);
    }];
    
    
    self.questionBtn = [[UIButton alloc]init];
    [self.questionBtn setImage:IMAGEBYENAME(@"icons_question") forState:UIControlStateNormal];
    [self.questionBtn setHidden:YES];
    [self.questionBtn addTarget:self action:@selector(questionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [uv addSubview:self.questionBtn];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.programTotalLabel.mas_centerY);
        make.left.mas_equalTo(self.programTotalLabel.mas_right).offset(kSizeFrom750(10));
        make.width.height.mas_equalTo(kSizeFrom750(30));
    }];
    
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, uv.height - kSizeFrom750(45),kSizeFrom750(150), kSizeFrom750(25))];
    self.progressLabel.font = SYSTEMSIZE(24);
    self.progressLabel.textColor=RGB(179,254,246);
    self.progressLabel.text=@"已售0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    [uv addSubview:self.progressLabel];
    //
    self.progressView = [[CustomProgressView alloc]initWithFrame:CGRectMake(0, uv.height - kSizeFrom750(6),screen_width,kSizeFrom750(6))];
    [CommonUtils addGradientLayer:self.progressView startColor:RGB(41,213,253) endColor:RGB(190, 252, 248) withDirection:DirectionFromLeft];//设置渐变色
    self.progressView.progress = 0.0f;
    self.progressView.layer.cornerRadius = 0.01;
     self.progressView.tineView.layer.cornerRadius = 0.01;
    //添加该控件到视图View中
    [uv addSubview:self.progressView];

    
    self.progressTopView = [[UIView alloc]initWithFrame:RECT(0, self.progressView.top, self.progressView.width, self.progressView.height)];
    self.progressTopView.backgroundColor = navigationBarColor;
    [uv addSubview:self.progressTopView];
 
    UIView * bottom=[[UIView alloc] initWithFrame:CGRectMake(0, kSizeFrom750(270), screen_width, kSizeFrom750(100))];
    bottom.backgroundColor= RGB(37,142,233);
    [self addSubview:bottom];
    
    self.programRemainLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSizeFrom750(30), kSizeFrom750(30),kSizeFrom750(320),kSizeFrom750(40))];
    self.programRemainLabel.font =  SYSTEMSIZE(28);
    self.programRemainLabel.textColor =  RGB(111,187,255);
    [bottom addSubview:self.programRemainLabel];
    
    
    
    self.investLabel= [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, self.programRemainLabel.top,screen_width/2-kSizeFrom750(30),self.programRemainLabel.height)];
    self.investLabel.font =  SYSTEMSIZE(28);
    self.investLabel.textColor =  RGB(141,200,255);
    self.investLabel.textAlignment=NSTextAlignmentRight;
    self.investLabel.hidden = YES;
    [bottom addSubview:self.investLabel];
    bottom.tag=2;
    

}
- (void)download
{
    if(self.progressNum==0||self.progressNum<0.0001)
    {
        self.progressLabel.text=[[NSString stringWithFormat:@"已售%.2f",self.progressView.progress*100] stringByAppendingString:@"%"];
        self.progressLabel.left = kOriginLeft;
        [myTimer invalidate];
    }
    else{
        
        self.progressView.progress += 0.005; // 设定步进长度
        CGFloat proLeft = screen_width*self.progressView.progress;
        self.progressTopView.frame = RECT(proLeft, self.progressTopView.top, screen_width-proLeft, self.progressTopView.height);
        self.progressLabel.text=[[NSString stringWithFormat:@"已售%.2f",self.progressView.progress*100] stringByAppendingString:@"%"];
        self.progressLabel.left = (screen_width - self.progressLabel.width)*self.progressView.progress;
        if (self.progressView.progress >= self.progressNum) {// 如果进度条到头了
            [myTimer invalidate];
            self.progressLabel.text=[[NSString stringWithFormat:@"已售%.2f",self.progressNum*100] stringByAppendingString:@"%"];
        }
    }
}

@end

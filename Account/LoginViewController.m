//
//  LoginViewController.m
//  TTJF
//
//  Created by 土土金服ios-01 on 2018/3/13.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "LoginViewController.h"
#import "UITextField+Shake.h"
#import "AppDelegate.h"
#import "HomeWebController.h"
@interface LoginViewController ()<UITextFieldDelegate,UIWebViewDelegate>
/**抬头*/
Strong UIImageView *titleImgView;
//账号
Strong UITextField *mobileTextField;
//密码
Strong UITextField *passwordTextField;
//登录按钮
Strong UIButton *loginBtn;
//注册按钮
Strong UIButton *registerBtn;
//忘记密码
Strong UIButton *forgetPdwBtn;

Strong UIWebView *loginWebView;

Strong UIButton *pwdBtn;//切换是否明文显示
@end

@implementation LoginViewController
{
    
    NSMutableURLRequest *request ;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleString = @"登录";
    [self.backBtn setImage:IMAGEBYENAME(@"close_white") forState:UIControlStateNormal];
    self.titleView.backgroundColor = [UIColor clearColor];
    [self initSubViews];
    [self makeViewConstraints];
}
-(void)backPressed:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark --lazyLoading
-(UIImageView *)titleImgView{
    if (!_titleImgView) {
        _titleImgView = InitObject(UIImageView);
        [_titleImgView setImage:IMAGEBYENAME(@"login_title")];
    }
    return _titleImgView;
}
-(UITextField*)mobileTextField{
    if (!_mobileTextField) {
        _mobileTextField = InitObject(UITextField);
        _mobileTextField.placeholder = @"请输入手机号码/邮箱";
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
        _mobileTextField.delegate = self;
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), 1);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_mobileTextField.layer addSublayer:layer];
    }
    return _mobileTextField;
}
-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = InitObject(UITextField);
        _passwordTextField.placeholder = @"请输入登录密码";
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        [_mobileTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, kSizeFrom750(90), kSizeFrom750(625), 1);
        layer.backgroundColor = [RGB(229, 230, 231) CGColor];
        [_passwordTextField.layer addSublayer:layer];

    }
    return _passwordTextField;
}
-(UIButton *)pwdBtn{
    if (!_pwdBtn) {
        _pwdBtn = InitObject(UIButton);
        [_pwdBtn setImage:IMAGEBYENAME(@"eye_close") forState:UIControlStateNormal];
        [_pwdBtn setImage:IMAGEBYENAME(@"eye_open") forState:UIControlStateSelected];
        [_pwdBtn addTarget:self action:@selector(pwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _pwdBtn;
}
-(UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = InitObject(UIButton);
        _loginBtn.adjustsImageWhenHighlighted = NO;
        [_loginBtn setBackgroundImage:IMAGEBYENAME(@"loginBtn") forState:UIControlStateNormal];

        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:SYSTEMBOLDSIZE(16)];
        [_loginBtn addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _loginBtn;
}
-(UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = InitObject(UIButton);
        _loginBtn.adjustsImageWhenHighlighted = NO;
        [_registerBtn setTitle:@"注册领取688元红包" forState:UIControlStateNormal];
        [_registerBtn setImage:IMAGEBYENAME(@"redevenlope") forState:UIControlStateNormal];
        _registerBtn.layer.borderColor = [RGB(255, 46, 19) CGColor];;
        _registerBtn.layer.borderWidth = 1;
        _registerBtn.layer.cornerRadius = kSizeFrom750(88)/2;
        [_registerBtn setTitleColor:RGB(255, 46, 19) forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:SYSTEMSIZE(14)];
        [_registerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -kSizeFrom750(20), 0, 0)];
        [_registerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -kSizeFrom750(20))];
        [_registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
-(UIButton *)forgetPdwBtn{
    if (!_forgetPdwBtn) {
        _forgetPdwBtn = InitObject(UIButton);
        _forgetPdwBtn.adjustsImageWhenHighlighted =  NO;
        [_forgetPdwBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPdwBtn setTitleColor:RGB_166 forState:UIControlStateNormal];
        [_forgetPdwBtn.titleLabel setFont:SYSTEMSIZE(14)];
        [_forgetPdwBtn addTarget:self action:@selector(forgotPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPdwBtn;
}
-(void)initSubViews{
    [self.view addSubview:self.titleImgView];
    
    [self.view addSubview:self.mobileTextField];
    
    [self.view addSubview:self.passwordTextField];
    
    [self.view addSubview:self.loginBtn];
    
    [self.view addSubview:self.registerBtn];
    
    [self.view addSubview:self.forgetPdwBtn];
    
    [self.view addSubview:self.pwdBtn];//是否明文显示
    
    [self.view bringSubviewToFront:self.titleView];
}
-(void)makeViewConstraints
{
    [self.titleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screen_width);
        make.height.mas_equalTo(kSizeFrom750(453));
    }];
    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(90));
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleImgView.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.height.mas_equalTo(self.mobileTextField);
        make.top.mas_equalTo(self.mobileTextField.mas_bottom).offset(kSizeFrom750(60));
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(kSizeFrom750(95));
        make.width.mas_equalTo(kSizeFrom750(625));
        make.height.mas_equalTo(kSizeFrom750(88));
        make.centerX.mas_equalTo(self.passwordTextField);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(kSizeFrom750(60));
        make.width.height.centerX.mas_equalTo(self.loginBtn);
    }];
    
    [self.forgetPdwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kSizeFrom750(170));
        make.height.mas_equalTo(kSizeFrom750(60));
        make.bottom.mas_equalTo(self.view).offset(-kSizeFrom750(50));
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.passwordTextField);
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.width.height.mas_equalTo(kSizeFrom750(60));
    }];
    
    
}
#pragma mark --textfieldDelegate
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if(_mobileTextField.text.length>0&&_mobileTextField.text.length >0)
    {
        [_loginBtn setBackgroundImage:IMAGEBYENAME(@"loginBtn") forState:UIControlStateNormal];
        [_loginBtn setBackgroundColor:[UIColor clearColor]];

    }
    else
    {
        [_loginBtn setBackgroundColor:RGB(200,226,242)];
        [_loginBtn setBackgroundImage:IMAGEBYENAME(@"") forState:UIControlStateNormal];

    }
}
#pragma mark --loginMethod
-(void)pwdBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.passwordTextField.secureTextEntry = !sender.selected;
}
//登录点击事件
-(void)loginButtonClick:(UIButton *)button
{
    if (_mobileTextField.text.length>1 && _passwordTextField.text.length >1 ) {
        // [MBProgressHUD showAutoMessage:@"正在登录..." ToView:nil];
        [SVProgressHUD showWithStatus:@"正在登录..."];
        [self getLogin];
        return ;
    }
    /*
     if (_passwordTextFiled.text.length < 6|| _passwordTextFiled.text.length > 16) {
     [_passwordTextFiled shake];
     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的密码格式" message:nil preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
     [alert addAction:action];
     [self presentViewController:alert animated:YES completion:nil];
     }
     */
    if (_mobileTextField.text.length <2) {
        [_mobileTextField shake];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的账号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (_passwordTextField.text.length <2) {
        [_passwordTextField shake];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
//登录
-(void) getLogin{
    UIDevice* curDev = [UIDevice currentDevice];
    NSString *terminal_type=@"iphone";
    NSString *terminal_id=curDev.identifierForVendor.UUIDString;//curDev.identifierForVendor.UUIDString;
    NSString *terminal_name= [curDev.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *terminal_model=curDev.model;
    NSString * terminal_token=[CommonUtils getToken];
    NSString *urlStr = @"";
    NSString * user_name=[_mobileTextField text];
    NSString *  password=[_passwordTextField text];
    
    terminal_name=[terminal_name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    /*  test
     terminal_type=@"iphone";
     terminal_id=@"1EEDE7A1-E953-4FC3-B903-D590D68CA97A";//curDev.identifierForVendor.UUIDString;
     terminal_name=@"一二A";
     terminal_model=@"iPhone";
     terminal_token=@"f3cad1be866d192819a65708111707fd931882bf807b3c452c3b61ac6d3e5556";
     user_name=@"tt13707985381";
     password=@"ncepu789";
     */
    //   NSString *password1=@"123456";
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,password,terminal_type,terminal_id,terminal_name,terminal_model,terminal_token] forKeys:@[@"user_name",@"password",@"terminal_type",@"terminal_id",@"terminal_name",@"terminal_model",@"terminal_token"]];
    //  paixu
    NSMutableArray * paixu1=[[NSMutableArray alloc] init];
    [paixu1 addObject:@"user_name"];
    [paixu1 addObject:@"password"];
    [paixu1 addObject:@"terminal_type"];
    [paixu1 addObject:@"terminal_id"];
    [paixu1 addObject:@"terminal_name"];
    [paixu1 addObject:@"terminal_model"];
    [paixu1 addObject:@"terminal_token"];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:paixu1];
    terminal_name= [terminal_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *  password1=[HttpSignCreate encodeString:[_passwordTextField text]];
    urlStr = [NSString stringWithFormat:login,oyApiUrl,user_name,password1,terminal_type,terminal_id,terminal_name,terminal_model,terminal_token,sign];
    
    NSData * data=  [ggHttpFounction  synHttpGet:urlStr];
    if([ggHttpFounction getJsonIsOk:data])
    {
        NSDictionary * dir= [ggHttpFounction getJsonData1:data];
        if(dir!=nil)
        {

            theAppDelegate.user_token=  [dir objectForKey:@"user_token"];
            theAppDelegate.user_name= user_name;
            NSString * temp=[[dir objectForKey:@"expiration_date"] substringWithRange:NSMakeRange(0,10)];
            theAppDelegate.expirationdate=temp;
            NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
            [userDef setObject:temp forKey:@"LoginTime"];
            [userDef setObject:user_name forKey:@"LoginAccount"];
            [userDef setObject:password forKey:@"LoginPassword"];
            //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
            [userDef setObject:@"1" forKey:@"IsSet"];
            [userDef synchronize];
            theAppDelegate.IsLogin=TRUE;
            [TTJFUserDefault setStr:[dir objectForKey:@"user_token"] key:kToken];
            [TTJFUserDefault setStr:user_name key:kUsername];//存储登录成功token值
            [self getWebLogin];
        }
        
    }
    else
    {
        // [MBProgressHUD showAutoMessage:@"登录失败" ToView:nil];
        NSString * msg=[ggHttpFounction getJsonMsg:data];
        [SVProgressHUD showErrorWithStatus:msg];
        
    }
    
    
    
    
}
//同时登录网页版
-(void) getWebLogin{
    //Api/Users/GetUsetInfo?user_token={user_token}&sign={sign}
    NSString *user_name=[CommonUtils getToken];
    NSString *user_token= [TTJFUserDefault strForKey:kUsername];
    NSString *urlStr = @"";
    user_name=[HttpSignCreate encodeString:user_name];
    NSDictionary *dict_data=[[NSDictionary alloc] initWithObjects:@[user_name,user_token] forKeys:@[@"user_name",@"user_token"]];
    NSMutableArray * paixu1=[[NSMutableArray alloc] init];
    [paixu1 addObject:@"user_name"];
    [paixu1 addObject:@"user_token"];
    NSString *sign=[HttpSignCreate GetSignStr:dict_data paixu:paixu1];
    urlStr = [NSString stringWithFormat:login2,oyUrlAddress,user_name,user_token,sign];
    [self loadPage1:urlStr];
    
    
}

//加载网页（网页默认不显示）
- (void)loadPage1: (NSString *) urlstr {
    
    self.loginWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    
    self.loginWebView.delegate=self;
    //伸缩内容适应屏幕尺寸
    self.loginWebView.scalesPageToFit=YES;
    [self.loginWebView setUserInteractionEnabled:YES];
    
    [self cleanCaches];
    NSURL *url = [[NSURL alloc] initWithString:urlstr];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"%@",urlstr);
    [self.loginWebView loadRequest:request];
    self.loginWebView.scrollView.bounces = NO;
    [self.view addSubview:self.loginWebView];
    //  [self.loginWebView isHidden:TRUE];
    
}
//注册按钮点击事件
-(void)registerBtnClick:(UIButton *)button
{
    //http://www.tutujf.com/wap/system/register2
    
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    // discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/system/register2",urlCheckAddress];
    discountVC.urlStr=theAppDelegate.globed.register_link;//[NSString stringWithFormat:@"%@/wap/system/register2",urlCheckAddress];
    //https://cs.www.tutujf.com/wap/system/login2
    discountVC.returnmain=@"4"; //页返回
    [self presentViewController:discountVC animated:YES completion:nil];
    
}
//忘记密码点击事件
-(void)forgotPwdBtnClick:(UIButton *)button
{
    //http://www.tutujf.com/wap/system/searchPwd
    
    HomeWebController *discountVC = [[HomeWebController alloc] init];
    discountVC.urlStr=[NSString stringWithFormat:@"%@/wap/system/searchPwd",oyUrlAddress];
    
    discountVC.returnmain=@"4"; //页返回
    [self presentViewController:discountVC animated:YES completion:nil];
    
}
#pragma mark webViewDelegate
/**
 *WebView加载完毕的时候调用（请求完毕）
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            //将上述数据全部存储到NSUserDefaults中
            ;
            [SVProgressHUD showSuccessWithStatus:@"登录成功~"];
            [self dismissViewControllerAnimated:YES completion:NULL];
        });
    });
}



-(void)webViewDidStartLoad:(UIWebView *)webView
{
    BBUserDefault.isNoFirstLaunch=YES;
}

/**
 *  清理缓存
 */
// 根据路径删除文件  删除cookies文件

- (void)cleanCaches{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
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

//
//  ValidateViewController.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/7.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "ValidateViewController.h"

@interface ValidateViewController ()

@end

@implementation ValidateViewController
- (id)initWithPhoneNumber:(NSString *)strPhoneNum
{
    self = [super init];
    if (self) {
        mPhoneNumber = strPhoneNum;
        mCountDownTime = 60;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手机验证码登陆";
    [self initViewLayout];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:@"applicationWillEnterForeground" object:nil];
}
- (void)applicationWillEnterForeground:(NSNotification *)notification
{
//    [self->mVerificationCodeView cleanVerificationCodeView];
}
- (void)initViewLayout
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginBtn = [self createButtonWithFrame:CGRectMake(20.0f, 300.0f, self.view.frame.size.width - 40.0f, 40.0f) :@"学生登陆" :[UIColor colorWithRed:230.0/255.0 green:107/255.0 blue:103/255.0 alpha:1.0] :@selector(loginWithStudent:)];
   
    UILabel *showPhoneInfoLabel = [self createLabelWithFrame:CGRectMake(20, 94, self.view.frame.size.width - 40, 35) :[NSString stringWithFormat:@"验证码已发送至 %@",mPhoneNumber] :18.0];
    
    mShowTimeInfoLabel = [self createLabelWithFrame:CGRectMake(20, 130, 100, 35) :[NSString stringWithFormat:@"%ds后重新获取",mCountDownTime] :14.0];
    
    mResendBtn = [self createButtonWithFrame:CGRectMake(20, 130, 100, 35) :@"重新发送" :[UIColor colorWithRed:45.0/255.0f green:123.0/255.0 blue:246.0/255.0 alpha:1.0] :@selector(resend:)];
    mResendBtn.hidden = YES;
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTimer) userInfo:nil repeats:YES];
    
    mVerificationCodeView = [[MQVerCodeInputView alloc]initWithFrame:CGRectMake(25, 200, self.view.frame.size.width-50, 50)];
    mVerificationCodeView.maxLenght = 6;//最大长度
    mVerificationCodeView.keyBoardType = UIKeyboardTypeNumberPad;
    [mVerificationCodeView mq_verCodeViewWithMaxLenght];
    mVerificationCodeView.block = ^(NSString *text){
        if (text.length == 6) {
            self->strValidate = text;
        }
    };
    [self.view addSubview:mVerificationCodeView];
    
}
- (void)countDownTimer
{
    mCountDownTime --;
    mShowTimeInfoLabel.text = [NSString stringWithFormat:@"%ds后重新获取",mCountDownTime];
    if (mCountDownTime == 0) {
        [mTimer invalidate];
        mResendBtn.hidden = NO;
        mShowTimeInfoLabel.hidden = YES;
        mCountDownTime = 60;
    }
}
- (UILabel *)createLabelWithFrame:(CGRect)frame :(NSString*)title :(CGFloat)size
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = title;
    label.font = [UIFont systemFontOfSize:size];
    [self.view addSubview:label];
    return label;
}
- (UIButton *)createButtonWithFrame:(CGRect)frame :(NSString*)title :(UIColor *)color :(SEL)event
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = color;
    button.layer.borderColor = [UIColor clearColor].CGColor;
    [self.view addSubview:button];
    return button;
}
- (void)resend:(id)sender
{
    [AVOSCloud requestSmsCodeWithPhoneNumber:mPhoneNumber callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self->mShowTimeInfoLabel.hidden = NO;
            self->mResendBtn.hidden = YES;
            self->mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTimer) userInfo:nil repeats:YES];
        }
    }];
    
    
}
- (void)loginWithStudent:(id)sender
{
    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:mPhoneNumber smsCode:strValidate block:^(AVUser * _Nullable user, NSError * _Nullable error) {
        if(error == nil){
            NSLog(@"====%@",user);
            if ([user objectForKey:@"netEaseUserInfo"] == nil)
            {
                NSDictionary *dicParameters = [NSDictionary dictionaryWithObject:@"student" forKey:@"role"];
                [self setRoleInMobile:dicParameters :user];
            }else{
                Boolean isCorrectRole = [self checkRoleIsStudent:user];
                if (isCorrectRole) {
                    [self performSelectorOnMainThread:@selector(jumpToIndex:) withObject:user waitUntilDone:YES];//验证成功
                }
                else{
                    [self showAllTextDialog:@"请用学生账号登录" :1];
                    [AVUser logOut];
//                    [self.navigationController popViewControllerAnimated:YES];
                }

            }
        }else{
            if ([error code] == 603)
            {
                [self showAllTextDialog:@"验证码已过期" :1];
            }
            else
            {
                [self showAllTextDialog:[[error userInfo] valueForKey:@"NSLocalizedFailureReason"]  :2];
            }
        }
        
    }];
    
}
- (void)setRoleInMobile:(NSDictionary *)dicParameters :(AVUser *)user
{
    // 调用指定名称的云函数 averageStars，并且传递参数
    [AVCloud callFunctionInBackground:@"mobileSetRole"
                       withParameters:dicParameters
                                block:^(id object, NSError *error) {
                                    if(error == nil && [[object objectForKey:@"status"]integerValue] == 200){
                                        // 处理结果
                                        NSLog(@"==============:%@",object);
                                        [self performSelectorOnMainThread:@selector(jumpToIndex:) withObject:user waitUntilDone:YES];
                                        [user setObject:[object objectForKey:@"data"] forKey:@"netEaseUserInfo"];
                                        [AVUser changeCurrentUser:user save:YES];
                                    } else {
                                        // 处理报错
                                        NSLog(@"error:%@",error);
                                    }
                                }];
}
- (Boolean)checkRoleIsStudent:(AVUser *)user
{
    NSArray *allRoles = [user getRoles:nil];
    NSLog(@"%@",allRoles);
    BOOL isCorrectRole = false;
    for (int i = 0; i < allRoles.count; i ++) {
        AVRole *role = [allRoles objectAtIndex:i];
        if ([[role objectForKey:@"name"] isEqualToString:@"student"])
        {
            isCorrectRole = true;
            break;
        }
    }
    return isCorrectRole;
}
#pragma mark -  提示弹框
-(void)showAllTextDialog:(NSString *)info :(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = info;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:delay];
        });
    });
}

- (void)jumpToIndex:(AVUser*)user
{
    // 以 AVUser 实例创建了一个 client
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.client = [[AVIMClient alloc] initWithUser:user];
    // 打开 client，与云端进行连接
    [app.client openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        // Do something you like.
        NSLog(@"即时消息登录%d",succeeded);
        if (succeeded) {
            app.isOpenIM = true;
        }
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
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

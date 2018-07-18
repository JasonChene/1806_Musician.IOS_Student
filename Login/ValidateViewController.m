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
    
    VerificationCodeView *view = [[VerificationCodeView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
    view.delegate = self;
    [view setupUI];
    [self.view addSubview:view];
    
}
- (void)verificationCodeDidFinishedInput :(VerificationCodeView *)verificationCodeView :(NSString *)code
{
    NSLog(@"====:%@",code);
//    if (![code isEqualToString:@"111111"]) {
//        [verificationCodeView cleanVerificationCodeView];
//    }
    if (code.length == 6) {
        strValidate = code;
    }
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
        if(error == nil)
        {
            NSArray *allRoles = [user getRoles:nil];
            NSLog(@"%@",allRoles);
            BOOL isCorrectRole = false;
            for (int i = 0; i < allRoles.count; i ++) {
                AVRole *role = [allRoles objectAtIndex:i];
                if ([[role objectForKey:@"name"] isEqualToString:@"teacher"])
                {
                    isCorrectRole = true;
                }
            }
            if (isCorrectRole) {
                //验证成功
                [self performSelectorOnMainThread:@selector(jumpToIndex:) withObject:user waitUntilDone:YES];
                
            }
        }
        
    }];
    
}

- (void)jumpToIndex:(AVUser*)user
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSDictionary *dicUserInfomation = [[NSDictionary alloc]initWithObjectsAndKeys:user.mobilePhoneNumber,@"mobilePhoneNumber",user.objectId,@"objectId",user.username,@"username", nil];
        [PathAPI saveUserInfoInLocal:dicUserInfomation];
        NSLog(@"=======保存到本地的数据：%@",dicUserInfomation);
        
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

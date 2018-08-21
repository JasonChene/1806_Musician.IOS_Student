//
//  LoginViewController.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/6/26.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手机验证码登陆";
    [self initViewLayout];
}
- (void)initViewLayout
{
    mUserTextField = [[UITextField alloc]initWithFrame:CGRectMake(20.0f, 96.0f, self.view.frame.size.width - 40.0f, 40.0f)];
    mUserTextField.keyboardType = UIKeyboardTypePhonePad;
    mUserTextField.layer.borderWidth = 1.0;
    mUserTextField.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0];
    mUserTextField.placeholder = @"请输入手机号码";
    mUserTextField.layer.borderColor = [UIColor clearColor].CGColor;
    [self.view addSubview:mUserTextField];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(20.0f, 156.0f, self.view.frame.size.width - 40.0f, 40.0f)];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:107/255.0 blue:103/255.0 alpha:1.0];
    loginBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [self.view addSubview:loginBtn];
    
    //修改导航栏的返回按钮的颜色和内容
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];

}
- (void)next:(id)sender
{
//    [AVOSCloud requestSmsCodeWithPhoneNumber:mUserTextField.text callback:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            ValidateViewController *validate = [[ValidateViewController alloc]initWithPhoneNumber:mUserTextField.text];
//            [self.navigationController pushViewController:validate animated:YES];
//        }
//    }];
    
    [AVSMS requestShortMessageForPhoneNumber:mUserTextField.text options:nil callback:^(BOOL succeeded, NSError * _Nullable error) {
        // 发送失败可以查看 error 里面提供的信息
        if (succeeded) {
            ValidateViewController *validate = [[ValidateViewController alloc]initWithPhoneNumber:self->mUserTextField.text];
            [self.navigationController pushViewController:validate animated:YES];
        }
        else
        {
            [self showAllTextDialog:[[error userInfo] valueForKey:@"NSLocalizedFailureReason"]  :2];
        }
    }];
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

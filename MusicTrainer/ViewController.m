//
//  ViewController.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/6/26.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"学生课程表";
    
    AVUser *user = [AVUser currentUser];
    
    NSLog(@"====:%@",user);
    if ([AVUser currentUser] == nil)
    {
        [self showLoginViewController];
    }
    UIButton *login_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40)];
    [login_button setTitle:@"进入教学页面" forState:UIControlStateNormal];
    login_button.backgroundColor = [UIColor redColor];
    [self.view addSubview:login_button];
    [login_button addTarget:self action:@selector(showTeachViewControlle) forControlEvents:UIControlEventTouchUpInside];
    
    //liguangsong123 e10adc3949ba59abbe56e057f20f883e  。122333444455555  3354045a397621cd92406f1f98cde292
    //登录网易云信
    NSString *accountID = [[user objectForKey:@"netEaseUserInfo"]objectForKey:@"accid"];
    NSString *token = [[user objectForKey:@"netEaseUserInfo"]objectForKey:@"token"];
//    NSString *strAccount = [[[NIMSDK sharedSDK] loginManager] currentAccount];
//    if ([strAccount isEqualToString:@""]) {
//         [[[NIMSDK sharedSDK] loginManager] autoLogin:accountID token:token];
//    }
   
    [[[NIMSDK sharedSDK] loginManager] login:accountID token:token completion:^(NSError * _Nullable error) {
        NSLog(@"err:%@",error);
        if (error == nil) {
            //打开乐谱
            NSLog(@"成功登录网易云信");

        }
        else{
        }

    }];
}
- (void)dealloc
{
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"成功推出网易云信");
        }
    }];
}
- (void)showLoginViewController
{
    LoginNavigationController *login = [[LoginNavigationController alloc]init];
    [self presentViewController:login animated:YES completion:^{

    }];
}
- (void)showTeachViewControlle
{
    TeachingViewController *teachingViewController = [[TeachingViewController alloc]init];
    [self.navigationController pushViewController:teachingViewController animated:YES];
    
    //修改导航栏的返回按钮的颜色和内容
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

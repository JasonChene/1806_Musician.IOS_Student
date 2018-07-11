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
    
    NSString *path = [PathAPI get_str_user_list_file_path :@"userInfo.plist"];
    NSDictionary *dicUserInfo = [[NSDictionary alloc]initWithContentsOfFile:path];
    if (dicUserInfo == nil)
    {
        [self showLoginViewController];
    }
    UIButton *login_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40)];
    [login_button setTitle:@"进入教学页面" forState:UIControlStateNormal];
    login_button.backgroundColor = [UIColor redColor];
    [self.view addSubview:login_button];
    [login_button addTarget:self action:@selector(showTeachViewControlle) forControlEvents:UIControlEventTouchUpInside];
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

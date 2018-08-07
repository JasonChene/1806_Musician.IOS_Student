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
    NSString *userID = [user objectForKey:@"objectId"];
    NSString *accountID = [[user objectForKey:@"netEaseUserInfo"]objectForKey:@"accid"];
    NSString *token = [[user objectForKey:@"netEaseUserInfo"]objectForKey:@"token"];
    [[[NIMSDK sharedSDK] loginManager] login:accountID token:token completion:^(NSError * _Nullable error) {
        NSLog(@"err:%@",error);
        if (error == nil) {
            //打开乐谱
            NSLog(@"成功登录网易云信");

        }
        else{
        }

    }];
    //获取课程信息
    if ([AVUser currentUser] != nil)
    {
        AVQuery *query = [AVQuery queryWithClassName:@"Course"];
        [query whereKey:@"student" equalTo:[AVObject objectWithClassName:@"_User" objectId:userID]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // objects 返回的就是有图片的 Todo 集合
            NSDictionary *dicStudentInfo = [objects objectAtIndex:0];
            NSString *teacherID = [[dicStudentInfo objectForKey:@"teacher"] objectForKey:@"objectId"];
            NSString *studentID = [[dicStudentInfo objectForKey:@"student"] objectForKey:@"objectId"];
            self->mTeacherID = teacherID;
            self->mStudentID = studentID;
        }];
    }
    
    //创建日期条
    int navBarAndStatusBarHeight = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    UIView *topDateView = [[UIView alloc]initWithFrame:CGRectMake(0, navBarAndStatusBarHeight, self.view.frame.size.width, 42)];
    topDateView.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
    [self.view addSubview:topDateView];
    UIButton *lastWeekBtn = [self createButtonWithFrame:CGRectMake(6, 6, 73, 30) :@"上一周" :@selector(getLastWeekCourseData:)];
    [topDateView addSubview:lastWeekBtn];
    UIButton *nextWeekBtn = [self createButtonWithFrame:CGRectMake(self.view.frame.size.width - 73 - 6, 6, 73, 30) :@"下一周" :@selector(getNextWeekCourseData:)];
    [topDateView addSubview:nextWeekBtn];
    
    int weekButtonWith = 29*7;
    int originX = (self.view.frame.size.width - weekButtonWith)/2.0;
    NSArray *arrWeek = [[NSArray alloc]initWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
    for (int i = 0; i < 7; i ++) {
        UIButton *weekBtn = [self createButtonWithFrame:CGRectMake(originX+i*29, 6, 29, 30) :[arrWeek objectAtIndex:i] :@selector(getWeekCourseData:)];
        [topDateView addSubview:weekBtn];
    }
    
    mShowDateLabel = [self createLabelWithFrame:CGRectMake(0, topDateView.frame.origin.y + topDateView.frame.size.height + 5 , self.view.frame.size.width, 23) :[self getFormatDateString:[NSDate date]]];
    
}
- (NSString *)getFormatDateString :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY年MM月dd日";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (UILabel *)createLabelWithFrame:(CGRect)frame :(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0];
    [self.view addSubview:label];
    return label;
}
- (UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(SEL)pressEvent
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 4;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    return button;
}
- (void)getLastWeekCourseData:(id)sender
{
    UIButton *weekBtn = (UIButton *)sender;
    NSLog(@"%@",weekBtn.titleLabel.text);
}
- (void)getNextWeekCourseData:(id)sender
{
    UIButton *weekBtn = (UIButton *)sender;
    NSLog(@"%@",weekBtn.titleLabel.text);
}
- (void)getWeekCourseData:(id)sender
{
    UIButton *weekBtn = (UIButton *)sender;
    NSLog(@"%@",weekBtn.titleLabel.text);
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
    TeachingViewController *teachingViewController = [[TeachingViewController alloc]initWithTeacherID:mTeacherID andWithStudentID:mStudentID];
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

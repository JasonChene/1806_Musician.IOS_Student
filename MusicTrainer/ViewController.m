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
- (void) getAllCoursesInfo :(NSDate *)date
{
    [mAllStudentCourseInfo removeAllObjects];
    AVUser *user = [AVUser currentUser];
    //获取课程信息
    if (user != nil)
    {
        NSString *strMinusDate = [self getFormatDateStringWithMinus:date];
        NSDate *startDate = [self getDateFromStringWithMinus:[NSString stringWithFormat:@"%@ 00:00:00",strMinusDate]];
        NSDate *endDate = [self getDateFromStringWithMinus:[NSString stringWithFormat:@"%@ 23:59:59",strMinusDate]];
        
        NSLog(@"startDate:%f",[endDate timeIntervalSinceDate:startDate]);
        NSString *userID = [user objectForKey:@"objectId"];
        
        AVQuery *studentQuery = [AVQuery queryWithClassName:@"Course"];
        [studentQuery whereKey:@"student" equalTo:[AVObject objectWithClassName:@"_User" objectId:userID]];
        AVQuery *startTimeQuery = [AVQuery queryWithClassName:@"Course"];
        [startTimeQuery whereKey:@"startTime" greaterThanOrEqualTo:startDate];
        AVQuery *endTimeQuery = [AVQuery queryWithClassName:@"Course"];
        [endTimeQuery whereKey:@"startTime" lessThanOrEqualTo:endDate];
        
        AVQuery *query = [AVQuery andQueryWithSubqueries:[NSArray arrayWithObjects:studentQuery,startTimeQuery,endTimeQuery,nil]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            // objects 返回的就是有图片的 Todo 集合
            NSMutableArray *arrAMCourse = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray *arrPMCourse = [[NSMutableArray alloc]initWithCapacity:0];
            NSMutableArray *arrNightCourse = [[NSMutableArray alloc]initWithCapacity:0];
            for (int i = 0; i < objects.count; i ++)
            {
                NSDictionary *dicStudentInfo = [objects objectAtIndex:i];
                NSDate *noonTime = [self getDateFromStringWithMinus:[NSString stringWithFormat:@"%@ 12:00:00",strMinusDate]];
                NSDate *nightTime = [self getDateFromStringWithMinus:[NSString stringWithFormat:@"%@ 18:00:00",strMinusDate]];
                NSDate *startDateTime = [dicStudentInfo objectForKey:@"startTime"];
                startDateTime = [startDateTime dateByAddingTimeInterval:8*60*60];
                //上午的课
                if ([startDateTime timeIntervalSince1970] < [noonTime timeIntervalSince1970])
                {
                    [arrAMCourse addObject:dicStudentInfo];
                    continue;
                }
                else if ([startDateTime timeIntervalSince1970] > [nightTime timeIntervalSince1970])
                {
                    [arrNightCourse addObject:dicStudentInfo];
                    continue;
                }
                else
                {
                    [arrPMCourse addObject:dicStudentInfo];
                    continue;
                }
            }
            if (arrAMCourse.count != 0)
                [self->mAllStudentCourseInfo setObject:arrAMCourse forKey:@"AMCourse"];
            if (arrPMCourse.count != 0)
                [self->mAllStudentCourseInfo setObject:arrPMCourse forKey:@"PMCourse"];
            if (arrNightCourse.count != 0)
                [self->mAllStudentCourseInfo setObject:arrNightCourse forKey:@"NightCourse"];
            
//            NSLog(@"============%@",self->mAllStudentCourseInfo);
            [self->mCourseTableview reloadData];
            
        }];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    mCourseTableview.contentInset = UIEdgeInsetsZero;
    mCourseTableview.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"学生课程表";
    self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    int navBarAndStatusBarHeight = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    
    mAllStudentCourseInfo = [[NSMutableDictionary alloc]initWithCapacity:0];
    mCorrectKey = [[NSMutableArray alloc]initWithCapacity:0];
    mCourseTableview = [[UITableView alloc]initWithFrame:CGRectMake(0,  160, self.view.frame.size.width, self.view.frame.size.height - 160) style:UITableViewStyleGrouped];
    mCourseTableview.delegate = self;
    mCourseTableview.dataSource = self;
    [self.view addSubview:mCourseTableview];
    
    if ([AVUser currentUser] == nil)
    {
        [self showLoginViewController];
    }
    
    //登录网易云信
    [self loginWithEastAccount];
    //创建日期条
    
    mTopDateView = [[UIView alloc]initWithFrame:CGRectMake(0, navBarAndStatusBarHeight, self.view.frame.size.width, 42)];
    mTopDateView.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
    [self.view addSubview:mTopDateView];
    UIButton *lastWeekBtn = [self createButtonWithFrame:CGRectMake(6, 6, 73, 30) :@"上一周" :@selector(getLastWeekCourseData:)];
    [mTopDateView addSubview:lastWeekBtn];
    UIButton *nextWeekBtn = [self createButtonWithFrame:CGRectMake(self.view.frame.size.width - 73 - 6, 6, 73, 30) :@"下一周" :@selector(getNextWeekCourseData:)];
    [mTopDateView addSubview:nextWeekBtn];
    
    int weekButtonWith = 29*7;
    int originX = (self.view.frame.size.width - weekButtonWith)/2.0;
    NSArray *arrWeek = [[NSArray alloc]initWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
    for (int i = 0; i < 7; i ++) {
        UIButton *weekBtn = [self createButtonWithFrame:CGRectMake(originX+i*29, 6, 29, 30) :[arrWeek objectAtIndex:i] :@selector(getWeekCourseData:)];
        [mTopDateView addSubview:weekBtn];
    }
    
    mShowDateLabel = [self createLabelWithFrame:CGRectMake(0, mTopDateView.frame.origin.y + mTopDateView.frame.size.height + 5 , self.view.frame.size.width, 23) :[self getFormatDateString:[NSDate date]]];
    [self setCurrentDayButtonLight:[self getWeekDayString:[NSDate date]]];
    
    //获取课程信息
    [self getAllCoursesInfo:[NSDate date]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(logoutCurrentUser)];
}
- (void)logoutCurrentUser
{
    [AVUser logOut];
    [self showLoginViewController];
}
- (void)loginWithEastAccount
{
    AVUser *user = [AVUser currentUser];
    if (![[[NIMSDK sharedSDK] loginManager]isLogined]) {
        //登录网易云信
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
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    //获取课程信息
    [self getAllCoursesInfo:[NSDate date]];
    [self loginWithEastAccount];
}
- (void)setCurrentDayButtonLight:(NSString *)title
{
    for (int i = 0; i < mTopDateView.subviews.count; i ++)
    {
        UIButton *btn = [mTopDateView.subviews objectAtIndex:i];
        if([btn.titleLabel.text isEqualToString:title])
        {
           [btn setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitleColor:[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }
}
- (NSString *)getFormatDateStringWithMinus :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (NSDate *)getDateFromStringWithMinus :(NSString *)strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [formatter dateFromString:strDate];
    return date;
}

- (NSString *)getFormatDateString :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY年MM月dd日";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (NSDate *)getFormatDate :(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [dateFormatter dateFromString:strDate];
    return date;
}
- (UILabel *)createLabelWithFrame:(CGRect)frame :(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
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
- (NSString *)getWeekDayString :(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSString *strWeek = @"一";
    int week = [comps weekday];
    NSLog(@"%d",week);
    switch (week) {
        case 7:
            strWeek = @"六";
            break;
        case 1:
            strWeek = @"日";
            break;
        case 2:
            strWeek = @"一";
            break;
        case 3:
            strWeek = @"二";
            break;
        case 4:
            strWeek = @"三";
            break;
        case 5:
            strWeek = @"四";
            break;
        case 6:
            strWeek = @"五";
            break;
        default:
            break;
    }
    mWeekDay = strWeek;
    return strWeek;
}
- (void)getLastWeekCourseData:(id)sender
{
    UIButton *weekBtn = (UIButton *)sender;
    NSLog(@"%@",weekBtn.titleLabel.text);
    NSDate *currentDateLabel = [self getFormatDate:mShowDateLabel.text];
    NSDate *newDate = [NSDate dateWithTimeInterval:24*60*60*(-7) sinceDate:currentDateLabel];
    mShowDateLabel.text = [self getFormatDateString:newDate];
    [self getWeekDayString:newDate];
    [self setCurrentDayButtonLight:[self getWeekDayString:newDate]];
    [self getAllCoursesInfo:newDate];
}
- (void)getNextWeekCourseData:(id)sender
{
    UIButton *weekBtn = (UIButton *)sender;
    NSLog(@"%@",weekBtn.titleLabel.text);
    
    NSDate *currentDateLabel = [self getFormatDate:mShowDateLabel.text];
    NSDate *newDate = [NSDate dateWithTimeInterval:24*60*60*7 sinceDate:currentDateLabel];
    mShowDateLabel.text = [self getFormatDateString:newDate];
    [self getWeekDayString:newDate];
    [self setCurrentDayButtonLight:[self getWeekDayString:newDate]];
    [self getAllCoursesInfo:newDate];
    
}
- (void)getWeekCourseData:(id)sender
{
    UIButton *weekBtn = (UIButton *)sender;
    int dayValueDiff = [self getDateNumberWithWeekDay:weekBtn.titleLabel.text] - [self getDateNumberWithWeekDay:mWeekDay];
    NSDate *currentDateLabel = [self getFormatDate:mShowDateLabel.text];
    NSDate *newDate = [NSDate dateWithTimeInterval:24*60*60*dayValueDiff sinceDate:currentDateLabel];
    mShowDateLabel.text = [self getFormatDateString:newDate];
    [self getWeekDayString:newDate];
    [self setCurrentDayButtonLight:[self getWeekDayString:newDate]];
    [self getAllCoursesInfo:newDate];
}
- (int)getDateNumberWithWeekDay:(NSString *)weekDay
{
    if ([weekDay isEqualToString:@"一"]) {
        return 1;
    }
    else if ([weekDay isEqualToString:@"二"]) {
        return 2;
    }
    else if ([weekDay isEqualToString:@"三"]) {
        return 3;
    }
    else if ([weekDay isEqualToString:@"四"]) {
        return 4;
    }
    else if ([weekDay isEqualToString:@"五"]) {
        return 5;
    }
    else if ([weekDay isEqualToString:@"六"]) {
        return 6;
    }
    else {
        return 7;
    }
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
- (void)showTeachViewControlle:(id)sender
{
    CourseTableViewCell *cell = (CourseTableViewCell *)((UIButton *)sender).superview;
    mTeacherID = cell.teacherID;
    mStudentID = cell.studentID;
    NSString *teacherName = cell.teacherNameLabel.text;
    
    TeachingViewController *teachingViewController = [[TeachingViewController alloc]initWithTeacherID:mTeacherID andWithStudentID:mStudentID andTeacherName:teacherName andTeacherLeanCloudUserName:cell.leancloudUserName];
    [self.navigationController pushViewController:teachingViewController animated:YES];
    
    //修改导航栏的返回按钮的颜色和内容
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.0f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *strHeader = [mCorrectKey objectAtIndex:section];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 24, 24)];
    if ([strHeader isEqualToString:@"AMCourse"]) {
        imageView.image = [UIImage imageNamed:@"class_morining"];
    }else if ([strHeader isEqualToString:@"PMCourse"]){
        imageView.image = [UIImage imageNamed:@"class_noon"];
    }else if ([strHeader isEqualToString:@"NightCourse"]){
        imageView.image = [UIImage imageNamed:@"class_night"];
    }
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 24)];
    [headView addSubview:imageView];
    return headView;
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrSectionCourse = [mAllStudentCourseInfo objectForKey:[mCorrectKey objectAtIndex:section]];
    return arrSectionCourse.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CourseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier :CGSizeMake(self.view.frame.size.width, 80)];
    }
    NSString *statusAPMN = [mCorrectKey objectAtIndex:section];
    NSDictionary *courseInfo = [[mAllStudentCourseInfo objectForKey:statusAPMN]objectAtIndex:row];
    NSDate *startDateTime = [courseInfo objectForKey:@"startTime"];
    NSDate *endDateTime = [self calculateEndTime:startDateTime :[[courseInfo objectForKey:@"duration"] intValue]];
    NSString *strStartTime = [self getTimeInfoWithDate:startDateTime];
    NSString *strEndTime =  [self getTimeInfoWithDate:endDateTime];
    cell.startTimeLabel.text = strStartTime;
    cell.endTimeLabel.text = strEndTime;
    cell.commentLabel.text = [courseInfo objectForKey:@"comment"];
    cell.courseNameLabel.text = [courseInfo objectForKey:@"name"];
    NSString *teacherID = [[courseInfo objectForKey:@"teacher"]objectForKey:@"objectId"];
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:teacherID block:^(AVObject *object, NSError *error) {
        cell.teacherNameLabel.text = [object objectForKey:@"username"];
        cell.leancloudUserName = [object objectForKey:@"mobilePhoneNumber"];
    }];
    
    if ([[NSDate date]timeIntervalSince1970] < [startDateTime timeIntervalSince1970]) {
        //未开始
        [cell.joinCourseButton setTitle:@"未开始" forState:UIControlStateNormal];
        [cell.joinCourseButton setEnabled:NO];
        [cell.joinCourseButton setBackgroundColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0]];
        cell.teacherID = @"";
        cell.studentID = @"";
    }
    else if ([[NSDate date]timeIntervalSince1970] > [endDateTime timeIntervalSince1970]){
        //已结束
        [cell.joinCourseButton setTitle:@"已结束" forState:UIControlStateNormal];
        [cell.joinCourseButton setEnabled:NO];
        [cell.joinCourseButton setBackgroundColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0]];
        cell.teacherID = @"";
        cell.studentID = @"";
    }
    else{
        //上课中
        [cell.joinCourseButton setTitle:@"上课中" forState:UIControlStateNormal];
        [cell.joinCourseButton setEnabled:YES];
        [cell.joinCourseButton addTarget:self action:@selector(showTeachViewControlle:) forControlEvents:UIControlEventTouchUpInside];
        [cell.joinCourseButton setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0]];
        cell.teacherID = [[courseInfo objectForKey:@"teacher"]objectForKey:@"objectId"];
        cell.studentID = [[courseInfo objectForKey:@"student"]objectForKey:@"objectId"];
    }
    
    if ([statusAPMN isEqualToString:@"AMCourse"]) {
        cell.timeStatusColorView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:137.0/255.0 blue:49.0/255.0 alpha:1.0];
    }
    else if ([statusAPMN isEqualToString:@"PMCourse"]){
        cell.timeStatusColorView.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:126.0/255.0 blue:131.0/255.0 alpha:1.0];
    }
    else if ([statusAPMN isEqualToString:@"NightCourse"]){
        cell.timeStatusColorView.backgroundColor = [UIColor colorWithRed:19.0/255.0 green:41.0/255.0 blue:61.0/255.0 alpha:1.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [mCorrectKey removeAllObjects];
    NSArray *originallkeys = mAllStudentCourseInfo.allKeys;
    
    if ([originallkeys containsObject:@"AMCourse"] == TRUE) {
        [mCorrectKey addObject:@"AMCourse"];
    }
    if ([originallkeys containsObject:@"PMCourse"] == TRUE) {
        [mCorrectKey addObject:@"PMCourse"];
    }
    if ([originallkeys containsObject:@"NightCourse"] == TRUE) {
        [mCorrectKey addObject:@"NightCourse"];
    }
    return originallkeys.count;
}
- (NSString *)getTimeInfoWithDate :(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
- (NSDate *)calculateEndTime :(NSDate *)date :(int)duration
{
    NSDate *endDate = [NSDate dateWithTimeInterval:duration/1000 sinceDate:date];
    return endDate;
    
}


@end

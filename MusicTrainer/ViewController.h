//
//  ViewController.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/6/26.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginNavigationController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "TeachingViewController.h"
#import <NIMSDK/NIMSDK.h>


@interface ViewController : UIViewController
{
    NSString *mTeacherID;
    NSString *mStudentID;
    UILabel *mShowDateLabel;
    UIView *mTopDateView;
    NSString *mWeekDay;
    UITableView *mCourseTableview;
    NSMutableDictionary *mAllStudentCourseInfo;
}
@end


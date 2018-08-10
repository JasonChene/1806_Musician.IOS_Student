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
#import "CourseTableViewCell.h"

#import <AVOSCloudIM/AVIMClient.h>
#import <AVOSCloudIM/AVIMTextMessage.h>
#import <AVOSCloudIM/AVIMConversation.h>


@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSString *mTeacherID;
    NSString *mStudentID;
    UILabel *mShowDateLabel;
    UIView *mTopDateView;
    NSString *mWeekDay;
    UITableView *mCourseTableview;
    NSMutableDictionary *mAllStudentCourseInfo;
}
@property (nonatomic, strong) AVIMClient *client;
@end


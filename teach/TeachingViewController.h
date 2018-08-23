//
//  TeachingViewController.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/9.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import <NIMSDK/NIMSDK.h>
#import <AVOSCloud/AVOSCloud.h>
#import "NTESMeetingWhiteboardViewController.h"
#import "MBProgressHUD.h"
//即时消息
#import <AVOSCloudIM/AVIMClient.h>
#import <AVOSCloudIM/AVIMTextMessage.h>
#import <AVOSCloudIM/AVIMConversation.h>
#import "AppDelegate.h"


@interface TeachingViewController : UIViewController<AgoraRtcEngineDelegate,UIImagePickerControllerDelegate,AVIMClientDelegate>
{
    int mNavBarAndStatusBarHeight;
    Boolean isJoinInRoom;
    NSString *channelName;
    NSString *mTeacherEastID;
    NSString *mTeacherName;
    UITextView *mTitleDescription;
    NSString *mTeacherLCUserName;
    NSMutableArray *mArrOriginDatas;
    NSMutableArray *mArrOriginPeerDatas;
    NSString *mStrImagePath;
}
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) UIView *videoLocalView;
@property (strong, nonatomic) UIView *videoRemoteView;
@property (nonatomic, strong) NTESMeetingWhiteboardViewController *whiteboardVC;
@property (nonatomic, copy)   NIMChatroom *chatroom;
- (instancetype)initWithTeacherID :(NSString *)teacherID andWithStudentID :(NSString *)studentID andTeacherName :(NSString *)teacherName andTeacherLeanCloudUserName :(NSString *)teacherLCUserName;
@end

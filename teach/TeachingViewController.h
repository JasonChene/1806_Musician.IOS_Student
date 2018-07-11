//
//  TeachingViewController.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/9.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface TeachingViewController : UIViewController<AgoraRtcEngineDelegate>
{
    int mNavBarAndStatusBarHeight;
    UIButton *closeVideoBtn;
}
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) UIView *videoLocalView;
@property (strong, nonatomic) UIView *videoRemoteView;
@end

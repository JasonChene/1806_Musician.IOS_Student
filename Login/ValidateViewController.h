//
//  ValidateViewController.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/7.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "PathAPI.h"
#import "MBProgressHUD.h"
#import <AVOSCloudIM/AVIMClient.h>
#import "AppDelegate.h"
#import "MQVerCodeInputView.h"

@interface ValidateViewController : UIViewController
{
    NSString *mPhoneNumber;
    UIButton *mResendBtn;
    UILabel *mShowTimeInfoLabel;
    NSTimer *mTimer;
    int mCountDownTime;
    NSString *strValidate;
    MQVerCodeInputView *mVerificationCodeView;
}
- (id)initWithPhoneNumber:(NSString *)strPhoneNum;
@end

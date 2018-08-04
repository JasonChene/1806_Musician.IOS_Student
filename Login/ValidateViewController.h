//
//  ValidateViewController.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/7.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerificationCodeViewDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "PathAPI.h"
#import "MBProgressHUD.h"

@interface ValidateViewController : UIViewController<VerificationCodeViewDelegate,UITextFieldDelegate>
{
    NSString *mPhoneNumber;
    UIButton *mResendBtn;
    UILabel *mShowTimeInfoLabel;
    NSTimer *mTimer;
    int mCountDownTime;
    NSString *strValidate;
    VerificationCodeView *mVerificationCodeView;
}
- (id)initWithPhoneNumber:(NSString *)strPhoneNum;
@end

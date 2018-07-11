//
//  VerificationCodeView.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/7.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "VerificationCodeViewDelegate.h"
#import "CodeTextField.h"
//#import "CodeTextFieldDeleteDelegate.h"

@protocol VerificationCodeViewDelegate;

@interface VerificationCodeView : UIView <CodeTextFieldDeleteDelegate, UITextFieldDelegate>
{
    /// 代理回调
    NSMutableArray *textfieldarray;
    CGFloat margin;
    CGFloat width;
    int numOfRect;
}
@property(nonatomic, retain) id <VerificationCodeViewDelegate> delegate;
- (void)cleanVerificationCodeView;
- (void)setupUI;
@end

@protocol VerificationCodeViewDelegate
- (void)verificationCodeDidFinishedInput :(VerificationCodeView *)verificationCodeView :(NSString *)code;
@end

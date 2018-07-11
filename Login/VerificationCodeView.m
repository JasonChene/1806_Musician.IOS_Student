//
//  VerificationCodeView.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/7.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "VerificationCodeView.h"

@implementation VerificationCodeView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        margin = 10;
        width = 50;
        numOfRect = 6;
        textfieldarray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return  self;
}
- (void) setupUI
{
    // 不允许用户直接操作验证码框
    [self setUserInteractionEnabled:NO];
    
//    self.isUserInteractionEnabled = false;
    // 计算左间距
    int leftmargin = ([[UIScreen mainScreen] bounds].size.width - width * numOfRect - (numOfRect - 1) * margin) / 2;
    
    // 创建 n个 UITextFiedl
    for (int i = 0; i < numOfRect; i ++) {
        CGRect rect = CGRectMake(leftmargin + i*width + i*margin, 0, width, width);
        CodeTextField *tv = [self createTextField:rect];
        tv.tag = i;
        [textfieldarray addObject:tv];
    }
    
    // 防止搞事
    if (numOfRect < 1)
        return;
    [[textfieldarray objectAtIndex:0] becomeFirstResponder];
}

- (CodeTextField *)createTextField:(CGRect)frame
{
    CodeTextField *tv = [[CodeTextField alloc]initWithFrame:frame];
    tv.borderStyle = UITextBorderStyleLine;
    tv.textAlignment = NSTextAlignmentCenter;
    tv.font = [UIFont boldSystemFontOfSize:40];
    tv.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    tv.delegate = self;
    tv.deleteDelegate = self;
    [self addSubview:tv];
    tv.keyboardType = UIKeyboardTypeNumberPad;
    return tv;
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![textField hasText]) {
        // tag 对应数组下标
        int index = (int)textField.tag;
        [textField resignFirstResponder];
        CodeTextField * tv = [textfieldarray objectAtIndex:index];
        if (index == numOfRect -1) {
            tv.text = string;
            NSString *code = @"";
            for (int m = 0; m < textfieldarray.count; m ++) {
                CodeTextField *codeTV = [textfieldarray objectAtIndex:m];
                code = [NSString stringWithFormat:@"%@%@",code,codeTV.text];
            }
            [self.delegate verificationCodeDidFinishedInput:self :code];
            return false;
        }
        tv.text = string;
        int nextIndex = index + 1;
        [[textfieldarray objectAtIndex:nextIndex] becomeFirstResponder];
        
    }
    return false;
}
-(void) didClickBackWard{
    for (int i = 0; i < numOfRect; i ++)
    {
        if (![[textfieldarray objectAtIndex:i] isFirstResponder]) {
            continue;
        }
        [[textfieldarray objectAtIndex:i] resignFirstResponder];
        CodeTextField *tv = [textfieldarray objectAtIndex:i-1];
        [tv becomeFirstResponder];
        tv.text = @"";
    }
}
- (void)cleanVerificationCodeView
{
    for (int i = 0; i < textfieldarray.count; i ++)
    {
        CodeTextField *tv = [textfieldarray objectAtIndex:i];
        tv.text = @"";
    }
    CodeTextField *firstTV = [textfieldarray objectAtIndex:0];
    [firstTV becomeFirstResponder];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  CodeTextField.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/7.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CodeTextFieldDeleteDelegate;


@interface CodeTextField : UITextField<CodeTextFieldDeleteDelegate>
@property(nonatomic,retain) id<CodeTextFieldDeleteDelegate> deleteDelegate;
@end

@protocol CodeTextFieldDeleteDelegate
- (void)didClickBackWard;
@end



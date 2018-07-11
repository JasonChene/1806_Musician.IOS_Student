//
//  CodeTextField.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/7.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "CodeTextField.h"

@implementation CodeTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)deleteBackward
{
    [super deleteBackward];
    [self.deleteDelegate didClickBackWard];
}

@end

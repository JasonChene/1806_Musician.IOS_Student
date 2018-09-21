//
//  CustumLabel.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/9/4.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "CustumLabel.h"

@implementation CustumLabel

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end

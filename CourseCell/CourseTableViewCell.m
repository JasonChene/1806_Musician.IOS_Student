//
//  CourseTableViewCell.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/8/9.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "CourseTableViewCell.h"

@implementation CourseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier :(CGSize)size
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame=CGRectMake(0, 0, size.width, size.height);
        self.layer.borderColor = [[UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0] CGColor];
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        
        self.timeStatusColorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        self.timeStatusColorView.layer.cornerRadius = 5;
        self.timeStatusColorView.layer.borderWidth = 1;
        [self addSubview:self.timeStatusColorView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(40, 32, 1, 14)];
        lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:lineView];
        
        //开始时间
        self.startTimeLabel = [self createLabelWithFrame:CGRectMake(4, 0, 75, 26) :NSTextAlignmentCenter: 16.0 :[UIColor whiteColor]];

        //结束时间
        self.endTimeLabel = [self createLabelWithFrame:CGRectMake(4, 48, 75, 26) :NSTextAlignmentCenter : 16.0 :[UIColor whiteColor]];

        //课程名字
        self.courseNameLabel = [self createLabelWithFrame:CGRectMake(98, 6,self.frame.size.width - 98 - 70 - 9 , 29) :NSTextAlignmentLeft : 18.0 :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0]];

        //老师名字
        self.teacherNameLabel = [self createLabelWithFrame:CGRectMake(98, 40, 55, 25) :NSTextAlignmentLeft : 12.0 :[UIColor colorWithRed:16.0/255.0 green:16.0/255.0 blue:16.0/255.0 alpha:1.0]];

        //评论
        self.commentLabel = [self createLabelWithFrame:CGRectMake(145, 41, self.frame.size.width - 145 - 70 - 9, 34) :NSTextAlignmentLeft :11.0 :[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0]];
        self.commentLabel.layer.cornerRadius = 4;
        self.commentLabel.layer.borderWidth = 1;
        self.commentLabel.layer.borderColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0].CGColor;

        //状态按钮
        self.joinCourseButton = [self createButtonWithFrame:CGRectMake(self.frame.size.width - 9 - 70, 8, 70, 25)];
    }
    return self;
}
- (UILabel *)createLabelWithFrame:(CGRect)frame :(NSTextAlignment)textAlignment :(double)fontSize :(UIColor *)fontColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = textAlignment;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = @"test";
    label.textColor = fontColor;
    [self addSubview:label];
    return label;
}
- (UIButton *)createButtonWithFrame:(CGRect)frame
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.layer.cornerRadius = 4;
    button.backgroundColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0];//灰色
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  CourseTableViewCell.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/8/9.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell
@property (nonatomic, retain)UILabel *startTimeLabel;
@property (nonatomic, retain)UILabel *endTimeLabel;
@property (nonatomic, retain)UILabel *courseNameLabel;
@property (nonatomic, retain)UILabel *teacherNameLabel;
@property (nonatomic, retain)UILabel *commentLabel;
@property (nonatomic, retain)UIButton *joinCourseButton;
@property (nonatomic, retain)UIView *timeStatusColorView;
@property (nonatomic, retain)NSString *teacherID;
@property (nonatomic, retain)NSString *studentID;
@property (nonatomic, retain)NSString *leancloudUserName;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier :(CGSize)size;
@end

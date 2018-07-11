//
//  TeachingViewController.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/9.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "TeachingViewController.h"

@interface TeachingViewController ()

@end

@implementation TeachingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"张老师";
    UIImageView *audioImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 279)/2, 200, 279, 264)];
    UIImage *audioImage = [UIImage imageNamed:@"teacher_audio"];
    audioImageView.image = audioImage;
    [self.view addSubview:audioImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

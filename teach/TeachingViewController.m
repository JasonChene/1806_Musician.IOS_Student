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
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutView];
    
    
    
    //初始化 AgoraRtcEngineKit
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:@"fa60d121c1c2452389543dbaf2ffb01e" delegate:self];
    [self.agoraKit enableVideo];
    //设置本地视频视图
    self.videoLocalView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, 64, 85, 136)];
    self.videoLocalView.backgroundColor = [UIColor greenColor];
    [self setUpVideo:self.videoLocalView :9999];
    [self.view addSubview:self.videoLocalView];
    
}
- (void)setUpVideo :(UIView *)view :(NSUInteger)uid
{
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = view;
    videoCanvas.renderMode = AgoraRtc_Render_Fit;
    [self.agoraKit setupLocalVideo:videoCanvas];
    
    [self.agoraKit setVideoProfile:AgoraRtc_VideoProfile_DEFAULT swapWidthAndHeight:NO];
    //创建并加入频道
    [self.agoraKit joinChannelByKey:nil channelName:@"channelName" info:nil uid:uid joinSuccess:nil];
}
- (void)layoutView
{
    //语音图标展示
    UIImage *audioImage = [UIImage imageNamed:@"teach_default"];
    UIImageView *audioImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - audioImage.size.width)/2, 200, audioImage.size.width, audioImage.size.height)];
    audioImageView.image = audioImage;
    [self.view addSubview:audioImageView];
    
    //添加“张老师正在和你乐谱教学”
    UITextView *titleDescription = [[UITextView alloc]initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, 40)];
    titleDescription.text = @"张老师正在和你乐谱教学";
    titleDescription.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleDescription];
    
    
    UIButton *openMusicBtn = [self createButtonWithFrame:CGRectMake((self.view.frame.size.width - 200 - 12)/2, self.view.frame.size.height - 30 - 7, 100, 30) :@"打开乐谱" :@selector(openMusicBook:)];
    [self.view addSubview:openMusicBtn];
    UIButton *handupBtn = [self createButtonWithFrame:CGRectMake(openMusicBtn.frame.origin.x + 100 + 12, openMusicBtn.frame.origin.y, 100, 30) :@"举手" :@selector(handup:)];
    [self.view addSubview:handupBtn];
}
- (UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(SEL)event
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:126.0/255.0 blue:131.0/255.0 alpha:1.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    return button;
}
- (void)openMusicBook:(id)sender
{
    NSLog(@"openMusicBook");
}
- (void)handup:(id)sender
{
    NSLog(@"handup");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AgoraRtcEngineDelegate
/**
 *  Event of the first local frame starts rendering on the screen.
 *
 *  @param engine  The engine kit
 *  @param size    The size of local video stream
 *  @param elapsed The elapsed time(ms) from the beginning of the session.
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed
{
    
}

/**
 *  Event of the first frame of remote user is decoded successfully.
 *
 *  @param engine  The engine kit
 *  @param uid     The remote user id
 *  @param size    The size of video stream
 *  @param elapsed The elapsed time(ms) from the beginning of the session.
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    
}

@end

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
static int UID = 9999;
@implementation TeachingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mNavBarAndStatusBarHeight = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    self.title = @"张老师";
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutView];
    
    //初始化 AgoraRtcEngineKit
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:@"fa60d121c1c2452389543dbaf2ffb01e" delegate:self];
    [self.agoraKit disableVideo];
    [self.agoraKit setEnableSpeakerphone:YES];
    //创建并加入频道
    [self.agoraKit joinChannelByToken:nil channelId:@"channelName" info:nil uid:UID joinSuccess:nil];
    
    
    
    //设置本地视频视图
    self.videoLocalView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, mNavBarAndStatusBarHeight, 85, 136)];
    self.videoLocalView.hidden = YES;
    [self.view addSubview:self.videoLocalView];
    //    [self setUpVideo:self.videoLocalView :9998];
    
    //添加远程试图
    self.videoRemoteView = [[UIView alloc]initWithFrame:CGRectMake(0, mNavBarAndStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height - mNavBarAndStatusBarHeight)];
    self.videoRemoteView.backgroundColor = [UIColor whiteColor];
    self.videoRemoteView.hidden = YES;
    [self.view insertSubview:self.videoRemoteView belowSubview:self.videoLocalView];
    closeVideoBtn = [self createButtonWithFrame:CGRectMake((self.view.frame.size.width - 150)/2, 400, 150, 30) :@"关闭视频教学" :@selector(closeVideoTeaching:)];
    closeVideoBtn.hidden = YES;
    [self.view insertSubview:closeVideoBtn aboveSubview:self.videoRemoteView];
    
    
    
    UITextView *titleDescription = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 40)];
    titleDescription.text = @"张老师正在和你视频教学";
    titleDescription.font = [UIFont systemFontOfSize:18];
    [self.videoRemoteView addSubview:titleDescription];
}
- (void)closeVideoTeaching:(id)sender
{
    self.videoLocalView.hidden = YES;
    self.videoRemoteView.hidden = YES;
    closeVideoBtn.hidden = YES;
    [self.agoraKit disableVideo];
    [self.agoraKit setEnableSpeakerphone:YES];
}
//开启本地视频功能
- (void)setUpLocalVideoInScreen :(UIView *)view :(NSUInteger)uid
{
    [self.agoraKit enableVideo];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = view;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
    [self.agoraKit setVideoProfile:AgoraVideoProfilePortrait360P swapWidthAndHeight:NO];
    
}
- (void)layoutView
{
    //语音图标展示
    UIImage *audioImage = [UIImage imageNamed:@"teach_default"];
    UIImageView *audioImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - audioImage.size.width)/2, (self.view.frame.size.height - audioImage.size.height + 17)/2 , audioImage.size.width, audioImage.size.height)];
    audioImageView.image = audioImage;
    [self.view addSubview:audioImageView];
    
    //添加“张老师正在和你乐谱教学”
    UITextView *titleDescription = [[UITextView alloc]initWithFrame:CGRectMake(10, mNavBarAndStatusBarHeight, self.view.frame.size.width - 20, 40)];
    titleDescription.text = @"张老师正在和你乐谱教学";
    titleDescription.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleDescription];
    
    
    UIButton *openMusicBtn = [self createButtonWithFrame:CGRectMake((self.view.frame.size.width - 200 - 12)/2, self.view.frame.size.height - 30 - 7, 100, 30) :@"打开乐谱" :@selector(openMusicBook:)];
    [self.view addSubview:openMusicBtn];
    UIButton *handupBtn = [self createButtonWithFrame:CGRectMake(openMusicBtn.frame.origin.x + 100 + 12, openMusicBtn.frame.origin.y, 100, 30) :@"举手（视频）" :@selector(handup:)];
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
    [self setUpLocalVideoInScreen:self.videoLocalView :UID];
    self.videoRemoteView.hidden = NO;
    self.videoLocalView.hidden = NO;
    closeVideoBtn.hidden = NO;
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
    [self addRomoteViewInViewWithUID:uid :self.videoRemoteView];
    self.videoRemoteView.hidden = NO;
    self.videoLocalView.hidden = NO;
    closeVideoBtn.hidden = NO;
}

/**
 *  Event of remote user video enabled or disabled
 *
 *  @param engine The engine kit
 *  @param enabled  Enabled or disabled
 *  @param uid    The remote user id
 */
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didVideoEnabled:(BOOL)enabled byUid:(NSUInteger)uid
{
    if (enabled == true) {
        [self setUpLocalVideoInScreen:self.videoLocalView :UID];
        [self addRomoteViewInViewWithUID:uid :self.videoRemoteView];
        self.videoRemoteView.hidden = NO;
        self.videoLocalView.hidden = NO;
        closeVideoBtn.hidden = NO;
    }
    else
    {
        [self.agoraKit disableVideo];
        self.videoLocalView.hidden = YES;
        self.videoRemoteView.hidden = YES;
        closeVideoBtn.hidden = YES;
    }
}


- (void)addRomoteViewInViewWithUID :(NSUInteger)uid :(UIView *)remoteView
{
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    videoCanvas.view = remoteView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupRemoteVideo:videoCanvas];
}

@end

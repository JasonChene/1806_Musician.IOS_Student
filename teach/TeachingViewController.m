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

- (instancetype)initWithTeacherID :(NSString *)teacherID andWithStudentID :(NSString *)studentID andTeacherName :(NSString *)teacherName andTeacherLeanCloudUserName :(NSString *)teacherLCUserName
{
    self = [super init];
    if (self) {
        channelName = studentID;
        mTeacherEastID = teacherID;
        mTeacherName = teacherName;
        mTeacherLCUserName = teacherLCUserName;
    }
    return self;
}
- (void)closeMusicTeaching:(NSNotification *)notifation
{
    mArrOriginDatas = self.whiteboardVC.mOriginDatas;
    mArrOriginPeerDatas = self.whiteboardVC.mOriginPeerDatas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mNavBarAndStatusBarHeight = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    self.title = mTeacherName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutView];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    mArrOriginDatas = [[NSMutableArray alloc]initWithCapacity:0];
    mArrOriginPeerDatas = [[NSMutableArray alloc]initWithCapacity:0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeMusicTeaching:) name:@"closeMusicTeaching" object:nil];
    
    //接受即时消息通知
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    [app.client setDelegate:self];
    
    //初始化 AgoraRtcEngineKit
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:@"fa60d121c1c2452389543dbaf2ffb01e" delegate:self];
    [self.agoraKit disableVideo];
    [self.agoraKit setEnableSpeakerphone:YES];
    [self.agoraKit setAudioProfile:AgoraAudioProfileMusicHighQualityStereo scenario:AgoraAudioScenarioShowRoom];
    //创建并加入频道
    [self.agoraKit joinChannelByToken:nil channelId:channelName info:nil uid:UID joinSuccess:nil];
    [self.agoraKit setDefaultAudioRouteToSpeakerphone:YES];
   
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
    
    UITextView *titleDescription = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 40)];
    titleDescription.text = [NSString stringWithFormat:@"%@正在和你视频教学",mTeacherName];
    titleDescription.font = [UIFont systemFontOfSize:18];
    [self.videoRemoteView addSubview:titleDescription];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<返回" style:UIBarButtonItemStylePlain target:self action:@selector(leaveChannel)];
    
    [self sendStudentOnlineMessage];
}

- (void)leaveChannel
{
    if(self.videoRemoteView.hidden == NO)
    {
        [self showAllTextDialog:@"正在跟老师远程视频..." :1];
    }
    else if( [self.whiteboardVC.view.superview isEqual:self.view] == YES)
    {
        [self showAllTextDialog:@"正在跟老师进行乐谱指导教学..." :1];
    }
    else
    {
        [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        }];
        AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
        [app.client createConversationWithName:@"学生下线" clientIds:@[mTeacherEastID] callback:^(AVIMConversation *conversation, NSError *error) {
            // Tom 发了一条消息给 Jerry
            [conversation sendMessage:[AVIMTextMessage messageWithText:@"studentOffline" attributes:nil] callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"学生下线提醒！");
                }
            }];
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)showAllTextDialog:(NSString *)info :(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = info;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:delay];
        });
    });
}


- (void)closeVideoTeaching:(id)sender
{
    self.videoLocalView.hidden = YES;
    self.videoRemoteView.hidden = YES;
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
    mTitleDescription = [[UITextView alloc]initWithFrame:CGRectMake(10, mNavBarAndStatusBarHeight, self.view.frame.size.width - 20, 40)];
    mTitleDescription.backgroundColor = [UIColor clearColor];
    mTitleDescription.text = @"老师未上线";
    [mTitleDescription setEditable:NO];
    mTitleDescription.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:mTitleDescription];
    
    mTeacherPause = [[UITextView alloc]initWithFrame:CGRectMake(10, mNavBarAndStatusBarHeight + 40, self.view.frame.size.width - 20, 40)];
    mTeacherPause.backgroundColor = [UIColor clearColor];
    mTeacherPause.text = @"老师正在要求暂停";
    [mTeacherPause setEditable:NO];
    mTeacherPause.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:mTeacherPause];
    mTeacherPause.hidden = YES;
    
    UIButton *openMusicBtn = [self createButtonWithFrame:CGRectMake((self.view.frame.size.width - 200 - 12)/2, self.view.frame.size.height - 50 - 10, 100, 50) :@"打开乐谱" :@selector(openMusicBook:)];
    [self.view addSubview:openMusicBtn];
    UIButton *handupBtn = [self createButtonWithFrame:CGRectMake(openMusicBtn.frame.origin.x + 100 + 12, openMusicBtn.frame.origin.y, 100, 50) :@"举手" :@selector(handup:)];
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
    if (isJoinInRoom == YES) {
        AVUser *user = [AVUser currentUser];
        NSLog(@"openMusicBook:%@",user.username);
        //选择照片
        //初始化UIImagePickerController类
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        //判断数据来源为相册
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //设置代理
        picker.delegate = self;
        //打开相册
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        [self showAllTextDialog:@"打开乐谱失败，请确认老师是否接受你的乐谱教学请求..." :1];
    }
    
}

#pragma mark - Private
- (void)setupChildViewController :(UIImage *)musicImage :(NSString *)imgPath
{
    if (![mStrImagePath isEqual:imgPath] ) {
        mArrOriginDatas = [[NSMutableArray alloc]initWithCapacity:0];
        mArrOriginPeerDatas = [[NSMutableArray alloc]initWithCapacity:0];
    }
    mStrImagePath = imgPath;
    self.whiteboardVC = [[NTESMeetingWhiteboardViewController alloc] initWithImage :musicImage musicImagePath: imgPath musicSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - mNavBarAndStatusBarHeight) andTeacherEastID:mTeacherEastID :mArrOriginDatas :mArrOriginPeerDatas];
    [self.whiteboardVC.view setFrame:CGRectMake(0, mNavBarAndStatusBarHeight, self.view.frame.size.width, self.view.frame.size.height - mNavBarAndStatusBarHeight)];
    [self addChildViewController:self.whiteboardVC];
    [self.view addSubview:self.whiteboardVC.view];
}

- (void)handup:(id)sender
{
    //发送消息
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    [app.client createConversationWithName:@"举手" clientIds:@[mTeacherEastID] callback:^(AVIMConversation *conversation, NSError *error) {
        // Tom 发了一条消息给 Jerry
        [conversation sendMessage:[AVIMTextMessage messageWithText:@"HandUp" attributes:nil] callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self showAllTextDialog:@"举手成功！" :1];
            }
        }];
    }];
}
- (void)sendStudentOnlineMessage
{
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    [app.client createConversationWithName:@"学生上线" clientIds:@[mTeacherEastID] callback:^(AVIMConversation *conversation, NSError *error) {
        // Tom 发了一条消息给 Jerry
        [conversation sendMessage:[AVIMTextMessage messageWithText:@"studentOnline" attributes:nil] callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"学生上线提醒！");
            }
        }];
    }];
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
 *  Event of remote user offlined
 *
 *  @param engine The engine kit
 *  @param uid    The remote user id
 *  @param reason Reason of user offline, quit, drop or became audience
 */
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason
{
    isJoinInRoom = NO;
    if (self.videoRemoteView.hidden == NO) {
        self.videoRemoteView.hidden = YES;
        self.videoLocalView.hidden = YES;
        mTitleDescription.text = @"老师已下线";
    }
}
/**
 *  Event of the first audio frame from remote user is received.
 *
 *  @param engine  The engine kit
 *  @param uid     The remote user id
 *  @param elapsed The elapsed time(ms) from the beginning of the session.
 */
- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine firstRemoteAudioFrameOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    isJoinInRoom = YES;
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
    }
    else
    {
        [self.agoraKit disableVideo];
        self.videoLocalView.hidden = YES;
        self.videoRemoteView.hidden = YES;
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
# pragma mark - UIImagePickerControllerDelegate
//选择完成回调函数
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSString *imgPath = info[UIImagePickerControllerReferenceURL];
    [self setupChildViewController :image :imgPath];
    NSLog(@"%@",image);
    [self dismissViewControllerAnimated:YES completion:nil];
//    myImageView.image = image;
}
 //用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
     [self dismissViewControllerAnimated:YES completion:nil];
 }

#pragma mark - AVIMClientDelegate
// 接收消息的回调函数
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    NSLog(@"%@", message.text); // 耗子，起床！
    if ([message.text isEqualToString:@"老师上线"])
    {
        [self showAllTextDialog:@"老师已上线" :1];
        mTitleDescription.text = [NSString stringWithFormat:@"%@正在和你语音教学",mTeacherName];
        AVIMTextMessage *reply = [AVIMTextMessage messageWithText:@"成功收到老师上线通知" attributes:nil];
        [conversation sendMessage:reply callback:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"回复成功！");
            }
        }];
    }
    else if ([message.text isEqualToString:@"收到学生上线通知"])
    {
        mTitleDescription.text = [NSString stringWithFormat:@"%@正在和你语音教学",mTeacherName];
    }
    else if ([message.text isEqualToString:@"老师下线"])
    {
        mTitleDescription.text = @"老师已下线";
    }
    else if ([message.text isEqualToString:@"pausePlaying"]){
        self.view.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:137.0/255.0 blue:49.0/255.0 alpha:1.0];
        mTeacherPause.hidden = NO;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.view.backgroundColor = [UIColor whiteColor];
    mTeacherPause.hidden = YES;
}


@end

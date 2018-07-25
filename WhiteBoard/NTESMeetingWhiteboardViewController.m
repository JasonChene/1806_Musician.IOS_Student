//
//  NTESMeetingWhiteboardViewController.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/25.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "NTESMeetingWhiteboardViewController.h"
#import "NTESWhiteboardDrawView.h"

typedef NS_ENUM(NSUInteger, WhiteBoardCmdType){
    WhiteBoardCmdTypePointStart    = 1,
    WhiteBoardCmdTypePointMove     = 2,
    WhiteBoardCmdTypePointEnd      = 3,
    
    WhiteBoardCmdTypeCancelLine    = 4,
    WhiteBoardCmdTypePacketID      = 5,
    WhiteBoardCmdTypeClearLines    = 6,
    WhiteBoardCmdTypeClearLinesAck = 7,
};

@interface NTESMeetingWhiteboardViewController ()
@property (strong, nonatomic) NTESWhiteboardDrawView *myDrawView;
@property (strong, nonatomic) NTESWhiteboardDrawView *peerDrawView;
@end

@implementation NTESMeetingWhiteboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *closeMusicBtn = [self createButtonWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, self.view.frame.size.height - 100 - 7, 100, 30) :@"关闭乐谱" :@selector(closeMusic:)];
    [self.view addSubview:closeMusicBtn];
    
    
    NIMRTSOption *option = [[NIMRTSOption alloc] init];
    option.extendMessage = @"ext msg example";
    
    [[NIMAVChatSDK sharedSDK].rtsManager addDelegate:self];
    
    NSString *theSessionID = [[NIMAVChatSDK sharedSDK].rtsManager requestRTS:@[@"122333444455555"]
                                                                    services:NIMRTSServiceReliableTransfer
                                                                      option:nil
                                                                  completion:^(NSError *error, NSString *sessionID, UInt64 channelID)
                              {
                                  NSLog(@"=====%@,\n=====:%@",error,sessionID);
                                  if (error && (sessionID == theSessionID)) {
                                      //error handling
                                  }
                              }];
    
    CGRect frame = self.view.bounds;
    _myDrawView = [[NTESWhiteboardDrawView alloc] initWithFrame:frame];
    _myDrawView.backgroundColor = [UIColor grayColor];
    [self.view insertSubview:_myDrawView belowSubview:closeMusicBtn];
    _myDrawView.layer.borderWidth = 0.5;
    
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
- (void)closeMusic:(id)sender
{
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - NIMRTSManagerDelegate
/**
 *  被叫响应互动白板请求
 *
 *  @param sessionID 互动白板ID
 *  @param accept  是否接听
 *  @param option  接收会话附带的选项, 可以是nil
 *  @param completion  响应呼叫结果回调
 *
 */
- (void)onRTSRequest:(NSString *)sessionID
                from:(NSString *)caller
            services:(NSUInteger)types
             message:(nullable NSString *)extendMessage
{
    NSLog(@"========%@ \n=======:%@\n=======:%lu:\n=======%@",sessionID,caller,(unsigned long)types,extendMessage);
    [[NIMAVChatSDK sharedSDK].rtsManager responseRTS:sessionID accept:YES option:nil completion:^(NSError * _Nullable error, NSString * _Nullable sessionID, UInt64 channelID) {
        NSLog(@"========%@ \n=======:%@\n=======%llu",error,sessionID,channelID);
        if (!error) {
            //error handling
//            NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:sessionID
//                                                                                                peerID:caller
//                                                                                                 types:types
//                                                                                                  info:extendMessage];
//            [self addChildViewController:vc];
            
        }
    }];
    
}
/**
 *  主叫收到被叫互动白板响应
 *
 *  @param sessionID 互动白板ID
 *  @param callee 被叫帐号
 *  @param accepted 是否接听
 *
 *  @discussion 被叫拒绝接听时, 主叫不需要再调用termimateRTS:接口
 */
- (void)onRTSResponse:(NSString *)sessionID
                 from:(NSString *)callee
             accepted:(BOOL)accepted
{
    
}

/**
 *  互动白板状态反馈
 *
 *  @param sessionID 互动白板ID
 *  @param type 互动白板服务类型
 *  @param status 通话状态, 收到NIMRTSStatusDisconnect时无需调用terminate:结束该会话
 *  @param error 出错信息, 正常连接和断开时为nil
 */
- (void)onRTS:(NSString *)sessionID
      service:(NIMRTSService)type
       status:(NIMRTSStatus)status
        error:(NSError *)error
{
    if (type == NIMRTSServiceReliableTransfer) {
        if (status == NIMRTSStatusConnect) {
            //            [self switchToConnectedView];
        }
        else {
            NSLog(@"已断开数据传输: %zd", error.code);
            //            [self termimateRTS];
        }
    }
    //    else if (type == NIMRTSServiceAudio) {
    //        _audioConnected = (status == NIMRTSStatusConnect) ? YES : NO;
    //        if (!_audioConnected) {
    //            NSLog(@"已断开音频服务: %zd", error.code);
    //        }
    //    }
}
#pragma mark UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:_myDrawView];
    [self onPointCollected:p type:WhiteBoardCmdTypePointStart];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:_myDrawView];
    [self onPointCollected:p type:WhiteBoardCmdTypePointMove];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:_myDrawView];
    [self onPointCollected:p type:WhiteBoardCmdTypePointEnd];
}
- (void)onPointCollected:(CGPoint)p type:(WhiteBoardCmdType)type
{
    //send to peer
//    NSString *cmd = [NSString stringWithFormat:@"%zd:%.3f,%.3f;", type, p.x/_drawViewWidth, p.y/_drawViewWidth];
//    [self addCmd:cmd];
    
    //local render
    NSArray *point = [NSArray arrayWithObjects:@(p.x), @(p.y), nil];
    [_myDrawView addPoints:[NSMutableArray arrayWithObjects:point, nil]
                 isNewLine:(type == WhiteBoardCmdTypePointStart)];
}
//- (void)addCmd:(NSString *)aCmd
//{
//    [_cmdsLock lock];
//    [_cmds appendString:aCmd];
//    [_cmdsLock unlock];
//
//    if ([_cmds length] >= 30000) {
//        [self sendCmds];
//    }
//}
@end

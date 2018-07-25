//
//  NTESMeetingWhiteboardViewController.m
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/25.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import "NTESMeetingWhiteboardViewController.h"
#import "NTESWhiteboardDrawView.h"
#import "NTESTimerHolder.h"

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
@property (strong, nonatomic) NSLock *cmdsLock;
@property (strong, nonatomic) NSMutableString *cmds;
@property (assign, nonatomic) UInt64 refPacketID;
@property (copy, nonatomic) NSString *sessionID;
@property (copy, nonatomic) NSString *peerID;
//@property (strong, nonatomic) NTESTimerHolder *sendCmdsTimer;
@end

@implementation NTESMeetingWhiteboardViewController

- (instancetype)initWithSessionID:(NSString *)sessionID :(NSString *)peerID
{
    self = [super init];
    if (self) {
        _sessionID = sessionID;
        _peerID = peerID;
        _cmds = [[NSMutableString alloc]initWithCapacity:1];
//        _sendCmdsTimer = [[NTESTimerHolder alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *closeMusicBtn = [self createButtonWithFrame:CGRectMake((self.view.frame.size.width - 100)/2, self.view.frame.size.height - 150 - 7, 100, 30) :@"关闭乐谱" :@selector(closeMusic:)];
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
                                  self.sessionID = sessionID;
                                  if (error && (sessionID == theSessionID)) {
                                      //error handling
                                  }
                              }];
    NSLog(@"theSessionID:%@",theSessionID);
    
    [self showDrawView:closeMusicBtn];
    
}

- (void)showDrawView :(UIButton *)closeMusicBtn
{
    CGRect frame = self.view.bounds;
    _myDrawView = [[NTESWhiteboardDrawView alloc] initWithFrame:frame];
    _myDrawView.backgroundColor = [UIColor whiteColor];
    [_myDrawView setLineColor:[UIColor redColor]];
//    [self.view addSubview:_myDrawView];
     [self.view insertSubview:_myDrawView belowSubview:closeMusicBtn];
    
    _peerDrawView = [[NTESWhiteboardDrawView alloc] initWithFrame:frame];
    _peerDrawView.backgroundColor = [UIColor clearColor];
    [_peerDrawView setLineColor:[UIColor greenColor]];
//    [self.view addSubview:_peerDrawView];
    [self.view insertSubview:_peerDrawView belowSubview:closeMusicBtn];
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
    _sessionID = sessionID;
    _peerID = caller;
    _cmds = [[NSMutableString alloc]initWithCapacity:1];
    
    
    NSLog(@"========%@ \n=======:%@\n=======:%lu:\n=======%@",sessionID,caller,(unsigned long)types,extendMessage);
    [[NIMAVChatSDK sharedSDK].rtsManager responseRTS:sessionID accept:YES option:nil completion:^(NSError * _Nullable error, NSString * _Nullable sessionID, UInt64 channelID) {
        NSLog(@"========%@ \n=======:%@\n=======%llu",error,sessionID,channelID);
        if (!error) {
            NSLog(@"接收成功");
        }
        else
        {
            NSLog(@"接受失败");
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
    _sessionID = sessionID;
    _peerID = callee;
     _cmds = [[NSMutableString alloc]initWithCapacity:1];
    
    if (accepted) {
        NSLog(@"====是否接听:%d",accepted);
//        [[NIMAVChatSDK sharedSDK].rtsManager terminateRTS:sessionID];
    }
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
//            [self showDrawView];
            NSLog(@"数据传输成功: %@", _cmds);
//            [_sendCmdsTimer startTimer:SendCmdIntervalSeconds delegate:self repeats:YES];
        }
        else {
            NSLog(@"已断开数据传输: %zd", error.code);
           
        }
    }
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
    NSString *cmd = [NSString stringWithFormat:@"%zd:%.3f,%.3f;", type, p.x/self.view.bounds.size.width, p.y/self.view.bounds.size.height];
    [self addCmd:cmd];
    
    //local render
    NSArray *point = [NSArray arrayWithObjects:@(p.x), @(p.y), nil];
    [_myDrawView addPoints:[NSMutableArray arrayWithObjects:point, nil]
                 isNewLine:(type == WhiteBoardCmdTypePointStart)];
}
- (void)addCmd:(NSString *)aCmd
{
    [_cmdsLock lock];
    [_cmds appendString:aCmd];
    [_cmdsLock unlock];

    if ([_cmds length] >= 0) {
        [self sendCmds];
    }
}
- (void)sendCmds
{
    [_cmdsLock lock];
    if ([_cmds length] > 0) {
        //        DDLogDebug(@"++++++send cmd id %llu", _refPacketID);
        NSString *cmd = [NSString stringWithFormat:@"%zd:%llu,0;", WhiteBoardCmdTypePacketID, _refPacketID ++];
        [_cmds appendString:cmd];
        
        [self sendRTSData:_cmds];
        [_cmds setString:@""];
    }
    [_cmdsLock unlock];
}

- (void)sendRTSData:(NSString *)data
{
    BOOL success = [[NIMAVChatSDK sharedSDK].rtsManager sendRTSData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                               from:_sessionID
                                                                 to:_peerID //单播和广播发送示例
                                                               with:NIMRTSServiceReliableTransfer];
    if (!success) {
        NSLog(@"======数据发送失败=======");
    }
}

/**
 *  收到实时会话数据
 *
 *  @param sessionID 实时会话ID
 *  @param data 收到的实时会话数据
 *  @param user 发送实时会话数据的用户
 *  @param channel 收发实时数据的服务通道
 */
- (void)onRTSReceive:(NSString *)sessionID
                data:(NSData *)data
                from:(NSString *)user
              withIn:(NIMRTSService)channel
{
    NSString *cmdString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    DDLogDebug(@"receive app data:%@", cmdString);
    NSArray *cmds = [cmdString componentsSeparatedByString:@";"];
    BOOL newLine = NO;
    NSMutableArray *points = [[NSMutableArray alloc] init];
    for (NSString *cmdString in cmds) {
        if ([cmdString rangeOfString:@":"].length == 0) {
            continue;
        }
        NSArray *cmd = [cmdString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":,"]];
        NSAssert(cmd.count == 3, @"Invalid cmd");
        
        NSInteger c = [cmd[0] integerValue];
        NSArray *point = [NSArray arrayWithObjects:
                          @([cmd[1] floatValue] * self.view.bounds.size.width),
                          @([cmd[2] floatValue] * self.view.bounds.size.height), nil];
        switch (c) {
            case WhiteBoardCmdTypePointStart:
                if ([points count] > 0) {
                    [_peerDrawView addPoints:points isNewLine:newLine];
                    points = [[NSMutableArray alloc] init];
                }
                newLine = YES;
            case WhiteBoardCmdTypePointMove:
            case WhiteBoardCmdTypePointEnd:
                [points addObject:point];
                break;
            case WhiteBoardCmdTypeCancelLine:
                [_peerDrawView deleteLastLine];
                break;
                //            case WhiteBoardCmdTypePacketID:
                //                DDLogDebug(@"------receive cmd id %@", cmd[1]);
                //                break;
            case WhiteBoardCmdTypeClearLines:
                [self clearWhiteboard];
                [self sendWhiteboardCmd:WhiteBoardCmdTypeClearLinesAck];
                break;
            case WhiteBoardCmdTypeClearLinesAck:
                [self clearWhiteboard];
                break;
            default:
                break;
        }
    }
    if ([points count] > 0) {
        [_peerDrawView addPoints:points isNewLine:newLine];
    }
}

- (void)clearWhiteboard
{
    [_myDrawView clear];
    [_peerDrawView clear];
}
- (void)sendWhiteboardCmd:(WhiteBoardCmdType)cmd
{
    NSString *cmdString = [NSString stringWithFormat:@"%zd:0,0;", cmd];
    [self addCmd:cmdString];
}

@end

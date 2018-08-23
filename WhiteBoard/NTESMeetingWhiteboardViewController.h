//
//  NTESMeetingWhiteboardViewController.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/25.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMAVChat/NIMAVChat.h>
#import "MBProgressHUD.h"
#import "NTESWhiteboardDrawView.h"
#import <AVOSCloud/AVOSCloud.h>


@interface NTESMeetingWhiteboardViewController : UIViewController<NIMRTSManagerDelegate>
{
    CGSize mMusicImageSize;
    UIAlertController *alertController ;
    NSString *mEastAccountID;
    NSString *mImagePath;
}
@property (strong, nonatomic) NTESWhiteboardDrawView *myDrawView;
@property (strong, nonatomic) NTESWhiteboardDrawView *peerDrawView;
@property (strong, nonatomic) NSLock *cmdsLock;
@property (strong, nonatomic) NSMutableString *cmds;
@property (assign, nonatomic) UInt64 refPacketID;
@property (copy, nonatomic) NSString *sessionID;
@property (copy, nonatomic) NSString *peerID;
@property (copy, nonatomic) UIImage *musicImage;
@property (assign, nonatomic) Boolean isSendImage;
@property (copy, nonatomic)NSMutableArray *mOriginDatas;
@property (copy, nonatomic)NSMutableArray *mOriginPeerDatas;
- (instancetype)initWithSessionID:(NSString *)sessionID :(NSString *)peerID;
- (instancetype)initWithImage :(UIImage *)musicImage musicImagePath:(NSString *)imgPath musicSize :(CGSize)size andTeacherEastID :(NSString *)eastAccountID :(NSMutableArray *)originDatas :(NSMutableArray *)originPeerDatas;

@end

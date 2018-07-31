//
//  NTESMeetingWhiteboardViewController.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/7/25.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMAVChat/NIMAVChat.h>
//#import "NTESWhiteboardViewController.h"


@interface NTESMeetingWhiteboardViewController : UIViewController<NIMRTSManagerDelegate>
{
    CGSize mMusicImageSize;
}
- (instancetype)initWithSessionID:(NSString *)sessionID :(NSString *)peerID;
- (instancetype)initWithImage :(UIImage *)musicImage musicSize :(CGSize)size;

@end

//
//  AppDelegate.h
//  MusicTrainer
//
//  Created by macbookpro on 2018/6/26.
//  Copyright © 2018年 macbookpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import <NIMSDK/NIMSDK.h>
#import <NIMSDK/NIMSDKOption.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (retain, nonatomic) AVIMClient *client;
@property (assign ,nonatomic) Boolean  isOpenIM;

- (void)saveContext;


@end


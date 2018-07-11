//
//  PathAPI.h
//  RemiVisitor
//
//  Created by chen on 15/11/19.
//  Copyright © 2015年 chenyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathAPI : NSObject
+ (NSDictionary *)get_user_info :(NSString *)file_name;
+ (NSString *)get_str_user_list_file_path :(NSString *)file_name;
+ (BOOL)saveUserInfoInLocal :(NSDictionary *)dicUserInfo;
@end

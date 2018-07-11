//
//  PathAPI.m
//  RemiVisitor
//
//  Created by chen on 15/11/19.
//  Copyright © 2015年 chenyue. All rights reserved.
//

#import "PathAPI.h"

@implementation PathAPI
+ (NSDictionary *)get_user_info :(NSString *)file_name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *file_path = [path stringByAppendingPathComponent:file_name];
    NSDictionary *dic_user_info = [[NSDictionary alloc]initWithContentsOfFile:file_path];
    return dic_user_info;
}
+ (NSString *)get_str_user_list_file_path :(NSString *)file_name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *file_path = [path stringByAppendingPathComponent:file_name];
    return file_path;
}
+ (BOOL)saveUserInfoInLocal :(NSDictionary *)dicUserInfo
{
    NSString *path = [PathAPI get_str_user_list_file_path :@"userInfo.plist"];
    NSMutableDictionary *dicNewUserInfo = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    if (dicNewUserInfo == nil)
        dicNewUserInfo = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (int i = 0; i < dicUserInfo.allKeys.count; i ++)
    {
        if (![[dicUserInfo objectForKey:[dicUserInfo.allKeys objectAtIndex:i]] isEqual:[NSNull null]])
        {
            [dicNewUserInfo setObject:[dicUserInfo objectForKey:[dicUserInfo.allKeys objectAtIndex:i]] forKey:[dicUserInfo.allKeys objectAtIndex:i]];
        }
    }
    BOOL isSuccess = [dicNewUserInfo writeToFile:path atomically:YES];
    return isSuccess;
}
@end

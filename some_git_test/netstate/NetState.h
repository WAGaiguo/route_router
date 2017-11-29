//
//  NetState.h
//  some_git_test
//
//  Created by wangaiguo on 2017/11/28.
//  Copyright © 2017年 wangaiguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetState : NSObject
// 通过状态栏的信息 获得当前连接的路由状态
+ (NSString *)getNetWorkStates;

@end

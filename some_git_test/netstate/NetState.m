//
//  NetState.m
//  some_git_test
//
//  Created by wangaiguo on 2017/11/28.
//  Copyright © 2017年 wangaiguo. All rights reserved.
//

#import "NetState.h"
#import <UIKit/UIKit.h>

@implementation NetState

+ (NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"_foregroundView"]subviews];
    int netType = 0;
    NSString *state = [[NSString alloc]init];
    //获取到网络返回码
    for (id child in children){
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            switch (netType) {
                case 0:
                    state = @"无网络";
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                    state = @"wifi";
                    break;
                default:
                    break;
            }
            
        }
        
    }
    return state;
}

@end

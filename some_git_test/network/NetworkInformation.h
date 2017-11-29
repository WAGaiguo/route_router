//
//  NetworkInformation.h
//  some_git_test
//
//  Created by wangaiguo on 2017/11/28.
//  Copyright © 2017年 wangaiguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkInformation : NSObject
// 获得当前连接路由的一些信息
@property (nonatomic, retain) NSString *deviceIP;
@property (nonatomic, retain) NSString *netmask;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *broadcast;
@property (nonatomic, retain) NSArray *ipsInRange;
- (void)updateData;
- (NSString *)description;
@end

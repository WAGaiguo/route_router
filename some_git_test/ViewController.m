//
//  ViewController.m
//  some_git_test
//
//  Created by wangaiguo on 2017/11/23.
//  Copyright © 2017年 wangaiguo. All rights reserved.
//

#import "ViewController.h"
#import "RouterAndRoutes.h"
#import "getgateway.h"
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "NetworkInformation.h"
#import "NetState.h"
#import "WAGview.h"

@interface ViewController ()
@property (nonatomic, strong)WAGview *agView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backgroundImg];


    
//    NSString *ipStr = [Route_Info getRouterIpAddress];
//
//    NSArray *routeArr = [Route_Info getRoutes];
//    [routeArr enumerateObjectsUsingBlock:^(Route_Info * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@", obj);
//    }];
//
//    NSLog(@"---------------------");
//    NSLog(@"%@", ipStr);
//    NSLog(@"---------------------");
    
    NSString *state =   [NetState getNetWorkStates];
    NSLog(@"当前连接网络信息：%@",state);
    _agView.stateLabel.text = state;

    
    
#pragma - 如果有用的话 - 准备用下面的方法
    
    
    NSLog(@"谷歌提供的某些大神的思路 方法");
#pragma 获取当前路由器的地址
    NSString *ruterIP = [self getGatewayIP];
    _agView.ruterIPLabel.text = ruterIP;
    
#pragma wifi -- name
//    NSLog(@"wifi----name");
    NSString *wifiName = [self GetCurrentWifiHotSpotName];
    NSLog(@"%@", wifiName);
    _agView.wifiNameLabel.text = wifiName;

#pragma public wifi IP
//    NSString *publicStr = [self getPublicIP];
//    NSLog(@"%@", publicStr);
    
    NSLog(@"============================");
    self.view.backgroundColor = [UIColor cyanColor];
    
    
#pragma 无意中就发现一个这么牛逼的方法  一下子获取那么多信息  确实挺厉害 ~~~~
    NSLog(@"--------------------------------------++++++++++++");
    NetworkInformation *network = [[NetworkInformation alloc]init];
    NSLog(@"%@", network);
    //    for(NSString *ip in network.ipsInRange){
    //        NSLog(@"ip: %@", ip);
    //    }
    _agView.netmaskLabel.text = [network netmask];
    _agView.netIPLabel.text = [network deviceIP];
    _agView.networkLabel.text = [network address];
    _agView.broadcastLabel.text = [network broadcast];
    NSLog(@"--------------------------------------++++++++++++");
    
    
}

/*
 *  这个目前也是只能得到路由器的IP
 */
- (NSString *)getGatewayIP {
    NSString *ipString = nil;
    struct in_addr gatewayaddr;
    int r = getdefaultgateway(&(gatewayaddr.s_addr));
    if(r >= 0) {
        ipString = [NSString stringWithFormat: @"%s",inet_ntoa(gatewayaddr)];
        NSLog(@"default gateway : %@", ipString );
    } else {
        NSLog(@"getdefaultgateway() failed");
    }
    
    return ipString;
    
}

/*
 *  目前这个方法只能真机上用  获取当前连接-WiFi-的信息
 */
- (NSString *)GetCurrentWifiHotSpotName {
    NSString *wifiName = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"ifs:::%@", ifs);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        // 打印当前连接路由的一些信息
        NSLog(@"info:%@", info);
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        }
    }
    return wifiName;
}


/*
 *
     SSID（Service Set Identifier）也可以写为ESSID，用来区分不同的网络，最多可以有32个字符，无线
     工作原理图
     工作原理图
     网卡通过连接不同的SSID（即AP）并输入相应AP的密码就可以进入不同网络，SSID通常由AP广播出来
 
     BSSID 是指站点的 MAC 地址，（STA）在一个接入点，（AP）在一个基础架构模式， BSS 是由 IEEE 802.11-1999 无线局域网规范定义的。这个区域唯一地定义了每个 BSS 。在一个 IBSS 中，BSSID 是一个本地管理的 IEEE MAC 地址，从一个 46 位的任意编码中产生。地址的个体/组位被设置为 0 。通用/本地地址位被设置为 1 。
 *
 */





/*
 *  简单测试 获取 URL IP
 */

- (NSString *)getPublicIP {
    NSString *publicIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://icanhazip.com/"] encoding:NSUTF8StringEncoding error:nil];
    publicIP = [publicIP stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return publicIP;
}




- (void)backgroundImg {
    UIImageView *imagev = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"秋"]];
    imagev.contentMode = UIViewContentModeScaleAspectFill;
    imagev.frame = self.view.bounds;
    [self.view addSubview:imagev];
    
    _agView = [[WAGview alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_agView];
    
}

/**
 // 原来iOS中 也有类似于 Python中的异常处理函数  try ... except ...
 @try {
 
 }
 @catch(NSException *exception){
 
 }
 **/







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

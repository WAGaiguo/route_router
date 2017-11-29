//
//  NetworkInformation.m
//  some_git_test
//
//  Created by wangaiguo on 2017/11/28.
//  Copyright © 2017年 wangaiguo. All rights reserved.
//

#import "NetworkInformation.h"
#import <arpa/inet.h>
#import <ifaddrs.h>

@implementation NetworkInformation
- (instancetype)init{
    self = [super init];
    if (self) {
        [self updateData];
    }
    return self;
}

-(void)updateData {
    [self updateDataFromWifiNetwork];
    self.address = [self getNetworkAddress];
    self.ipsInRange = [self getIPsInRange];
}

- (void)updateDataFromWifiNetwork {
    self.deviceIP = nil;
    self.netmask = nil;
    self.broadcast = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0){
        temp_addr = interfaces;
        while(temp_addr != NULL){
            if(temp_addr->ifa_addr->sa_family == AF_INET){
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]){
                    self.deviceIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    self.netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    self.broadcast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    if(!self.deviceIP || !self.netmask){
        NSLog(@"error in updateDataFromWifiNetwork, device ip: %@ netmask: %@", self.deviceIP, self.netmask);
    }
}

-(NSString*)getNetworkAddress {
    if(!self.deviceIP || !self.netmask){
        return nil;
    }
    unsigned int address = [self convertSymbolicIpToNumeric:self.deviceIP];
    address &= [self convertSymbolicIpToNumeric:self.netmask];
    return [self convertNumericIpToSymbolic:address];
}

-(NSArray*)getIPsInRange {
    unsigned int address = [self convertSymbolicIpToNumeric:self.address];
    unsigned int netmask = [self convertSymbolicIpToNumeric:self.netmask];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int numberOfBits;
    for (numberOfBits = 0; numberOfBits < 32; numberOfBits++) {
        if ((netmask << numberOfBits) == 0){
            break;
        }
    }
    int numberOfIPs = 0;
    for (int n = 0; n < (32 - numberOfBits); n++) {
        numberOfIPs = numberOfIPs << 1;
        numberOfIPs = numberOfIPs | 0x01;
    }
    for (int i = 1; i < (numberOfIPs) && i < numberOfIPs; i++) {
        unsigned int ourIP = address + i;
        NSString *ip = [self convertNumericIpToSymbolic:ourIP];
        [result addObject:ip];
    }
    return result;
}

-(NSString*)convertNumericIpToSymbolic:(unsigned int)numericIP {
    NSMutableString *sb = [NSMutableString string];
    for (int shift = 24; shift > 0; shift -= 8) {
        [sb appendString:[NSString stringWithFormat:@"%d", (numericIP >> shift) & 0xff]];
        [sb appendString:@"."];
    }
    [sb appendString:[NSString stringWithFormat:@"%d", (numericIP & 0xff)]];
    return sb;
}

-(unsigned int)convertSymbolicIpToNumeric:(NSString*)symbolicIP {
    NSArray *st = [symbolicIP componentsSeparatedByString: @"."];
    if (st.count != 4){
        NSLog(@"error in convertSymbolicIpToNumeric, splited string count: %lu", st.count);
        return 0;
    }
    int i = 24;
    int ipNumeric = 0;
    for (int n = 0; n < st.count; n++) {
        int value = [(NSString*)st[n] intValue];
        if (value != (value & 0xff)) {
            NSLog(@"error in convertSymbolicIpToNumeric, invalid IP address: %@", symbolicIP);
            return 0;
        }
        ipNumeric += value << i;
        i -= 8;
    }
    return ipNumeric;
}

-(NSString*)description {
    return [NSString stringWithFormat: @"\nip:%@\nnetmask:%@\nnetwork:%@\nbroadcast:%@", self.deviceIP, self.netmask, self.address, self.broadcast];
}

@end

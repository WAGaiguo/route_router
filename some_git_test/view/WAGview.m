//
//  WAGview.m
//  some_git_test
//
//  Created by wangaiguo on 2017/11/28.
//  Copyright © 2017年 wangaiguo. All rights reserved.
//

#import "WAGview.h"

@implementation WAGview

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *subView = [[NSBundle mainBundle]loadNibNamed:@"WAGview" owner:self options:nil].firstObject;
        subView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self addSubview:subView];
        [self afterView];
    }
    return self;
}
- (void)afterView{
}
@end

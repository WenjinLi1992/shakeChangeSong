//
//  WJSongModel.m
//  ShakeChangeSong
//
//  Created by lwj on 17/3/13.
//  Copyright © 2017年 WenJin Li. All rights reserved.
//

#import "WJSongModel.h"

@implementation WJSongModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _songName = @"";
        _singer = @"";
        _url = @"";
    }
    return self;
}
@end

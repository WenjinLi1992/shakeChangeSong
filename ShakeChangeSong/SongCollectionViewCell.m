//
//  SongCollectionViewCell.m
//  ShakeChangeSong
//
//  Created by lwj on 17/3/13.
//  Copyright © 2017年 WenJin Li. All rights reserved.
//

#import "SongCollectionViewCell.h"
#import "WJSongModel.h"
@implementation SongCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    _songNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, 25)];
    _songNameLabel.textColor = [UIColor cyanColor];
    [self addSubview:_songNameLabel];
    
    _singerNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, self.frame.size.width-10, 20)];
    _singerNameLabel.textColor = [UIColor grayColor];
    _singerNameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_singerNameLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(5, 45, self.frame.size.width-10, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
}
- (void)configCell:(WJSongModel*)model{
    _songNameLabel.text = model.songName;
    _singerNameLabel.text = model.singer;
}
@end

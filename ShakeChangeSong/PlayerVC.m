//
//  PlayerVC.m
//  ShakeChangeSong
//
//  Created by lwj on 17/3/13.
//  Copyright © 2017年 WenJin Li. All rights reserved.
//

#import "PlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "WJSongModel.h"
@interface PlayerVC ()
@property (nonatomic, strong) WJSongModel* model;

@end

@implementation PlayerVC
- (instancetype)initWithModel:(WJSongModel*)model
{
    self = [super init];
    if (self) {
        _model = [[WJSongModel alloc]init];
        _model.songName = model.songName;
        _model.singer = model.singer;
        _model.url = model.url;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initNaVigationBar];
    [self initView];
    
    
}
- (void)initView{
    
    UIButton* playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(10, 100, 50, 30);
    [playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:playBtn];
    
    UIButton* pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pauseBtn.frame = CGRectMake(10, 140, 50, 30);
    [pauseBtn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    pauseBtn.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:pauseBtn];
    
}
-(void) play{
    
}
- (void) pause {
    
}
- (void)initNaVigationBar{
    //UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:_model.songName];
    self.navigationItem.title = _model.songName;
    UIBarButtonItem *itemBtn =  [[UIBarButtonItem alloc]initWithTitle:@"BACK" style:UIBarButtonItemStyleDone target:self action:@selector(backbtnPressed)];
    self.navigationItem.leftBarButtonItem = itemBtn;
    
}
-(void)backbtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

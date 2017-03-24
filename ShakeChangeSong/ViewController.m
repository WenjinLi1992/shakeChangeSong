//
//  ViewController.m
//  ShakeChangeSong
//
//  Created by lwj on 17/3/13.
//  Copyright © 2017年 WenJin Li. All rights reserved.
//

#import "ViewController.h"
#import "PlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "WJSongModel.h"
#import "SongCollectionViewCell.h"
#define rctextCellIndentifier  @"rctextCellIndentifierID"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    int currentPlay;
    BOOL isHaveLocalMusic;//判断设备本身是否存在音乐
}
@property (nonatomic, strong) NSMutableArray* songsMutArray;
@property (nonatomic, strong) UICollectionView* collevtionView;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@property (nonatomic, strong) UILabel* showlabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initObj];
    [self loadLocalSongList];
    [self initView];
}
-(void) initView{
    UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    customFlowLayout.minimumLineSpacing = 0;
    customFlowLayout.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f,0.0f, 0.0f);
    customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collevtionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:customFlowLayout];
    [_collevtionView
     setBackgroundColor:[UIColor whiteColor]];
    _collevtionView.showsHorizontalScrollIndicator = NO;
    _collevtionView.alwaysBounceVertical = YES;
    _collevtionView.dataSource = self;
    _collevtionView.delegate = self;
    _collevtionView.showsVerticalScrollIndicator = NO;
    
    [_collevtionView registerClass:[SongCollectionViewCell class]forCellWithReuseIdentifier:rctextCellIndentifier];
    [self.view addSubview:_collevtionView];
   
    
    _showlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 30)];
    _showlabel.textColor = [UIColor whiteColor];
    _showlabel.backgroundColor = [UIColor orangeColor];
    _showlabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_showlabel];
    if (_songsMutArray.count == 0) {//手机媒体库没有本地音乐
        _showlabel.text = @"将播放程序自带音乐,点击任意一首歌开始";
        [self initData];
    }else{
         _showlabel.text = @"当前未播放歌曲,点击任意一首歌开始";
        isHaveLocalMusic = YES;
    }
    
    [_collevtionView reloadData];
}
- (void)initData{
    NSArray* songNameArray = @[@"李荣浩 - 老街.m4a",@"薛之谦 - 你还要我怎样.m4a",@"薛之谦 - 认真的雪.m4a",@"金南玲 - 逆流成河.mp3",@"马頔 - 南山南.m4a"];
    NSArray* realSongNameArr = @[@"老街",@"你还要我怎样",@"认真的雪",@"逆流成河",@"南山南"];
    NSArray* singerNameArray = @[@"李荣浩",@"薛之谦",@"薛之谦",@"金南玲",@"马頔"];
    for (int i = 0; i < 5; i++) {
        WJSongModel* model = [[WJSongModel alloc]init];
        model.songName = realSongNameArr[i];
        model.singer = singerNameArray[i];//
        model.url = [[NSBundle mainBundle] pathForResource:songNameArray[i] ofType:Nil];
        [_songsMutArray addObject:model];
    }
}
- (void) initObj{
    _songsMutArray = [[NSMutableArray alloc]initWithCapacity:0];
     currentPlay = 0;//当前未播放音乐
    isHaveLocalMusic = NO;
}
- (void)loadLocalSongList {
    if (_songsMutArray) {
        NSArray* array = [self getLocalList];
        if (array) {
            [_songsMutArray addObjectsFromArray:array];
        }
    }
}
- (NSArray*)getLocalList{//获取本地音乐文件，返回歌曲列表
    
    NSMutableArray *artistList = [[NSMutableArray alloc]initWithCapacity:0];
    MPMediaQuery *listQuery = [MPMediaQuery playlistsQuery];//播放列表
    NSArray *playlist = [listQuery collections]; //播放列表数组
    
    for (MPMediaPlaylist *list in playlist) {
        NSArray *songs = [list items];//歌曲数组
        for (MPMediaItem *song in songs) {
            NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];//歌曲名
            NSString *artist = [[song valueForProperty:MPMediaItemPropertyArtist] uppercaseString];//歌手名
            NSString *url = [[song valueForProperty:MPMediaItemPropertyAssetURL] absoluteString]; //歌曲链接
            WJSongModel *songModel = [[WJSongModel alloc]init];
            if (title) {
                songModel.songName = title;
            }else{
                songModel.songName = @"未知音乐";
            }
            if (artist) {
                songModel.singer = artist;
            }else{
                songModel.singer = @"未知歌手";
            }
            if (url) {
                songModel.url = url;
            }else break;
            if (![artistList containsObject:songModel]) {
                [artistList addObject:songModel];
            }
            
        }
    }
    return artistList;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playwithModel:(WJSongModel*) model{
    
    if (self.audioPlayer) {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
        }
        self.audioPlayer = nil;
    }
    if (!isHaveLocalMusic) {//不存在本地音乐
        NSData *data = [NSData dataWithContentsOfFile:model.url];
        if (!data) {
            _showlabel.text = @"当前音乐不存在";
            return;
        }
         self.audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
        
    }else{
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:model.url] error:nil];
    }
    [self.audioPlayer play];
    
    _showlabel.text = [NSString stringWithFormat:@"当前播放:%@",model.songName];
   
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _songsMutArray.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SongCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:rctextCellIndentifier forIndexPath:indexPath];
    WJSongModel* model = _songsMutArray[indexPath.item];
    [cell configCell:model];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WJSongModel* model = _songsMutArray[indexPath.item];
    [self playwithModel:model];
     currentPlay = (int)indexPath.item + 1;
    //PlayerVC* player = [[PlayerVC alloc]initWithModel:model];
    //[self.navigationController pushViewController:player animated:YES];
    
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width, 45);
}



-(BOOL)canBecomeFirstResponder
{
    
    return YES;
    
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event

{
    if(event.subtype == UIEventSubtypeMotionShake) {
        if (currentPlay+1 <= _songsMutArray.count) {//切换下一首歌曲
            WJSongModel* model = _songsMutArray[currentPlay];
            [self playwithModel:model];
            currentPlay += 1;
        }else if(currentPlay+1 > _songsMutArray.count){
            WJSongModel* model = _songsMutArray[0];
            [self playwithModel:model];
            currentPlay = 1;
        }
    }
    
}


@end

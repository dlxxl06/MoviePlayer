//
//  DLXPlayMovie.m
//  MoviePlayer
//
//  Created by admin on 15/9/21.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "DLXPlayMovie.h"
#import "ASIHTTPRequest.h"
#import <MediaPlayer/MediaPlayer.h>


@implementation DLXPlayMovie

unsigned long long recoderull;
MPMoviePlayerController *moviePlayer;
ASIHTTPRequest *request;
UIImageView *spinView;
BOOL canDownload;
-(void)viewDidLoad
{
    canDownload = YES;
   
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapEnterFullScreen) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapExitFullScreen) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(state) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    
    moviePlayer = [[MPMoviePlayerController alloc]init];
    [moviePlayer.view setFrame:_vedioView.frame];
    
    spinView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    [spinView setCenter:_vedioView.center];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i=0; i<24; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"b%ld.png",i]];
        [arr addObject:image];
    }
    [spinView setAnimationImages:arr];
    [spinView setAnimationDuration:1.0f];
    [_vedioView addSubview:spinView];
    [_vedioView setOpaque:YES];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(tapBackMainPage)];
    
    [self.navigationItem setLeftBarButtonItem:backItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    recoderull = 0;
    [self updateMovieMessage:_propList];
    
}

#pragma mark -更新视频信息
-(void)updateMovieMessage:(DLXMovieProp *)propList
{
    [_ownerImageView setImage:[UIImage imageNamed:@"user_default.png"]];
    [_ownerName setText:propList.ownerName];
    NSInteger h = propList.totalTime/3600000;
    NSInteger m = propList.totalTime/60000-h*60;
    NSInteger s = propList.totalTime%60;
    
    [_movieTime setText:[NSString stringWithFormat:@"%ld:%ld:%ld",h,m,s]];
    
    [_playTimes setText:[NSString stringWithFormat:@"%ld",propList.playTimes]];
    [_pubDate setText:propList.pubDate];
    [_mediaType setText:propList.mediaType];
    [_commentTimes setText:[NSString stringWithFormat:@"%ld",propList.commentCount]];
    [_favoTimes setText:[NSString stringWithFormat:@"%ld",propList.favorCount]];
    [_digCount setText:[NSString stringWithFormat:@"%ld",propList.digCount]];
    [_buryCount setText:[NSString stringWithFormat:@"%ld",propList.buryCount]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSURL *url = [NSURL URLWithString:propList.ownerPic];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (data!=nil)
                {
                    UIImage *image = [UIImage imageWithData:data scale:0.6];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_ownerImageView setImage:image];
                    });
                }
            }];
        }
    });
  
    //加载视频
    [self loadVideoPlayer];
}


-(void)loadVideoPlayer
{
    NSString *videoName = [NSString stringWithFormat:@"%ld.mp4",_propList.hash];
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Movies/Temp"];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Movies/Cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建文件
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //缓存完毕后在本地播放
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:videoName]]) {
        [ moviePlayer setContentURL:[NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:videoName]]];
        [moviePlayer play];
        request = nil;
    } else {
        request= [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
        //下载目录
        [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:videoName]];
        
        //临时下载目录
        [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:videoName]];
        
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setDouble:total forKey:@"file_length"];
            [userDefaults synchronize];
            recoderull+=size;
            if (recoderull>400000  && canDownload) {
                [self playVideo];
            }else if(!spinView.isAnimating){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinView setOpaque:NO];
                    [spinView startAnimating];
                });
            }
        }];
        [request setAllowResumeForFileDownloads:YES];
        [request startAsynchronous];
        
    }


}

-(void)playVideo
{
    if (!_isPlay)
    {
        [_vedioView addSubview:moviePlayer.view];
        [spinView stopAnimating];
        [spinView setOpaque:YES];
        NSURL *url =[[NSURL alloc ]initWithString:[NSString stringWithFormat:@"http://127.0.0.1:1234/%ld.mp4",_propList.hash]];
        [moviePlayer setContentURL:url];
        [moviePlayer play];
        _isPlay = !_isPlay;
    }
}
-(void)finished
{
    if (request)
    {
        _isPlay = !_isPlay;
        [request clearDelegatesAndCancel];
        request = nil;
    }
}
#pragma mark -私有方法
#pragma mark 返回按钮的事件
-(void)tapBackMainPage
{
    
    [moviePlayer stop];
    [request cancel];
    canDownload = NO;
    [moviePlayer.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setFullScreen:(FullScreenBlock)fullBlock
{
    _fullBlock = fullBlock;
}
#pragma mark -进入和退出全屏
-(void)tapEnterFullScreen
{
    _fullBlock(YES);
}
-(void)tapExitFullScreen
{
    _fullBlock(NO);
}
-(void)state
{
//    switch (moviePlayer.) {
//        case <#constant#>:
//            <#statements#>
//            break;
//            
//        default:
//            break;
//    }
//
}


@end



//
//  DLXPlayMovie.h
//  MoviePlayer
//
//  Created by admin on 15/9/21.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLXMovieProp.h"

typedef void(^FullScreenBlock)(BOOL isFull);

@interface DLXPlayMovie : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ownerImageView;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *movieTime;
@property (weak, nonatomic) IBOutlet UILabel *pubDate;
@property (weak, nonatomic) IBOutlet UILabel *mediaType;
@property (weak, nonatomic) IBOutlet UILabel *commentTimes;
@property (weak, nonatomic) IBOutlet UILabel *favoTimes;
@property (weak, nonatomic) IBOutlet UILabel *digCount;
@property (weak, nonatomic) IBOutlet UILabel *buryCount;
@property (weak, nonatomic) IBOutlet UILabel *playTimes;
@property (weak, nonatomic) IBOutlet UIView *vedioView;
@property (nonatomic,assign) BOOL isPlay;
@property (nonatomic,strong) DLXMovieProp *propList;
-(void)updateMovieMessage:(DLXMovieProp *)propList;

@property (nonatomic,strong) FullScreenBlock fullBlock;
-(void)setFullScreen:(FullScreenBlock )fullBlock;
@end

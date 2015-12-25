//
//  DLXMovieProp.h
//  MoviePlayer
//
//  Created by admin on 15/9/19.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLXMovieProp : NSObject
@property (nonatomic,strong) NSString *itemCode;
@property (nonatomic,strong) NSString *vcode;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *picUrl;
@property (nonatomic,assign) NSInteger totalTime;
@property (nonatomic,strong) NSString *pubDate;
@property (nonatomic,strong) NSString *ownerId;
@property (nonatomic,strong) NSString *ownerName;
@property (nonatomic,strong) NSString *ownerNickname;
@property (nonatomic,strong) NSString *ownerPic;
@property (nonatomic,strong) NSString *ownerURL;
@property (nonatomic,assign) NSInteger channelId;
@property (nonatomic,strong) NSString *outerPlayerUrl;
@property (nonatomic,strong) NSString *playUrl;
@property (nonatomic,strong) NSString *mediaType;
@property (nonatomic,assign) bool secret;
@property (nonatomic,strong) NSString *hdType;
@property (nonatomic,assign) NSInteger playTimes;
@property (nonatomic,assign) NSInteger commentCount;
@property (nonatomic,strong) NSString *bigPicUrl;
@property (nonatomic,strong) NSString *alias;
@property (nonatomic,assign) bool downEnable;
@property (nonatomic,strong) NSString *location;
@property (nonatomic,assign) NSInteger favorCount;
@property (nonatomic,strong) NSString *outerGPlayerUrl;
@property (nonatomic,assign) NSInteger digCount;
@property (nonatomic,assign) NSInteger buryCount;


@property (nonatomic,strong) UIImage *icon;
@end

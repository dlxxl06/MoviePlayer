//
//  DLXMovieTableViewCell.m
//  MoviePlayer
//
//  Created by admin on 15/9/21.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "DLXMovieTableViewCell.h"

@implementation DLXMovieTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageView setFrame:CGRectMake(10,5,94, 54)];
    [self.textLabel setFrame:CGRectMake(114, 10,250,54)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

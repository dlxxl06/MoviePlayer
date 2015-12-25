//
//  ViewController.m
//  MoviePlayer
//
//  Created by admin on 15/9/19.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import "DLXMovieProp.h"
#import "DLXMovieTableViewCell.h"


#define kWIFIHeight 20
#define kToolBarHeight 44


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_movieList;
    UITableView *_tableView;
    DLXPlayMovie *_playPage;
    NSInteger channelID;
    NSInteger _page;
}
@end

static NSString *tudouUrlStr = @"http://api.tudou.com/v6/video/top_list";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _movieList = [NSMutableArray array];
    channelID = 22;
    _page = 1;
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height-kToolBarHeight)];
    [_tableView setRowHeight:64.0f];
    [self.view addSubview:_tableView];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
   // [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //ToolBar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-kToolBarHeight, self.view.bounds.size.width, kToolBarHeight)];
    
    UIBarButtonItem *movieItem = [[UIBarButtonItem alloc]initWithTitle:@"电影" style:UIBarButtonItemStylePlain target:self action:@selector(itemMethod:)];
    
    [movieItem setTag:0];
    UIBarButtonItem *TVItem = [[UIBarButtonItem alloc]initWithTitle:@"电视" style:UIBarButtonItemStylePlain target:self action:@selector(itemMethod:)];
    
    [TVItem setTag:1];
    
    UIBarButtonItem *MusicItem = [[UIBarButtonItem alloc]initWithTitle:@"音乐" style:UIBarButtonItemStylePlain target:self action:@selector(itemMethod:)];
    
    [MusicItem setTag:2];
    
    UIBarButtonItem *CarItem = [[UIBarButtonItem alloc]initWithTitle:@"汽车" style:UIBarButtonItemStylePlain target:self action:@selector(itemMethod:)];
    
    [CarItem setTag:3];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    [toolBar setItems:@[spaceItem, movieItem,spaceItem,TVItem,spaceItem,MusicItem,spaceItem,CarItem,spaceItem]];
    [toolBar setBarTintColor:[UIColor grayColor]];
    [self.view addSubview:toolBar];
    
    
    [self loadDataFromNetWork:YES];
    [self setTitle:@"视频列表"];
    
}
#pragma mark -从网络加载数据
-(void)loadDataFromNetWork:(BOOL)changeChannel
{
    //从网络上获取数据
    NSURL *url = [NSURL URLWithString:tudouUrlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:3.0f];
    
    [request setHTTPMethod:@"POST"];
    NSString *httpBody = [NSString stringWithFormat:@"app_key=1952e9844c5283d5&format=json&channelId=%ld&pageNo=%ld&pageSize=15&orderBy=v",channelID,_page];
    [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data)
        {
//            NSString *datas = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",datas);
            
            NSDictionary *collectionDict = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if (changeChannel) {[_movieList removeAllObjects];}
            
            NSArray *collectionArr = collectionDict[@"results"];
            for (NSDictionary *dict in collectionArr)
            {
                DLXMovieProp *movie = [[DLXMovieProp alloc]init];
                [movie setValuesForKeysWithDictionary:dict];
                [_movieList addObject:movie];
            }
            [_tableView reloadData];
        }
       
    }];
}
#pragma mark -私有方法
#pragma mark 按钮的事件
-(void)itemMethod:(UIBarButtonItem *)sender
{

    switch (sender.tag)
    {
        case 0:
            channelID = 22;
            break;
        case 1:
            channelID = 30;
            break;
        case 2:
            channelID = 14;
            break;
        case 3:
            channelID = 26;
            break;
        default:
            break;
    }
    _page = 1;
    [self loadDataFromNetWork:YES];
}
#pragma mark -UITableView的数据源代理方法
#pragma mark 行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _movieList.count+1;
    
}
#pragma mark 设置单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static   NSString *cellID = @"MoviewCell";
    DLXMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[DLXMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    //最后一个单元格为加载更多
    if (indexPath.row ==_movieList.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lastCell"];
        if (!cell) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"lastCell"];
        }
        [cell.textLabel setText:@"加载更多"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureMethod)];
        [cell.textLabel addGestureRecognizer:tapGesture];
        return cell;
    }
    
    DLXMovieProp *p = _movieList[indexPath.row];
    [cell.textLabel setText:p.title];
    [cell.textLabel setNumberOfLines:2];
    if (!p.icon)
    {
        p.icon = [UIImage imageNamed:@"user_default.png"];
        [self loadIconAsynchronous:indexPath];
    }
    [cell.imageView setImage:p.icon];
     return cell;
}
#pragma mark 选择单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_playPage)
    {
        _playPage = [[DLXPlayMovie alloc]init];
    }
     [_playPage setPropList:_movieList[indexPath.row]];
    [self.navigationController pushViewController:_playPage animated:YES];
    [_playPage setFullScreen:^(BOOL isFull) {
        _isFull = isFull;
    }];
}

#pragma mark -从后台加载图片
-(void)loadIconAsynchronous:(NSIndexPath *)indexPath
{
    DLXMovieProp *p =_movieList[indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:p.picUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data!=nil)
        {
            UIImage *icon = [UIImage imageWithData:data scale:0.75];
            p.icon = icon;
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}
#pragma mark -加载更多
-(void)tapGestureMethod
{
    _page++;
    [self loadDataFromNetWork:NO];

}
@end

//
//  MSMusicSliderView.m
//  MS3Tool
//
//  Created by chao on 2016/12/30.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSMusicSliderView.h"

//#import "TuijianView.h"

//#import "RemenView.h"
#import "KWMusicView.h"

#import "CategoryView.h"

#import "BangdanView.h"

#import "ZhuboView.h"

#import "BroadCastContentView.h"



typedef enum : NSInteger{
    
    tag_tuijian = 110,
    
    tag_yinyue,
    
    tag_jiemu,
    
    tag_guangbo,
    
    tag_diantai
}Tag_Views;



static const NSInteger kTopViewHeight = 40.f;

static const NSInteger kSliderViewHeight = 2.f;

static const NSInteger kFirstButtonTag = 25;




@interface MSMusicSliderView ()<UIScrollViewDelegate>

///@brife 当前选中页数
@property (assign) NSInteger currentPage;

///@brife 整个视图的大小
@property (assign) CGRect mViewFrame;

///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViewArray;

///@brife 上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;

///@brife 上方的view
@property (strong, nonatomic) UIView *topMainView;

///@brife 下面滑动的View
@property (strong, nonatomic) UIView *slideView;

///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *contentScrollView;

///@brife 下方的内容视图
@property (strong, nonatomic) NSMutableArray *contentViewsArray;


@end




@implementation MSMusicSliderView

-(instancetype)initWithFrame:(CGRect)frame WithCount:(NSInteger)count {
    
    if (self = [super initWithFrame:frame]) {
        
        _mViewFrame = frame;
        
        _tabCount = count;
        
        _topViewArray = [[NSMutableArray alloc] init];
        
        [self initTopTabs];
        
        [self initSlideView];
        
        [self initScrollView];
        
        [self initContentView];

    }
    
    return self;
}


#pragma mark -- 实例化顶部的tab
-(void) initTopTabs{
    
    CGFloat width = _mViewFrame.size.width / 6;
    
    if(self.tabCount <= 6){
        
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, kTopViewHeight)];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, kTopViewHeight)];
    
    _topScrollView.showsHorizontalScrollIndicator = NO;
    
    _topScrollView.showsVerticalScrollIndicator = NO;
    
    _topScrollView.bounces = NO;

    
    if (_tabCount >= 6) {
        
        _topScrollView.contentSize = CGSizeMake(width * _tabCount, kTopViewHeight);
        
    } else {
        
        _topScrollView.contentSize = CGSizeMake(_mViewFrame.size.width, kTopViewHeight);
    }
    
    [self addSubview:_topMainView];
    
    [_topMainView addSubview:_topScrollView];
    
    
    
    NSArray *buttonTitleArr = @[@"音乐", @"节目", @"广播", @"电台"];
    
    for (int i = 0; i < _tabCount; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, kTopViewHeight)];
        
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, kTopViewHeight)];
        
        button.tag = kFirstButtonTag + i;
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setTitle:buttonTitleArr[i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:button];
        
        
        [_topViewArray addObject:view];
        
        [_topScrollView addSubview:view];
    }
}


#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{

    CGFloat width = _mViewFrame.size.width / 6;
    
    if(self.tabCount <= 6){
        
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight - kSliderViewHeight, width, kSliderViewHeight)];
    
    [_slideView setBackgroundColor:WCSearchColor];
    
    // 添加一条分界线
    CGPoint center = _topMainView.center;
    
    center.y = _slideView.center.y;
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 2)];
    
    lineLabel.center = center;
    
    lineLabel.backgroundColor = WCBgGray;
    
    [_topScrollView addSubview:lineLabel];
    // 添加一条分界线
    
    [_topScrollView addSubview:_slideView];
    
    
    
    
    [self setButtonStatus];
}


#pragma mark -- 实例化ScrollView
-(void) initScrollView{
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topMainView.frame), _mViewFrame.size.width, _mViewFrame.size.height - CGRectGetMaxY(_topMainView.frame))];
    
    _contentScrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, _mViewFrame.size.height - CGRectGetMaxY(_topMainView.frame));
    
    _contentScrollView.pagingEnabled = YES;
    
    _contentScrollView.directionalLockEnabled = YES;
    
    _contentScrollView.showsVerticalScrollIndicator = NO;
    
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    
    _contentScrollView.delegate = self;
    
    [self addSubview:_contentScrollView];
}


#pragma mark -- 实例化 contentView
-(void)initContentView {

//    NSArray *buttonTitleArr = @[@"音乐", @"节目", @"广播", @"电台"];
    NSArray *tempViewsArr = @[@"KWMusicView", @"CategoryView", @"BroadCastContentView", @"ZhuboView"];
    
    CGFloat cWidth = _contentScrollView.width;
    
    CGFloat cHeight = _contentScrollView.height;
    
    for (int i = 0; i < tempViewsArr.count; i++) {
        
        Class myClass = NSClassFromString(tempViewsArr[i]);
        
        UIView *subView = [[myClass alloc] initWithFrame:CGRectMake(cWidth * i, 0, cWidth, cHeight)];
        
        subView.tag = tag_yinyue + i;
        
        [_contentScrollView addSubview:subView];
    }
    
    __weak typeof(&*self) sself = self;

    // 推荐
//    TuijianView *tuijianV = [self.contentScrollView viewWithTag:tag_tuijian];
    // 音乐
    KWMusicView *yinyueV = [self.contentScrollView viewWithTag:tag_yinyue];
    // 节目
    CategoryView *jiemuV = [self.contentScrollView viewWithTag:tag_jiemu];
    // 广播
    BroadCastContentView *guangboV = [self.contentScrollView viewWithTag:tag_guangbo];
    // 电台
    ZhuboView *diantaiV = [self.contentScrollView viewWithTag:tag_diantai];
    
    guangboV.presentClickBlock = ^(NSInteger clickTag) {

        sself.broadCastClick(clickTag);
    };

    jiemuV.categoryBlock = ^(XMCategory *category) {

        sself.categoryBlock(category);
    };
    
//    TuijianView *view1 = [[TuijianView alloc] initWithFrame:CGRectMake(0, 0, cWidth, cHeight)];
//    
//    [_contentScrollView addSubview:view1];
//    
//    
////    BroadCastContentView *bView = [[BroadCastContentView alloc] initWithFrame:CGRectMake(cWidth, 0, cWidth, cHeight)];
////    
////    [_contentScrollView addSubview:bView];
//    
//    
//    RemenView *view2 = [[RemenView alloc] initWithFrame:CGRectMake(cWidth, 0, cWidth, cHeight)];
//    
//    [_contentScrollView addSubview:view2];
//    
//    
//    CategoryView *view3 = [[CategoryView alloc] initWithFrame:CGRectMake(cWidth * 2, 0, cWidth, cHeight)];
//    
//    [_contentScrollView addSubview:view3];
//    
//    
//    BangdanView *view4 = [[BangdanView alloc] initWithFrame:CGRectMake(cWidth * 3, 0, cWidth, cHeight)];
//    
//    [_contentScrollView addSubview:view4];
//    
//    
//    ZhuboView *view5 = [[ZhuboView alloc] initWithFrame:CGRectMake(cWidth * 4, 0, cWidth, cHeight)];
//    
//    [_contentScrollView addSubview:view5];
    
    
    
//    __weak typeof(&*self) sself = self;
 
    
//    bView.presentClickBlock = ^(NSInteger clickTag) {
//        
//        sself.broadCastClick(clickTag);
//    };
    
//    view3.categoryBlock = ^(XMCategory *category) {
//        
//        sself.categoryBlock(category);
//    };
}

#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (id) sender{
    
    UIButton *button = sender;
    
    [_contentScrollView setContentOffset:CGPointMake((button.tag - kFirstButtonTag) * _mViewFrame.size.width, 0) animated:YES];
    
    [self setButtonStatus];
}





#pragma mark -- scrollView的代理方法
-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    
    if ([_topScrollView isEqual:scrollView]) {
        
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            
            sumStep = width * (count + 1);
            
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        
        return;
    }
    
}


// 点击按钮的时候要走这个方法来复用 tableView
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_contentScrollView])
    {
        _currentPage = _contentScrollView.contentOffset.x/_mViewFrame.size.width;
        
        [self setButtonStatus];
        
        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([_contentScrollView isEqual:scrollView])
    {
        CGRect frame = _slideView.frame;
        
        if (self.tabCount <= 6)
        {
            frame.origin.x = scrollView.contentOffset.x / _tabCount;
        } else
        {
            frame.origin.x = scrollView.contentOffset.x / 6;
            
        }
        
        _slideView.frame = frame;
    }
}

/**
 *  设置按钮选中状态
 */
- (void)setButtonStatus {
    
    for (int i = 0; i < _tabCount; i++) {
        
        UIButton *btn = [self viewWithTag:i + kFirstButtonTag];
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        if (i == _currentPage) {
            
            [btn setTitleColor:WCSearchColor forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
}

@end

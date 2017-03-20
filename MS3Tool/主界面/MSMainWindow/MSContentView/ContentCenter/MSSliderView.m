//
//  MSSliderView.m
//  MS3Tool
//
//  Created by chao on 2016/12/14.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "MSSliderView.h"

#import "MSMusicSliderView.h"

#import "MSMainContentView.h"

#import "MSVoiceView.h"

#import "MSPanScroll.h"



static const NSInteger kTopViewHeight = NAVIGATIONBAR_HEIGHT;

static const NSInteger kTopContentViewHeight = 24.f;

static const NSInteger kTopButtonWidth = 80.f;

static const NSInteger kTopButtonHeight = 40.f;

static const NSInteger kTopButtonUnselectFont = 18.f;

static const NSInteger kTopbuttonSelectedFont = 20.f;

static const NSInteger kSearchHeight = 40.f;

static UIColor *kHeadViewColor = nil;







@interface MSSliderView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

///@brife 按钮的个数
@property (assign) NSInteger tabCount;

///@brife 当前选中页数
@property (assign) NSInteger currentPage;

///@brife 整个视图的大小
@property (assign) CGRect mViewFrame;

///@brife 按钮标题数组
@property (nonatomic, strong) NSArray *titleArray;

///@brife 头部视图
@property (strong, nonatomic) UIView *topMainView;

///@brife 搜索视图
@property (nonatomic, strong) UIView *searchView;

///@brife 下方的 ScrollView 画布
@property (strong, nonatomic) UIScrollView *contentScrollView;


@property (nonatomic, strong) NSMutableArray *contentViewsArray;




@end

@implementation MSSliderView

#pragma mark - init

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _mViewFrame = frame;
        
        [self initData];
        
        _contentViewsArray = [NSMutableArray arrayWithCapacity:0];
        
        [self initTopView];
        
        [self initSearchView];
        
        [self initScrollView];
        
        [self initContentView];
        
        
    }
    
    return self;
}


- (void)initData {

    _tabCount = 3;
    
    _currentPage = 0;
    
    _titleArray = @[@"我的", @"音乐", @"音箱"];
    
    kHeadViewColor = WCDarkBlue;
    
    self.backgroundColor = WCBgGray;
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:nil];
    
    panGes.delegate = self;
    
    [self addGestureRecognizer:panGes];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        
        CGPoint pos = [pan velocityInView:pan.view];

        if (pos.x > 0 && !_currentPage) {
            
            self.contentScrollView.scrollEnabled = NO;
            
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    self.contentScrollView.scrollEnabled = YES;
    
    return YES;
    
}


#pragma mark -- 实例化顶部的view
-(void) initTopView {

    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kTopViewHeight)];
   
    topView.backgroundColor = WCDarkBlue;
    
    
    //  左边菜单按钮
    UIButton *leftBtn = [WenChaoControl createButtonWithFrame:CGRectMake(10, kTopContentViewHeight, 40, 40) ImageName:@"001headBar_menu" Target:self Action:@selector(buttonClick:) Title:nil];
    
    leftBtn.tag = leftButtonTag;
    
    [topView addSubview:leftBtn];

    
    //  右边
    UIButton *rightBtn = [WenChaoControl createButtonWithFrame:CGRectMake(SCREENW - 50, kTopContentViewHeight, 40, 40) ImageName:@"lianjie" Target:self Action:@selector(buttonClick:) Title:nil];
    
    rightBtn.backgroundColor = WCClear;
    
    rightBtn.tag = rightButtonTag;
    
    [topView addSubview:rightBtn];
    
    
    UIView *buttonsView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH - kTopButtonWidth * _tabCount) / 2, kTopContentViewHeight, kTopButtonWidth * _tabCount, kTopButtonHeight)];
    
    for (int i = 0; i < _tabCount; i ++) {
        
        UIButton *btn = [WenChaoControl createButtonWithFrame:CGRectMake(kTopButtonWidth * i, 0, kTopButtonWidth, kTopButtonHeight) ImageName:nil Target:self Action:@selector(buttonClick:) Title:_titleArray[i]];
        
        btn.tag = centerFirstButtonTag + i;
        
        [btn setBackgroundColor:WCClear];
        
        btn.titleLabel.textColor = WCWhite;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:kTopButtonUnselectFont];
        
        btn.alpha = 1;
        
        [buttonsView addSubview:btn];
    }
    
    [topView addSubview:buttonsView];
    
    [self addSubview:topView];
    
    _topMainView = topView;
    
    [self setButtonStatus];
}

#pragma mark -- 实例化searchView
- (void) initSearchView {
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(_topMainView.frame), WIDTH, kSearchHeight);
    
    _searchView = [[UIView alloc] initWithFrame:frame];
    
    _searchView.backgroundColor = kHeadViewColor;
    
    
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, WIDTH - 20, 30)];
    
    searchBgView.backgroundColor = WCDarkBlue;
    
    [_searchView addSubview:searchBgView];
    
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
    
    [_searchView addGestureRecognizer:tapOne];
    
    
    UILabel *searchLabel = [WenChaoControl createLabelWithFrame:searchBgView.frame Font:14 Text:@"搜 索" textAlignment:1];

    searchLabel.backgroundColor = WCSearchColor;
    
    searchLabel.userInteractionEnabled = YES;
    
    searchLabel.layer.cornerRadius = 3;
    
    searchLabel.layer.masksToBounds = YES;
    
    [searchLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1]];
    
    [_searchView addSubview:searchLabel];
    
    [self addSubview:_searchView];
}


#pragma mark -- 实例化ScrollView
-(void) initScrollView{

    CGFloat footerHeight = [[MSFooterManager shareManager] getHeightOfFooter];
    
    CGFloat sHeight = HEIGHT - footerHeight - CGRectGetMaxY(_topMainView.frame);
    
    MSPanScroll *scrollView = [[MSPanScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topMainView.frame), WIDTH, sHeight)];

    scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, WIDTH - CGRectGetMaxY(_topMainView.frame));
    
    scrollView.pagingEnabled = YES;

    scrollView.delegate = self;

    [self insertSubview:scrollView belowSubview:_searchView];
    
    _contentScrollView = scrollView;
}



#pragma mark - reset
#pragma mark -- 实例化内容View
- (void) initContentView {
    
    /**
     * 标题 - 我的 *
     */
    MSMainContentView *msContentView = [[MSMainContentView alloc] initWithFrame:CGRectMake(0, 0, _contentScrollView.width, _contentScrollView.height)];

    [_contentScrollView addSubview:msContentView];
    
    [_contentViewsArray addObject:msContentView];
    
    
    /**
     * 标题 - 音乐圈 *
     */
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(WIDTH, 0, _contentScrollView.width, _contentScrollView.height)];
//    
//    UILabel *descLabel = [WenChaoControl createLabelWithFrame:CGRectMake(0, 0, _contentScrollView.width, _contentScrollView.height) Font:30 Text:@"正在建设中..." textAlignment:1];
//    
//    [view addSubview:descLabel];
//    
//    [_contentScrollView addSubview:view];
//    
//    [_contentViewsArray addObject:view];
    
    
    /**
     * 标题 - 音乐 *
     */
    MSMusicSliderView *musicSliderView = [[MSMusicSliderView alloc] initWithFrame:CGRectMake(WIDTH, 0, _contentScrollView.width, _contentScrollView.height) WithCount:4];
    
    [_contentScrollView addSubview:musicSliderView];
    
    [_contentViewsArray addObject:musicSliderView];
    
    
    /**
     * 标题 - 音箱 *
     */
    MSVoiceView *voiceView = [[MSVoiceView alloc] initWithFrame:CGRectMake(WIDTH * 2, kSearchHeight, _contentScrollView.width, _contentScrollView.height - kSearchHeight)];
    
    [_contentScrollView addSubview:voiceView];
    
    [_contentViewsArray addObject:voiceView];

    
    __weak typeof (&*self) sself = self;

    
    /*****       设置searchView       ******/
    // 按顺序记录 searchView 中的 frame，和设置高度为 0 的 frame
    NSMutableArray *subViewsHeightArr = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableArray *subViewsZeroArr = [NSMutableArray arrayWithCapacity:0];

    for (UIView *subView in [_searchView subviews]) {
        
        [subViewsHeightArr addObject:NSStringFromCGRect(subView.frame)];
        
        CGRect frame = subView.frame;
        
        frame.size.height = 0;
        
        [subViewsZeroArr addObject:NSStringFromCGRect(frame)];
    }
    
    //  我的界面
    msContentView.shouldHiddenSearchView = ^(BOOL shouldHidden) {
        
//        [sself resetSearchViewStatus:shouldHidden heightArray:subViewsHeightArr zeroArray:subViewsZeroArr];
        [sself hidSearchViewWithOffset:shouldHidden];
    };
    
    msContentView.buttonViewClickBlock = ^(ButtonsClickTag clickTag) {
        
        sself.buttonsViewClickBlock(clickTag);
    };
    
    // 音乐分类点击事件
    musicSliderView.categoryBlock = ^(XMCategory *category) {
        
        sself.categoryBlock(category);
    };
    
    // 广播排行榜
    musicSliderView.broadCastClick = ^(NSInteger clickTag) {
        
        sself.broadClick(clickTag);

    };
    
    [self bringSubviewToFront:_topMainView];
}

#pragma mark -- 根据 contentView 的滑动 来设置 searchView 的状态
- (void)hidSearchViewWithOffset:(BOOL)shouldHidden {
    
    CGRect frame = self.searchView.frame;
    
    if (shouldHidden) {
        
        frame.origin.y = kTopViewHeight - kSearchHeight;
        
    } else {
        
        frame.origin.y = kTopViewHeight;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.searchView.frame = frame;
    }];
}

- (void)resetSearchViewStatus:(BOOL)shouldHidden heightArray:(NSArray *)subViewsHeightArr zeroArray:(NSArray *)subViewsZeroArr {

    CGRect frame = self.searchView.frame;
    
    NSArray *tempArr;
    
    if (shouldHidden) {
        
        frame.size.height = 0;
        
        tempArr = [NSArray arrayWithArray:subViewsZeroArr];
        
    } else {
        
        frame.size.height = kSearchHeight;
        
        tempArr = [NSArray arrayWithArray:subViewsHeightArr];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.searchView.frame = frame;
        
        for (int i = 0; i < [[self.searchView subviews] count]; i++) {
            
            UIView *subView = [[self.searchView subviews] objectAtIndex:i];
            
            subView.frame = CGRectFromString(tempArr[i]);
        }
    }];
}


#pragma mark - touch
#pragma mark -- 点击顶部的按钮所触发的方法
- (void) buttonClick: (UIButton *)btn {
    
    if (btn.tag == leftButtonTag || btn.tag == rightButtonTag) {
      
        self.clickBlock(btn.tag);
        
    } else {
        
        _currentPage = btn.tag - centerFirstButtonTag;
        
        [self setButtonStatus];
        
        CGPoint point = self.contentScrollView.contentOffset;
        
        point.x = _currentPage * WIDTH;
        
        [self.contentScrollView setContentOffset:point];
    }
}

- (void) searchClick {
    
    self.kugouSearchVC();
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _currentPage = _contentScrollView.contentOffset.x / WIDTH;
    
    [self setButtonStatus];
}


#pragma mark - 设置按钮选中状态
- (void)setButtonStatus {
    
    for (int i = 0; i < _tabCount; i++) {
        
        UIButton *btn = [self viewWithTag:i + centerFirstButtonTag];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:kTopButtonUnselectFont];
        
        if (i == _currentPage) {
            
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:kTopbuttonSelectedFont];
            
        }
    }

    [self resetSubviews];
}

- (void)resetSubviews {
    
    CGRect sFrame = self.searchView.frame;
    
    if (self.currentPage == 1) {
        
        sFrame.origin.y = kTopViewHeight - kSearchHeight;
        
    } else {
        
        sFrame.origin.y = kTopViewHeight;
    }
    
    self.searchView.frame = sFrame;
}
@end

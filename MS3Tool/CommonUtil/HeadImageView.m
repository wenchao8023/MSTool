//
//  HeadImageView.m
//  MS3Tool
//
//  Created by chao on 2017/1/3.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "HeadImageView.h"



@interface HeadImageView () <UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger imageCount;


@end

@implementation HeadImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
    }
    
    return self;
}

- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        
        _scrollView.delegate = self;
        
        _scrollView.pagingEnabled = YES;
        
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    
    return _scrollView;
}


#pragma mark - -- 给控件赋值
- (void)configBanner:(NSArray *)bannerArr {
    
    for (UIView *subView in self.subviews) {
        
        [subView removeFromSuperview];
    }
    
    
    [self addSubview:self.scrollView];
    

    self.imageCount = bannerArr.count;
    
    NSInteger count = self.imageCount + 2;
    
    if (count > 2) {
        
        self.scrollView.contentSize = CGSizeMake(self.width * count, self.height);
        
        self.scrollView.contentOffset = CGPointMake(self.width, 0);
        
        for (int i = 0; i  < count; i++) {
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.width, 0, self.width, self.height)];
            
            [self.scrollView addSubview:imageV];
        
            
            XMBanner *banner;
            
            if (i == 0) {
                
                banner = [bannerArr lastObject];
                
            } else if (i == count - 1) {
                
                banner = [bannerArr firstObject];
                
            } else {
                
                banner = bannerArr[i - 1];
            }
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:banner.bannerUrl]];
        }
        
        
        UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake((self.width - 20 * (count - 2)) / 2, self.height - 20, 20 * (count - 2), 10)];
        
        page.numberOfPages = count - 2;
        
        page.pageIndicatorTintColor = WCGray;
        
        page.currentPageIndicatorTintColor = WCWhite;
        
        page.userInteractionEnabled = NO;
        
        [self addSubview:page];
        
        _pageControl = page;
        
        
        if (count > 3) {
            
            [self performSelector:@selector(createTimer) withObject:nil afterDelay:5.0];
            
        } else {
            
            self.pageControl.hidden = YES;
            
            self.scrollView.contentSize = CGSizeMake(self.width, self.height);
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
        }
    }
}
#pragma mark -- 创建定时器
- (void) createTimer {
    
    if (!_timer) {
    
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(playImages) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [self.timer fire];
    }
}
#pragma mark -- 播放图片
- (void) playImages {
    
    CGPoint point = self.scrollView.contentOffset;
    
    point.x += self.width;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.scrollView setContentOffset:point];
    }];
    
    if (self.scrollView.contentOffset.x / self.width == self.imageCount + 1) {
        
        point.x = self.width;
        
        [self.scrollView setContentOffset:point];
    }
    
    _pageControl.currentPage = self.scrollView.contentOffset.x / self.width - 1;
}

#pragma mark - -- scrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.scrollView] && self.imageCount) {
        
        CGPoint point = self.scrollView.contentOffset;
        
        if (self.scrollView.contentOffset.x == 0) {
            
            point.x = self.width * self.imageCount;
            
            self.scrollView.contentOffset = point;
            
        } else if (self.scrollView.contentOffset.x / self.width == self.imageCount + 1) {
            
            point.x = self.width;
            
            self.scrollView.contentOffset = point;
        }
        
        _pageControl.currentPage = self.scrollView.contentOffset.x / self.width - 1;
    }
}

@end

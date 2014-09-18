//
//  ABPeakingCarouselView.m
//  Peaking Carousel
//
//  Created by Aldrin Balisi on 6/27/14.
//  Copyright (c) 2014 Aldrin Balisi. All rights reserved.
//

#import "ABPeakingCarouselView.h"

@interface ABPeakingCarouselView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *leadScrollView;
@property (nonatomic, strong) UIScrollView *followScrollView;
@end

#define CIRCLE_MASK_ORIGIN_Y 0.32
#define CIRCLE_MASK_RADIUS 200

#define TITLE_ORIGIN_Y 0.56
#define DESCRIPTION_ORIGIN_Y 0.64
#define SCROLL_MULTIPLIER 2.0

@implementation ABPeakingCarouselView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:62.0/255.0 blue:80.0/255.0 alpha:1.0];
        self.leadScrollView.frame = frame;
        self.followScrollView.frame = frame;
        
        [self addSubview:self.leadScrollView];
        [self addSubview:self.followScrollView];
        [self addSubview:self.pageControl];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [self reload];
}

#pragma mark - View Instantiation Methods

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.tintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pageControl;
}

- (UIScrollView *)leadScrollView
{
    if (!_leadScrollView) {
        _leadScrollView = [[UIScrollView alloc] init];
        _leadScrollView.backgroundColor = [UIColor whiteColor];
        _leadScrollView.delegate = self;
        _leadScrollView.pagingEnabled = YES;
        _leadScrollView.showsHorizontalScrollIndicator = NO;
        _leadScrollView.showsVerticalScrollIndicator = NO;
    }
    return  _leadScrollView;
}

-(UIScrollView *)followScrollView
{
    if (!_followScrollView) {
        _followScrollView = [[UIScrollView alloc] init];
        _followScrollView.userInteractionEnabled = NO;
        _followScrollView.showsHorizontalScrollIndicator = NO;
        _followScrollView.showsVerticalScrollIndicator = NO;
    }
    return _followScrollView;
}

- (NSAttributedString *)titleTextForIndex:(NSUInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(carousel:titleAtIndex:)]) {
        return [self.dataSource carousel:self titleAtIndex:index];
    }
    return nil;
}

- (NSAttributedString *)descriptionTextForIndex:(NSUInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(carousel:descriptionAtIndex:)]) {
        return [self.dataSource carousel:self descriptionAtIndex:index];
    }
    return nil;
}

#pragma mark - Action Methods

- (void)reload
{
    if (self.dataSource) {
        // Lead Scroll View
        [self.leadScrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view removeFromSuperview];
        }];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(self.frame.size.width * 0.5 - CIRCLE_MASK_RADIUS / 2, self.frame.size.height * CIRCLE_MASK_ORIGIN_Y - CIRCLE_MASK_RADIUS / 2, CIRCLE_MASK_RADIUS, CIRCLE_MASK_RADIUS);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, nil, maskRect);
        maskLayer.path = path;
        CGPathRelease(path);
        self.leadScrollView.layer.mask = maskLayer;
        
        CGFloat xValue = 0;
        for (int index = 0; index < [self.dataSource numberOfViewsForCarousel:self]; index ++) {
            UIView *view = [self.dataSource carousel:self viewAtIndex:index];
            view.frame = CGRectMake(xValue, self.frame.size.height * CIRCLE_MASK_ORIGIN_Y - self.frame.size.height / 2, self.frame.size.width, self.frame.size.height);
            view.contentMode = UIViewContentModeCenter;
            [self.leadScrollView addSubview:view];
            
            if ([self titleTextForIndex:index]) {
                UILabel *titleLabel = [[UILabel alloc] init];
                titleLabel.frame = CGRectMake(xValue * SCROLL_MULTIPLIER, self.frame.size.height * TITLE_ORIGIN_Y, self.frame.size.width, 44.0);
                titleLabel.adjustsFontSizeToFitWidth = YES;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = [UIColor whiteColor];
                titleLabel.attributedText = [self titleTextForIndex:index];
                [self.followScrollView addSubview:titleLabel];
            }

            if ([self descriptionTextForIndex:index]) {
                UILabel *descriptionLabel = [[UILabel alloc] init];
                descriptionLabel.frame = CGRectMake(xValue * SCROLL_MULTIPLIER + self.frame.size.width * 0.1, self.frame.size.height * DESCRIPTION_ORIGIN_Y, self.frame.size.width * 0.8, 64.0);
                descriptionLabel.adjustsFontSizeToFitWidth = YES;
                descriptionLabel.numberOfLines = 0;
                descriptionLabel.textAlignment = NSTextAlignmentCenter;
                descriptionLabel.textColor = [UIColor whiteColor];
                descriptionLabel.attributedText = [self descriptionTextForIndex:index];
                [self.followScrollView addSubview:descriptionLabel];
            }

            xValue += self.frame.size.width;
        }
        
        self.pageControl.numberOfPages = [self.dataSource numberOfViewsForCarousel:self];
        [self.leadScrollView setContentSize:CGSizeMake(xValue, self.frame.size.height)];
        [self.followScrollView setContentSize:CGSizeMake(xValue * SCROLL_MULTIPLIER, self.frame.size.height)];
    }
}

#pragma mark - Scroll View Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGPoint contentOffset = scrollView.contentOffset;
    contentOffset.x = contentOffset.x;
    self.leadScrollView.layer.mask.position = contentOffset;
    [CATransaction commit];
    
    [self.followScrollView setContentOffset:CGPointMake(self.leadScrollView.contentOffset.x * SCROLL_MULTIPLIER, self.followScrollView.contentOffset.y) animated:NO];
    
    NSUInteger viewIndex = (self.leadScrollView.contentOffset.x + self.leadScrollView.frame.size.width / 2) / self.frame.size.width;
    self.pageControl.currentPage = viewIndex;
}

@end

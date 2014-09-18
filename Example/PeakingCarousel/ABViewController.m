//
//  ABViewController.m
//  PeakingCarousel
//
//  Created by aldrincb on 09/18/2014.
//  Copyright (c) 2014 aldrincb. All rights reserved.
//

#import "ABViewController.h"
#import <ABPeakingCarouselView.h>

@interface ABViewController () <ABPeakingCarouselViewDataSource>

@end

@implementation ABViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ABPeakingCarouselView *carousel = [[ABPeakingCarouselView alloc] initWithFrame:self.view.bounds];
    carousel.dataSource = self;
    [self.view addSubview:carousel];
}

#pragma mark - Peaking Carousel View Data Source
- (NSUInteger)numberOfViewsForCarousel:(ABPeakingCarouselView *)carousel
{
    return 3;
}

- (UIView *)carousel:(ABPeakingCarouselView *)carousel viewAtIndex:(NSUInteger)index
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"c%d",index]]];
}

- (NSAttributedString *)carousel:(ABPeakingCarouselView *)carousel titleAtIndex:(NSUInteger)index
{
    UIFont *font = [UIFont fontWithName:@"GillSans-Light" size:32.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:@"Lorem Ipsum Dolor" attributes:attrsDictionary];
}

- (NSAttributedString *)carousel:(ABPeakingCarouselView *)carousel descriptionAtIndex:(NSUInteger)index
{
    UIFont *font = [UIFont fontWithName:@"GillSans-Light" size:17.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    return [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor." attributes:attrsDictionary];
}


@end

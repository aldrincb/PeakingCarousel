//
//  ABPeakingCarouselView.h
//  Peaking Carousel
//
//  Created by Aldrin Balisi on 6/27/14.
//  Copyright (c) 2014 Aldrin Balisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABPeakingCarouselView;

@protocol ABPeakingCarouselViewDataSource <NSObject>
@required
- (NSUInteger)numberOfViewsForCarousel:(ABPeakingCarouselView *)carousel;
- (UIView *)carousel:(ABPeakingCarouselView *)carousel viewAtIndex:(NSUInteger)index;
@optional
- (NSAttributedString *)carousel:(ABPeakingCarouselView *)carousel titleAtIndex:(NSUInteger)index;
- (NSAttributedString *)carousel:(ABPeakingCarouselView *)carousel descriptionAtIndex:(NSUInteger)index;
@end

@interface ABPeakingCarouselView : UIView
@property (nonatomic, weak) id <ABPeakingCarouselViewDataSource> dataSource;
- (void)reload;
@end

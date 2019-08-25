//
//  KDCycleSplitBannerView.h
//  KDCycleSplitBannerViewDemo
//
//  Created by Kingiol on 14-4-11.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KDCycleSplitBannerView;

typedef void(^CompleteBlock)(void);

@protocol KDCycleSplitBannerViewDataource <NSObject>

@required
- (NSArray *)numberOfKDCycleSplitBannerView:(KDCycleSplitBannerView *)bannerView;
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index;

@optional

- (UIImage *)placeHolderImageOfZeroBannerView;
- (UIImage *)placeHolderImageOfBannerView:(KDCycleSplitBannerView *)bannerView atIndex:(NSUInteger)index;

@end

@protocol KDCycleSplitBannerViewDelegate <NSObject>

@optional
- (void)cycleBannerView:(KDCycleSplitBannerView *)bannerView didScrollToIndex:(NSUInteger)index;
- (void)cycleBannerView:(KDCycleSplitBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index;

@end

@interface KDCycleSplitBannerView : UIView

// Delegate and Datasource
@property (weak, nonatomic) IBOutlet id<KDCycleSplitBannerViewDataource> datasource;
@property (weak, nonatomic) IBOutlet id<KDCycleSplitBannerViewDelegate> delegate;


@property (assign, nonatomic, getter = isContinuous) BOOL continuous;   // if YES, then bannerview will show like a carousel, default is NO
@property (assign, nonatomic) NSUInteger autoPlayTimeInterval;  // if autoPlayTimeInterval more than 0, the bannerView will autoplay with autoPlayTimeInterval value space, default is 0

- (void)reloadDataWithCompleteBlock:(CompleteBlock)competeBlock;
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;
-(void)hiddenPageControl;

@end

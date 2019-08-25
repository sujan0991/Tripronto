//
//  HWViewPager.h
//  AutoLayoutTest2
//
//  Created by HyunWoo Kim on 2015. 1. 8..
//  Copyright (c) 2015년 HyunWoo Kim. All rights reserved.
//



#import <UIKit/UIKit.h>


@protocol HWViewPagerDelegate <NSObject>
-(void)pagerDidSelectedPage:(NSInteger)selectedPage with:(NSInteger*) pagerTag;
@end

@interface HWViewPager : UICollectionView

@property BOOL isSingle;

-(void) setPagerDelegate:(id<HWViewPagerDelegate>)pagerDelegate;
@property (weak, nonatomic) IBOutlet id<HWViewPagerDelegate> userPagerDelegate;


@end


//
//  ExpertHolderView.m
//  Tripronto
//
//  Created by Tanvir Palash on 1/3/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "ExpertHolderView.h"

@implementation ExpertHolderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ExpertHolderView" owner:self options:nil];
        self.contentView.frame = self.frame;
        [self addSubview: self.contentView];
        
    //    [self.selectExpertButton setTitle:@"Select" forState:UIControlStateNormal];
    //    [self.selectExpertButton setTitle:@"Remove" forState:UIControlStateSelected];
    }

    
    return self;
}


//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        
//    }
//
//    return self;
//}


@end

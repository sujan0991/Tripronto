//
//  Drawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 2/2/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import "DrawerView.h"
#import "Constants.h"
#import "Trip.h"

@implementation DrawerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil];
        self.contentView.frame = self.frame;
        [self addSubview: self.contentView];
        [self setup];
    }
    return self;
}

-(void) setup
{
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowOffset = CGSizeMake(-5, 0);
    self.contentView.layer.shadowRadius = 5;
    self.contentView.layer.shadowOpacity = 0.7;
    self.contentView.layer.shadowColor=[UIColor hx_colorWithHexString:@"#5A5A5A"].CGColor;
    
    
    self.userPic.layer.masksToBounds = NO;
    self.userPic.layer.shadowOffset = CGSizeMake(0, 0);
    self.userPic.layer.shadowRadius = 5;
    self.userPic.layer.shadowOpacity = 0.7;
    self.userPic.layer.zPosition=100;
    self.cameraButton.layer.zPosition=101;

 
    self.userPic.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    self.userPic.layer.shadowColor=[UIColor hx_colorWithHexString:@"#5A5A5A"].CGColor;
    
    //Trip sharedManager].userImageName
    
    [self.userPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[Trip sharedManager].userImageName]]];
    
    NSLog(@"user image %@/%@",SERVER_BASE_API_URL,[Trip sharedManager].userImageName);
    
    [self.userName setText:[NSString stringWithFormat:@"%@ %@",[Trip sharedManager].userFirstName,[Trip sharedManager].userLastName]];
    
    self.drawerTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.drawerTableView.frame.size.width, 1)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

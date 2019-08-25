//
//  HeaderTableViewCell.m
//  Medication
//
//  Created by Masudur Rahman on 2/19/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

#import "SummaryTableViewCell.h"

@implementation SummaryTableViewCell
{
    NSArray* imageNameArray;
}



- (void)awakeFromNib {
    // Initialization code
    
    imageNameArray = @[@"flightIcon",@"timeIcon",@"accommodationIcon",@"activityIcon"];
    
    
    self.detailsTableView.layer.cornerRadius = 5.0f;
    self.detailsTableView.delegate=self;
    self.detailsTableView.dataSource=self;
    self.detailsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.detailsTableView.frame.size.width, 1)];
    
    [self.titleLabel setText:[self.destinationData objectForKey:@"destinationName"]];
    
    
    self.detailsTableView.estimatedRowHeight =  100;
    self.detailsTableView.rowHeight = UITableViewAutomaticDimension;
    
    
//        self.expertsTableView.layer.cornerRadius = 5.0f;
//        self.expertsTableView.delegate=self;
//        self.expertsTableView.dataSource=self;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *contentTableIdentifier;
    
        contentTableIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentTableIdentifier];
        }
        
        
        UIImageView *contentView=(UIImageView* ) [cell viewWithTag:101];
        contentView.image=[UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]];
    
    
        UILabel *detailsLabel = (UILabel *)[cell viewWithTag:102];
    
        if(indexPath.row==0)
        {
            [detailsLabel setText:[self.destinationData objectForKey:@"airlinePreference"]];
        }
        else if(indexPath.row==1)
        {
            [detailsLabel setText:[self.destinationData objectForKey:@"datePreferenceString"]];
        }
        else if(indexPath.row==2)
        {
            [detailsLabel setText:[self.destinationData objectForKey:@"accommodationPreference"]];
        }
        else if(indexPath.row==3)
        {
            [detailsLabel setText:[self.destinationData objectForKey:@"activityPreference"]];
        }
    
    
    
        cell.backgroundColor=[UIColor whiteColor];
         [cell layoutIfNeeded];
  
        //NSLog(@"self.detailsTableView %@",self.detailsTableView);
        //[self adjustHeightOfTableview];
    
        return cell;

    
//    }
    
   
  
   
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    //    if([[self.prevVc objectForKey:@"VC"]isEqualToString:@"List"])
    //    {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //   }
    

}

//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
//{
//
//
//        return tableView.frame.size.height*0.25;
//}



- (void)adjustHeightOfTableview
{
    //[self.detailsTableView layoutIfNeeded];
    NSLog(@"self.detailsTableView %@",self.detailsTableView);
    CGFloat height = self.detailsTableView.contentSize.height;
//    CGFloat maxHeight = self.detailsTableView.superview.frame.size.height - self.detailsTableView.frame.origin.y;
//    
//    // if the height of the content is greater than the maxHeight of
//    // total space on the screen, limit the height to the size of the
//    // superview.
//    
//    if (height > maxHeight)
//        height = maxHeight;
    
    // now set the height constraint accordingly
    NSLog(@"height %lf",height);
    [UIView animateWithDuration:0.25 animations:^{
        self.destinationViewHeightConstant.constant = height;
        [self setNeedsUpdateConstraints];
    }];
}

@end

//
//  HeaderTableViewCell.m
//  Medication
//
//  Created by Masudur Rahman on 2/19/15.
//  Copyright (c) 2015 BS-23. All rights reserved.
//

#import "ExpertTableViewCell.h"
#import "Constants.h"
#import "Expert.h"


@implementation ExpertTableViewCell


- (void)awakeFromNib {
    // Initialization code
    
        
    self.expertsTableView.layer.cornerRadius = 5.0f;
    self.expertsTableView.delegate=self;
    self.expertsTableView.dataSource=self;
    
    self.expertsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.expertsTableView.frame.size.width, 1)];
    
//    self.expertsTableView.estimatedRowHeight = 350;
//    self.expertsTableView.rowHeight = UITableViewAutomaticDimension;
    
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
    
    return self.expertData.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *contentTableIdentifier = @"Cell";
    
        //NSLog(@" expert table view ");
    
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentTableIdentifier];
        }
        
        
        UIImageView *contentView=(UIImageView* ) [cell viewWithTag:103];
        //contentView.image=[UIImage imageNamed:@"expertPicSq.png"];
        [contentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[self.expertData objectAtIndex:indexPath.row] objectForKey:@"image"]]]];
    
    
        contentView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
        [contentView.layer setBorderWidth: 1.0];
        contentView.layer.cornerRadius=2;
    
        UILabel *expertName = (UILabel *)[cell viewWithTag:104];
        [expertName setText:[[self.expertData objectAtIndex:indexPath.row] objectForKey:@"expertName"]];
        
        UILabel *detailsLabel = (UILabel *)[cell viewWithTag:105];
        [detailsLabel setText:[[self.expertData objectAtIndex:indexPath.row] objectForKey:@"oneLiner"]];
        
        cell.backgroundColor=[UIColor whiteColor];
        
    return cell;
   
    
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

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{

        return 80;

}


@end

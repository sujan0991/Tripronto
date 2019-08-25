//
//  SettingsViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 5/15/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (strong,nonatomic) NSArray * itemArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.itemArray = @[@"Notifications",@"Currency",@"Payment Methods"];
    
    self.settingTable.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    self.settingTable.dataSource=self;
    self.settingTable.delegate=self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return  self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:16];
    cell.textLabel.textColor = [UIColor hx_colorWithHexString:@"#5A5A5A"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[ self.itemArray objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  [self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath row]];
    // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

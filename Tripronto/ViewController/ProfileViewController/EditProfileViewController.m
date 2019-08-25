//
//  EditProfileViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 5/15/16.
//  Copyright © 2016 Tanvir Palash. All rights reserved.
//

#import "EditProfileViewController.h"
#import "EditProfileTableViewCell.h"
#import "AboutMeViewController.h"

@interface EditProfileViewController (){


    NSString* aboutMe;

    NSMutableDictionary* userInfo;

}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editProfileTableView.delegate = self;
    self.editProfileTableView.dataSource = self;
    
    self.editProfileTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.editProfileTableView.frame.size.width, 1)];
    
   
    userInfo = [[NSMutableDictionary alloc] init];
    
    self.selectedButton =1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated
{
  
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(aboutMe:) name:@"AboutMe" object:nil];
    
    [self.editProfileTableView reloadData];

}

- (void)aboutMe:(NSNotification*)notification
{
    
    aboutMe = notification.object;
    
    
}

- (void)dealloc
{
 
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - UITableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 2;
        
    }else if(section == 1){
        
        return 2;
        
    }else
        
        return 4; 
    
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        
        return 45.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        UIView *headerView = [[UIView  alloc] init];
        headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 25)];
        //headerLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:12];
        headerLabel.numberOfLines = 1;
        headerLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
        headerLabel.adjustsFontSizeToFitWidth = YES;
        headerLabel.adjustsLetterSpacingToFitWidth = YES;
    
        headerLabel.textColor = [UIColor lightGrayColor];
        headerLabel.textAlignment = UITextAlignmentCenter;
    
    if (section == 0) {
        
        headerLabel.text = @"About";
        headerLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:18];
        
    }else if (section == 1){
        
        headerLabel.text = @"Name";
        headerLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:18];
        
    }else if (section == 2){
        
        headerLabel.text = @"Private Details";
        headerLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:18];
    }
    
        [headerView addSubview:headerLabel];
    
        return headerView;
        
    
    
    //return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier] ;
        
        cell.textLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:13];
        
        if (indexPath.row == 0) {
      
            if (aboutMe.length != 0) {
                
                cell.textLabel.text = aboutMe;
                
                NSLog(@"about me %@",aboutMe);
                
                
            }else{
                
                cell.textLabel.text = @"Edit about me";
            }
            
            cell.textLabel.textColor = [UIColor redColor];
        }
        else if (indexPath.row == 1)
        {
        
        
            cell.textLabel.text = @"Web url";
            cell.textLabel.textColor = [UIColor blueColor];
        
        }
        return cell;
        
    }
    else if(indexPath.section == 1){
       
        EditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editProfileTextFieldCell"];
        
        cell.editInfoTextField.tag=indexPath.section*10+indexPath.row;
        
        cell.editInfoTextField.delegate=self;
        
        [cell.editInfoTextField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
        
        if (indexPath.row == 0) {
            
           cell.infoLabel.text = @"First Name";
           cell.editInfoTextField.text = @"Tanvir";
           cell.editInfoTextField.keyboardType=UIKeyboardTypeDefault;
            
        }else if (indexPath.row == 1){
            
           cell.infoLabel.text = @"Last Name";
           cell.editInfoTextField.text = @"Ahmed";
           cell.editInfoTextField.keyboardType=UIKeyboardTypeDefault;

        }
        
        return cell;
        
    }else if (indexPath.section == 2){
    
        if (indexPath.row == 0) {
            
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"editProfileButtonCell"];
            
            
                      
            if(self.selectedButton==1)
            {
                UIButton *random = (UIButton *)[cell viewWithTag:101];
                random.selected=YES;
                
                
                
            }else if(self.selectedButton==2)
            {
                UIButton *random = (UIButton *)[cell viewWithTag:102];
                random.selected=YES;
                
                
            }
            else if(self.selectedButton==3)
            {
                UIButton *random = (UIButton *)[cell viewWithTag:103];
                random.selected=YES;
                
            }
            
            
            return cell;
            
        }else{
            
           EditProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editProfileTextFieldCell"];
            
            cell.editInfoTextField.tag=indexPath.section*10+indexPath.row;
            
            cell.editInfoTextField.delegate=self;
            
            [cell.editInfoTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
            
            if (indexPath.row == 1)
            {
                
                cell.infoLabel.text = @"Birth Date";
                
                UIDatePicker *datePicker = [[UIDatePicker alloc]init];
                datePicker.datePickerMode = UIDatePickerModeDate;
                //[datePicker setDate:[NSDate date]];
                [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
                [cell.editInfoTextField setInputView:datePicker];

                
            }else if (indexPath.row == 2)
            {
                cell.infoLabel.text = @"Email";
                cell.editInfoTextField.text = @"sg@gmail.com";
                cell.editInfoTextField.keyboardType=UIKeyboardTypeURL;

            
            }else if (indexPath.row == 3)
            {
                cell.infoLabel.text = @"Phone";
                cell.editInfoTextField.text = @"0000000";
                cell.editInfoTextField.keyboardType=UIKeyboardTypePhonePad;

                
            }
    
           return cell;
            
        }
    }
    
    return nil;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        NSLog(@"..................");

        AboutMeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutMeViewController"];
        
        
        [self.navigationController pushViewController:controller animated:YES];
        
       
        
    }
    
    
}


-(void)updateTextField:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    
    EditProfileTableViewCell* cell = (EditProfileTableViewCell* )[self.editProfileTableView cellForRowAtIndexPath:indexPath];
    
   
    
    UIDatePicker *picker = (UIDatePicker*)cell.editInfoTextField.inputView;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yy"];
    NSString *dateString = [df stringFromDate:today];
    dateString = [NSString stringWithFormat:@"%@",[df stringFromDate:picker.date]];
    
    NSLog(@"date picker %@ ",dateString);
    
    cell.editInfoTextField.text = [NSString stringWithFormat:@"%@",dateString];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.inputView endEditing:YES];
    [self.view endEditing:YES];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%@",textField);
}

- (void)textFieldDidChange:(UITextField*)textField
{
    NSLog(@"did change");
    NSString *keyName;
    
    switch (textField.tag) {
        case 10:
            keyName=@"first_name";
            break;
        case 11:
            keyName=@"last_name";
            break;
        case 21:
            keyName=@"birth_date";
            break;
        case 22:
            keyName=@"email";
            break;
        case 23:
            keyName=@"phone";
            break;
       
            
        default:
            keyName=@"Default";
            
            break;
    }
    
    [userInfo setObject:textField.text forKey:keyName];
    
    NSLog(@"text %@",textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    
    return YES;
}


- (IBAction)ganderButtonAction:(UIButton *)sender {
    
    if (sender.tag == 101)
    {
        self.selectedButton = 1;
        [userInfo setObject:[NSNumber numberWithInt: 1 ] forKey:@"sex"];
        
    }else if (sender.tag == 102)
    {
        self.selectedButton = 2;

      [userInfo setObject:[NSNumber numberWithInt: 2 ] forKey:@"sex"];
        
    }else if (sender.tag == 103)
    {
        self.selectedButton = 3;

       [userInfo setObject:[NSNumber numberWithInt: 3 ] forKey:@"sex"];
        
    }
    
    for (int i=101; i<=103; i++) {
    
        UIButton *random1 = (UIButton *)[self.view viewWithTag:i];
        random1.selected=NO;
    }
    sender.selected=!sender.selected;
    
}

- (IBAction)saveButtonAction:(id)sender {
    
    NSLog(@"user info %@",userInfo);
    
    
}

- (IBAction)closeButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end

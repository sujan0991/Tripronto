//
//  TabBarViewController.m
//  Gloria_Jeans
//
//  Created by User on 8/24/14.
//  Copyright (c) 2014 mobioApp. All rights reserved.
//

#import "TabBarViewController.h"

#import "DrawerView.h"

#import "Trip.h"

#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.2
#define MENU_TRIGGER_VELOCITY 350


#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width


@interface TabBarViewController (){

    UIImage *chosenImage;

}

@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;
@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DrawerView *drawerView;
@property (strong, nonatomic) NSArray *drawerItems;

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
//    [tabBar setSelectedIndex:2];
    
   // NSLog(@" [Trip sharedManager].user_id %i", [Trip sharedManager].user_id);
    
    self.drawerItems = @[@"Edit Profile",@"App Settings",@"Invite Friend",@"About Tripronto",@"FAQ",@"Help/Support"];
                
    
    [self setUpDrawer];
    
    self.delegate=self;
    self.selectedIndex = 2;
//
    
}

- (BOOL)tabBarController:(UITabBarController *)theTabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    //Slide animation code
    
//    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
//    
//    if (controllerIndex == theTabBarController.selectedIndex) {
//        return NO;
//    }
//    
//    // Get the views.
//    UIView *fromView = theTabBarController.selectedViewController.view;
//    UIView *toView = [theTabBarController.viewControllers[controllerIndex] view];
//    
//    // Get the size of the view area.
//    CGRect viewSize = fromView.frame;
//    BOOL scrollRight = controllerIndex > theTabBarController.selectedIndex;
//    
//    // Add the to view to the tab bar view.
//    [fromView.superview addSubview:toView];
//    
//    // Position it off screen.
//    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//    toView.frame = CGRectMake((scrollRight ? screenWidth : -screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
//    
//    [UIView animateWithDuration:0.2
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         
//                         // Animate the views on and off the screen. This will appear to slide.
//                         fromView.frame = CGRectMake((scrollRight ? -screenWidth : screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
//                         toView.frame = CGRectMake(0, viewSize.origin.y, screenWidth, viewSize.size.height);
//                     }
//     
//                     completion:^(BOOL finished) {
//                         if (finished) {
//                             
//                             // Remove the old view from the tabbar view.
//                             [fromView removeFromSuperview];
//                             theTabBarController.selectedIndex = controllerIndex;
//                         }
//                     }];
//    
//    return NO;
    
    //Slide animation end
    
    if (viewController == [theTabBarController.viewControllers objectAtIndex:4])
    {
        NSLog(@"Profile ............");
        
//        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
//
        [self drawerToggle];
        
        return NO;
     
        
    }else
    {
        return (theTabBarController.selectedViewController != viewController);

    }


}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController: (UIViewController*)viewController {
    

    
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.5];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:
                                  kCAMediaTimingFunctionDefault]];
    [viewController.view.layer addAnimation:animation forKey:nil];
}

#pragma mark - drawer

- (void)setUpDrawer
{
    self.isOpen = NO;
    
    // load drawer view
   // self.drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil] objectAtIndex:0];
   
    self.drawerView=[[DrawerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH*.65,  self.view.frame.size.height)];
    
    
    self.meunHeight = self.drawerView.frame.size.height;
    self.menuWidth = self.drawerView.frame.size.width;
    //    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    //    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
    self.outFrame = CGRectMake(SCREENWIDTH,0, self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (SCREENWIDTH-self.menuWidth,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    [self.drawerView setFrame:self.outFrame];
    [self.view addSubview:self.drawerView];
    
    // drawer list
    [self.drawerView.drawerTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)]; // statuesBarHeight+navBarHeight
    self.drawerView.drawerTableView.dataSource = self;
    self.drawerView.drawerTableView.delegate = self;
    

    //Swipe from left and right
//    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.view addGestureRecognizer:swipeLeft];
//    
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(moveDrawer:)];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:swipeRight];

    
    
    
    //[self.view bringSubviewToFront:self.view];
    
    //    for (id x in self.view.subviews){
    //        NSLog(@"%@",NSStringFromClass([x class]));
    //    }
    
    [self.drawerView.logoutButton
     addTarget:self
     action:@selector(logOutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.drawerView.cameraButton
     addTarget:self
     action:@selector(cameraButtonClicked) forControlEvents:UIControlEventTouchUpInside];

}

- (void)drawerToggle
{
    if (!self.isOpen) {
        [self openNavigationDrawer];
    }else{
        [self closeNavigationDrawer];
    }
}

#pragma open and close action

- (void)openNavigationDrawer{
    //    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.inFrame;
                     }
                     completion:nil];
    
    self.isOpen= YES;
    
    // gesture on self.view
//    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
//    self.pan_gr.maximumNumberOfTouches = 1;
//    self.pan_gr.minimumNumberOfTouches = 1;
//    //self.pan_gr.delegate = self;
//    [self.view addGestureRecognizer:self.pan_gr];
    
    
}

- (void)closeNavigationDrawer{
    //    NSLog(@"close x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    [self closeNavigationDrawer];
}

-(void)moveDrawer:(UISwipeGestureRecognizer *)recognizer
{
   // CGPoint translation = [recognizer translationInView:self.view];
   // CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
    //    NSLog(@"velocity x=%f",velocity.x);
    
//    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
//        //        NSLog(@"start");
//        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
//            [self openNavigationDrawer];
//        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
//            [self closeNavigationDrawer];
//        }
//    }
//    
//    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
//        //        NSLog(@"changing");
//        float movingx = self.drawerView.center.x + translation.x;
//        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
//            
//            //self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
//            //[recognizer setTranslation:CGPointMake(0,0) inView:self.view];
//            
//            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
//            self.shawdowView.hidden = NO;
//            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
//        }
//    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self closeNavigationDrawer];
    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)

    {
        
        [self openNavigationDrawer];
        
    }
    
//    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
//        if (self.drawerView.center.x>=SCREENWIDTH){
//            [self openNavigationDrawer];
//        }else if (self.drawerView.center.x<SCREENWIDTH){
//            [self closeNavigationDrawer];
//        }
//    }
    
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
    return self.drawerItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"AzoSans-Regular" size:15];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.drawerItems objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  [self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath row]];
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self closeNavigationDrawer];
    
     //self.selectedIndex = 4;
    
    if(indexPath.row==0)
    {
        
        EditProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
        
        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
        navCon.navigationBar.hidden=YES;
        
        [self.navigationController presentViewController:navCon animated:YES completion:nil];
    }
    else if (indexPath.row==1)
    {
        SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    
    
    

}

-(void)logOutButtonClicked
{
    [Trip sharedManager].user_id=0;
    [Trip sharedManager].userFirstName=@"The";
    [Trip sharedManager].userLastName=@"Guest";
    [Trip sharedManager].userImageName=@"/img/profile-holder.png";
    
    LoaderViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"LoaderViewController"];
    [self.navigationController pushViewController:viewController animated:NO];
     
}

-(void) cameraButtonClicked
{

    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Open camera", nil),NSLocalizedString(@"Select from Library", nil), nil];
    
    
    
    [sheet showInView:self.view];



}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    chosenImage = image;
    
    self.drawerView.userPic.image=chosenImage;
    
    
    [self updateProfilePic];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    chosenImage=nil;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [myAlertView show];
            
        }
        else
        {

            UIImagePickerControllerSourceType source = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
            cameraController.delegate = self;
            cameraController.sourceType = source;
            cameraController.allowsEditing = YES;
            [self presentViewController:cameraController animated:YES completion:^{
                //iOS 8 bug.  the status bar will sometimes not be hidden after the camera is displayed, which causes the preview after an image is captured to be black
                if (source == UIImagePickerControllerSourceTypeCamera) {
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
                }
            }];
            
        }
        
        
    }else if(buttonIndex ==1)
    {
        UIImagePickerControllerSourceType source = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.delegate = self;
        cameraController.sourceType = source;
        cameraController.allowsEditing = YES;
        [self presentViewController:cameraController animated:YES completion:^{
            //iOS 8 bug.  the status bar will sometimes not be hidden after the camera is displayed, which causes the preview after an image is captured to be black
            if (source == UIImagePickerControllerSourceTypeCamera) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
            }
        }];
        
    }
}

-(void)updateProfilePic
{
    AFHTTPRequestOperationManager *infoManager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary * userInfoDictionary=[[NSMutableDictionary alloc] init];
    [userInfoDictionary setObject:[NSNumber numberWithInt:[Trip sharedManager].user_id] forKey:@"user_id"];
    [userInfoDictionary setObject:ACCESS_KEY forKey:@"access_key"];
    
    
    [infoManager POST:[NSString stringWithFormat:@"%@/users/api-change-profile-picture",SERVER_BASE_API_URL] parameters:userInfoDictionary
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    [formData appendPartWithFileData:imageData
                                name:@"photo_reference"
                            fileName:@"complain.jpg" mimeType:@"image/jpeg"];
    
    
    
    
} success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    
    NSLog(@"Response: %@", responseObject);
    
    
    
    
    if([[responseObject objectForKey:@"success"] integerValue]==1)
    {

        [Trip sharedManager].userImageName= [responseObject objectForKey:@"image_link"];

        NSLog(@"user image in tabbar %@/%@",SERVER_BASE_API_URL,[Trip sharedManager].userImageName);

        
    }
    else
    {

 
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                        message:@"Couldnt change the profile pic, please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        
    }
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
    
    
    
    
 //   self.drawerView.userPic.image=nil;
    
//    if ([[userInfo objectForKey:@"profile_picture"] isEqual:[NSNull null]]) {
//        
//        [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,@"img/place-holder.png"]]];
//    }else{
//        
//        [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[userInfo objectForKey:@"profile_picture"]]]];
//    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed!"
                                                    message:@"Something went wrong, Please check your network connection"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    
}];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

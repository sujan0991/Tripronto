//
//  TutorialViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 11/22/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "TutorialViewController.h"
#import "Constants.h"
#import "Trip.h"

@interface TutorialViewController ()
{
    SignInView* signInView;
    SignUpView* signUpView;
    CGFloat actualYPointOfPopView;
}

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view layoutIfNeeded];
    
    NSMutableArray *loaderImageViews=[[NSMutableArray alloc] init];
    NSArray* loaderImageArray=[NSArray arrayWithObjects:@"tripronto_84.png",@"tripronto_84.png",@"tripronto_84.png",@"tripronto_84.png", nil];
    
    for (int i=0; i<loaderImageArray.count; i++) {
        UIImageView* tempImageView=[[UIImageView alloc] init];
        tempImageView.image=[UIImage imageNamed:[loaderImageArray objectAtIndex:i]];
        tempImageView.contentMode=UIViewContentModeScaleAspectFit;
        [loaderImageViews addObject:tempImageView];
    }
    
    self.flipLoader.layer.zPosition=100;
    [self.flipLoader setUp:loaderImageViews];
    self.flipLoader.stillTime=0.1;
    self.flipLoader.durationForOneTurnOver=0.6;
    [self.flipLoader startAnimation];
    //self.flipLoader.hidden=YES;
    
    
    self.navigationController.navigationBar.hidden=YES;
    
    signInView=[[SignInView alloc] initWithFrame:CGRectMake(0, 0, self.popUpView.frame.size.width,  self.popUpView.frame.size.height)];
    signUpView=[[SignUpView alloc] initWithFrame:CGRectMake(0, 0, self.popUpView.frame.size.width,  self.popUpView.frame.size.height)];
    
    [signUpView.signUpButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [signInView.customLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate=self;
    
    //self.imageNameArray= [[NSMutableArray alloc] init];
    //self.imageNameArray =[[NSUserDefaults standardUserDefaults] objectForKey:@"splashName"];

    
    NSLog(@"image array %@",self.imageNameArray);
    
   // [self downloadImages];
   
   
    [self loadDescriptions];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.shadeView addSubview:blurEffectView];
    
//    [self registerForKeyboardNotifications];

//    CALayer *layer = [self.shadeView layer];
//    [layer setShouldRasterize:YES];
//    [layer setRasterizationScale:0.5];
//    
//    UIGraphicsBeginImageContext(self.shadeView.bounds.size);
//    [self.shadeView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImg = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    //Blur the image
//    CIImage *blurImg = [CIImage imageWithCGImage:viewImg.CGImage];
//    
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
//    [clampFilter setValue:blurImg forKey:@"inputImage"];
//    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
//    
//    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
//    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
//    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
//    
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef cgImg = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[blurImg extent]];
//    UIImage *outputImg = [UIImage imageWithCGImage:cgImg];
//    
//    //Add UIImageView to current view.
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.shadeView.bounds];
//    imgView.image = outputImg;
//    [self.shadeView addSubview:imgView];
    
}
/*
-(void) downloadImages
{
    //    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    //    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    //
    //    NSMutableDictionary * apiUserInfo=[[NSMutableDictionary alloc] init];
    //    [apiUserInfo setObject:@"api@flowdigitalmedia.com" forKey:@"data[User][username]"];
    //    [apiUserInfo setObject:@"flowdigital" forKey:@"data[User][password]"];
    //
    //    [apiLoginManager POST:@"http://192.168.0.114:8888/users/apiLogin" parameters:apiUserInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //
    //        NSLog(@"APi login Result %@",responseObject);
    //        if([responseObject objectForKey:@"success"])
    //        {
    //
    //
    //        }
    //
    //
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"error %@",error);
    //    }];
    
    
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:@"nhevan" forKey:@"access_key"];
    
    [apiLoginManager POST:@"http://192.168.0.110:8888/tripronto/splashes/api-get-splashes" parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Splash Result %@",responseObject);
        
        if([responseObject objectForKey:@"splashes"])
        {
            NSMutableArray *imageArray=[NSMutableArray alloc];
            imageArray=[responseObject objectForKey:@"splashes"];
            
           // [[NSUserDefaults standardUserDefaults] setObject:imageArray forKey:@"splashName"];
            
            //[imageView sd_setImageWithURL:[imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource];
            //[imageView setImageWithURL:[NSURL URLWithString:[food objectForKey:@"foodPicture"]]];
            
            
            SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
            
            for (int i =0 ; i<imageArray.count; i++) {
                
                NSLog(@"index  %@",[[[imageArray objectAtIndex:i] objectForKey:@"url"] lastPathComponent]);
                
                [downloader downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.110:8888/tripronto/%@",[[imageArray objectAtIndex:i] objectForKey:@"url"]]]
                 
                                         options:0
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                            // progression tracking code
                                        }
                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                           if (image && finished) {
                                               // do something with image
                                               [[SDImageCache sharedImageCache] storeImage:image forKey:[[[imageArray objectAtIndex:i] objectForKey:@"url"]lastPathComponent]];
                                               [self.imageNameArray addObject:[[[imageArray objectAtIndex:i] objectForKey:@"url"] lastPathComponent]];
                                               
                                           }
                                       }];
                
                
            }
           
            
            
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
        [self.imageNameArray addObject:@"http://ios9news.net/wp-content/uploads/2015/09/apple-music-stuck.png"];
        [self.imageNameArray addObject:@"http://answers.unity3d.com/storage/temp/45369-splashscreenshotnew.png"];
        
        [self loadScroll];
    }];
    
    

    
}
*/

//- (void)registerForKeyboardNotifications{
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWasShown:)
//     
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWillBeHidden:)
//     
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}
//- (void)keyboardWasShown:(NSNotification*)aNotification{
//    
//    NSDictionary* info = [aNotification userInfo];
//    
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    actualYPointOfPopView=self.popUpView.frame.origin.y;
//    CGRect aRect = CGRectMake(20,self.view.bounds.size.height- (kbSize.height+50), self.view.frame.size.width - 40, 50);
//    
//    
//    
//    if (!CGRectContainsPoint(aRect, signUpView.passwordView.frame.origin) ) {
//        
//        CGRect tempRect = CGRectMake(self.popUpView.frame.origin.x,self.popUpView.frame.origin.y-50, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
//
//        self.popUpView.frame=tempRect;
//        
//        
//    }
//    
//}
//
//
//
//// Called when the UIKeyboardWillHideNotification is sent
//
//- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
//    
//    CGRect aRect = CGRectMake(self.popUpView.frame.origin.x,actualYPointOfPopView, self.popUpView.frame.size.width, self.popUpView.frame.size.height);
//    self.popUpView.frame=aRect;
//    actualYPointOfPopView=0;
//}


- (void)loadScroll
{
    NSInteger pageCount = self.imageNameArray.count;
    _pageSelected = 0;
    // self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 520)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width*pageCount, [UIScreen mainScreen].bounds.size.height)];
    //[self.view addSubview:self.scrollView];
    
    NSLog(@"scrollview  %@",self.scrollView );
    
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-55, [UIScreen mainScreen].bounds.size.width, 25)];
//    
    
    self.customStoryboardPageControl.numberOfPages = pageCount;
    self.customStoryboardPageControl.currentPage = 0;
    
//    [self.view addSubview:_pageControl];
//    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    _pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    
   
    
}

- (void)loadDescriptions
{
    
    CGFloat left = 0;
    
    if (self.imageNameArray.count) {
        
        for (int i=0; i<self.imageNameArray.count; i++) {
            
            UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(left,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            //imageView.image=[UIImage imageNamed:@"welcome.png"];
            //imageView.image= [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[[self.imageNameArray objectAtIndex:i ] lastPathComponent]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageNameArray objectAtIndex:i]]];
            
            
            [self.scrollView addSubview:imageView];
            
            //        UIButton* LeftSkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //        LeftSkipButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width*.8+left,  [UIScreen mainScreen].bounds.size.height - 55, 35, 20);
            //        LeftSkipButton.backgroundColor=[UIColor clearColor];
            //        [LeftSkipButton setImage:[UIImage imageNamed:@"skipButton.png"] forState:UIControlStateNormal];
            //       // LeftSkipButton.imageView.image=[UIImage imageNamed:@"skipButton.png"];
            //        [LeftSkipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
            //        [self.scrollView addSubview:LeftSkipButton];
            //
            
            left += [UIScreen mainScreen].bounds.size.width;
        }
    }
    else
    {
        self.imageNameArray= [[NSMutableArray alloc] init];
        [self.imageNameArray addObject:@"travel1.png"];
        [self.imageNameArray addObject:@"travel2.png"];
     //   [self.imageNameArray addObject:@"bg_03.jpg"];
        
        for (int i=0; i<self.imageNameArray.count; i++) {
            UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(left,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
            
            imageView.image=[UIImage imageNamed:[self.imageNameArray objectAtIndex:i]];
            
            [self.scrollView addSubview:imageView];
            
            left += [UIScreen mainScreen].bounds.size.width;
        }
        
//        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//        if (networkStatus == NotReachable)
//        {
//            
//        }
//        else
//        {
//            self.imageNameArray= [[NSMutableArray alloc] init];
//            [self.imageNameArray addObject:@"http://ios9news.net/wp-content/uploads/2015/09/apple-music-stuck.png"];
//            [self.imageNameArray addObject:@"http://answers.unity3d.com/storage/temp/45369-splashscreenshotnew.png"];
//            [self.imageNameArray addObject:@"http://blog.karachicorner.com/wp-content/uploads/2013/03/Splash+Screens+7.jpg"];
//            
//            for (int i=0; i<self.imageNameArray.count; i++) {
//                UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(left,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//                
//                [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageNameArray objectAtIndex:i]]];
//                [self.scrollView addSubview:imageView];
//                
//                left += [UIScreen mainScreen].bounds.size.width;
//            }
//        
//        }
     
        
//        imageView.image=[UIImage imageNamed:@"welcome.png"];
//        [self.scrollView addSubview:imageView];
//        
    }
    
     [self loadScroll];
    
    [self.view bringSubviewToFront:self.signinButton];
    [self.view bringSubviewToFront:self.signupButton];
    [self.view bringSubviewToFront:self.customStoryboardPageControl];
    [self.view bringSubviewToFront:self.shadeView];
    [self.view bringSubviewToFront:self.popUpView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSInteger nearestNumber = lround(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width) ;
    
//    
//    if (self.customStoryboardPageControl.currentPage != nearestNumber) {
//        self.customStoryboardPageControl.currentPage = nearestNumber;
//        _pageSelected = self.customStoryboardPageControl.currentPage;
//        
//        
//        if (self.scrollView.dragging){
//            [self.customStoryboardPageControl updateCurrentPageDisplay];
//            
//        }
//        //[self loadDemo:_pageSelected+1];
//    }
    
    NSInteger pageIndex = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    
    self.customStoryboardPageControl.currentPage = pageIndex;
}
- (IBAction)skipToLogin:(id)sender {
    
    
//    NSLog(@"Skip to...");
//    SignInViewController *tabBarViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
//    [self presentViewController:tabBarViewController animated:NO completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)signUpAction:(id)sender {
    NSLog(@"signup");
    
    self.shadeView.hidden=NO;
    self.popUpView.hidden=NO;
    
   // SignUpView* signUpView=[[SignUpView alloc] initWithFrame:CGRectMake(0, 0, self.popUpView.frame.size.width,  self.popUpView.frame.size.height)];
    [self.popUpView addSubview:signUpView];
    
    
//    [signUpView.signUpButton
//     addTarget:self
//     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    
    signUpView.delegate=self;
    
}

- (IBAction)signInAction:(id)sender {
    
        NSLog(@"signin");
    self.shadeView.hidden=NO;
    self.popUpView.hidden=NO;
    
   [self.popUpView addSubview:signInView];
    
//    [signInView.customLoginButton
//     addTarget:self
//     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    signInView.delegate=self;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == [self.shadeView.subviews objectAtIndex:0])
    {
        self.popUpView.hidden=YES;
        self.shadeView.hidden=YES;
        
         [self.view endEditing:YES];
        
    }
    
}

-(void)signinview:(SignInView *)view closeTapped:(UIButton *)sender
{
    NSLog(@"now");
    self.popUpView.hidden=YES;
    self.shadeView.hidden=YES;
    
    [view removeFromSuperview];
}

-(void)signinview:(SignInView *)view signUpCalled:(UIButton *)sender
{
    [view removeFromSuperview];
    
    //SignUpView* signUpView=[[SignUpView alloc] initWithFrame:CGRectMake(0, 0, self.popUpView.frame.size.width,  self.popUpView.frame.size.height)];
    [self.popUpView addSubview:signUpView];
    signUpView.delegate=self;
}

-(void)login:(UIButton *)sender
{
    
//    TabBarViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//    [self.navigationController pushViewController:viewController animated:NO];
//
    if(signInView.emailField.text.length && signInView.passwordField.text.length)
    {
        AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
        apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
        [postData setObject:signInView.emailField.text forKey:@"username"];
        [postData setObject:signInView.passwordField.text forKey:@"password"];
        [postData setObject:ACCESS_KEY forKey:@"access_key"];
        
        [apiLoginManager POST:[NSString stringWithFormat:@"%@/users/api_login",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"login result %@",responseObject);
            
            if([[responseObject objectForKey:@"success"] integerValue])
            {
                signInView.emailField.text=@"";
                signInView.passwordField.text=@"";
                
                [Trip sharedManager].user_id=[[responseObject objectForKey:@"id"] intValue];
                [Trip sharedManager].userFirstName=[responseObject objectForKey:@"first_name"];
                [Trip sharedManager].userLastName=[responseObject objectForKey:@"last_name"];
                [Trip sharedManager].userImageName=[responseObject objectForKey:@"photo_reference"];
                
                
                NSLog(@"[Trip sharedManager].userLastName %@",[Trip sharedManager].userLastName);
                
                TabBarViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                [self.navigationController pushViewController:viewController animated:NO];
                
            }
            else
            {
                ZHPopupView *popupView = [ZHPopupView popUpDialogViewInView:nil
                                                                    iconImg:[UIImage imageNamed:@"home_sel"]
                                                            backgroundStyle:ZHPopupViewBackgroundType_Blur
                                                                      title:@"Error"
                                                                    content:@"Enter Valid Email id and Passward"
                                                               buttonTitles:@[@"Ok"]
                                                        confirmBtnTextColor:nil otherBtnTextColor:nil
                                                         buttonPressedBlock:^(NSInteger btnIdx) {
                                                             
                                                             
                                                         }];
                [popupView present];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error %@",error);
            
        }];

    }
    else
    {
        ZHPopupView *popupView = [ZHPopupView popupNomralAlertViewInView:nil
                                                         backgroundStyle:ZHPopupViewBackgroundType_SimpleOpacity
                                                                   title:@"Warning"
                                                                 content:@"Please Enter Both Email id and Passward"
                                                            buttonTitles:@[@"Okay"]
                                                     confirmBtnTextColor:nil otherBtnTextColor:nil
                                                      buttonPressedBlock:^(NSInteger btnIdx) {
                                                          
                                                          
                                                      }];
        [popupView present];
    }
    
}

-(void)SignUpView:(SignUpView *)view closeTapped:(UIButton *)sender
{
    NSLog(@"now");
    self.popUpView.hidden=YES;
    self.shadeView.hidden=YES;
    
    [view removeFromSuperview];
}

-(void)SignUpView:(SignUpView *)view signInCalled:(UIButton *)sender;
{
    [view removeFromSuperview];
    //SignInView* signInView=[[SignInView alloc] initWithFrame:CGRectMake(0, 0, self.popUpView.frame.size.width,  self.popUpView.frame.size.height)];
    [self.popUpView addSubview:signInView];
//    [signInView.customLoginButton
//     addTarget:self
//     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//
    signInView.delegate=self;

}
- (void)signUp:(UIButton *)sender;
{
    
//    TabBarViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//    [self.navigationController pushViewController:viewController animated:NO];
    
    if(signUpView.firstNameField.text.length && signUpView.lastNameField.text.length && signUpView.emailField.text.length && signUpView.passwordField.text.length)
    {
        AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
        apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
        [postData setObject:signUpView.firstNameField.text forKey:@"first_name"];
        [postData setObject:signUpView.lastNameField.text forKey:@"last_name"];
        [postData setObject:signUpView.emailField.text forKey:@"username"];
        [postData setObject:signUpView.passwordField.text forKey:@"password"];
        [postData setObject:ACCESS_KEY forKey:@"access_key"];
        
        [apiLoginManager POST:[NSString stringWithFormat:@"%@/users/api_traveller_sign_up",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"sign up Result %@",responseObject);
            
            if([[responseObject objectForKey:@"success"] integerValue])
            {
                //[Trip sharedManager].user_id=[[responseObject objectForKey:@"id"] intValue];
                
                
                ZHPopupView *popupView = [ZHPopupView popUpDialogViewInView:nil
                                                                    iconImg:[UIImage imageNamed:@"home_sel"]
                                                            backgroundStyle:ZHPopupViewBackgroundType_Blur
                                                                      title:@"Success"
                                                                    content:@"Welcome, You are Successfully Signed up"
                                                               buttonTitles:@[@"Continue"]
                                                        confirmBtnTextColor:nil otherBtnTextColor:nil
                                                         buttonPressedBlock:^(NSInteger btnIdx) {
                                                             
                                                             [Trip sharedManager].user_id=[[responseObject objectForKey:@"id"] intValue];
                                                            [Trip sharedManager].userFirstName=[responseObject objectForKey:@"first_name"];
                                                             [Trip sharedManager].userLastName=[responseObject objectForKey:@"last_name"];
                                                             [Trip sharedManager].userImageName=[responseObject objectForKey:@"photo_reference"];
                                                             // Need user id in response
                                                             
                                                             signUpView.firstNameField.text=@"";
                                                             signUpView.lastNameField.text=@"";
                                                             signUpView.emailField.text=@"";
                                                             signUpView.passwordField.text=@"";
                                                             
                                                             TabBarViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                                                             [self.navigationController pushViewController:viewController animated:NO];
                                                             
                                                         }];
                [popupView present];

                
                
            }
            
            else
            {
                ZHPopupView *popupView = [ZHPopupView popUpDialogViewInView:nil
                                                                    iconImg:[UIImage imageNamed:@"home_sel"]
                                                            backgroundStyle:ZHPopupViewBackgroundType_Blur
                                                                      title:@"Error"
                                                                    content:@"Something went wrong, please try again"
                                                               buttonTitles:@[@"Ok"]
                                                        confirmBtnTextColor:nil otherBtnTextColor:nil
                                                         buttonPressedBlock:^(NSInteger btnIdx) {
                                                             
                                                             
                                                         }];
                [popupView present];
                
                
            }

            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error %@",error);
            
        }];

    }
    else
    {
        
        ZHPopupView *popupView = [ZHPopupView popUpDialogViewInView:nil
                                                            iconImg:[UIImage imageNamed:@"home_sel"]
                                                    backgroundStyle:ZHPopupViewBackgroundType_Blur
                                                              title:@"Error"
                                                            content:@"Please Fill Up The Required Fields"
                                                       buttonTitles:@[@"Cancel",@"Continue"]
                                                confirmBtnTextColor:nil otherBtnTextColor:nil
                                                 buttonPressedBlock:^(NSInteger btnIdx) {
                                                     
                                                     
                                                 }];
        [popupView present];
    
    }
    
   
    
}

-(void)loginButtonClicked
{
    
    [KSToastView ks_showToast:@"Redirecting to Facebook" duration:2.0f];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
            // NSLog(@"Logged in");
             NSLog(@"fetched user:%@", result);
             
             NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
             NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
             
             [self fetchUserInfo];
            // NSLog(@"email %@",result[@"email"]);
         }
     }];
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"resultis:%@",result);
                 
                 [KSToastView ks_showToast:@"Logged in with Facebook" duration:2.0f];
                 [self socialApiCalled:result];

//                 
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}
- (void) loginButton:	(FBSDKLoginButton *)loginButton
didCompleteWithResult:	(FBSDKLoginManagerLoginResult *)result
               error:	(NSError *)error
{
    
    NSLog(@"Login");
    
    //self.profileView.hidden=NO;
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,first_name"}]
         
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 
                 
                 NSLog(@"fetched user:%@", result);
                 NSLog(@"email %@",result[@"email"]);
                 
                     
                 }else
                 {
                        NSLog(@"No data");
                 }
             }];
        
    }
    
    
}


- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton;
{
    
    NSLog(@"fb Logout");
    
}

-(void) socialApiCalled: (id) result
{
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:[result objectForKey:@"email"] forKey:@"username"];
    [postData setObject:[result objectForKey:@"first_name"] forKey:@"first_name"];
    [postData setObject:[result objectForKey:@"last_name"] forKey:@"last_name"];
    [postData setObject:@"facebook" forKey:@"oath_provider"];
    [postData setObject:[result objectForKey:@"id"] forKey:@"oath_uid"];
    [postData setObject:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]forKey:@"photo_reference"];
    [postData setObject:ACCESS_KEY forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/users/api_social_sign_up",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"login result %@",responseObject);
        
        
//        if([[responseObject objectForKey:@"success"] integerValue])
//        {
//            signInView.emailField.text=@"";
//            signInView.passwordField.text=@"";
//            
            [Trip sharedManager].user_id=[[responseObject objectForKey:@"user_id"] intValue];
            [Trip sharedManager].userFirstName=[responseObject objectForKey:@"first_name"];
            [Trip sharedManager].userLastName=[responseObject objectForKey:@"last_name"];
            [Trip sharedManager].userImageName=[responseObject objectForKey:@"photo_reference"];
            
            
            NSLog(@"[Trip sharedManager].userLastName %@",[Trip sharedManager].userLastName);
            
            TabBarViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
            [self.navigationController pushViewController:viewController animated:NO];
//
//        }
//        else
//        {
//            ZHPopupView *popupView = [ZHPopupView popUpDialogViewInView:nil
//                                                                iconImg:[UIImage imageNamed:@"home_sel"]
//                                                        backgroundStyle:ZHPopupViewBackgroundType_Blur
//                                                                  title:@"Error"
//                                                                content:@"Enter Valid Email id and Passward"
//                                                           buttonTitles:@[@"Ok"]
//                                                    confirmBtnTextColor:nil otherBtnTextColor:nil
//                                                     buttonPressedBlock:^(NSInteger btnIdx) {
//                                                         
//                                                         
//                                                     }];
//            [popupView present];
//            
//            
//        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@",error);
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

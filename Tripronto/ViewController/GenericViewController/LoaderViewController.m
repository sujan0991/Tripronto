//
//  LoaderViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 11/19/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "LoaderViewController.h"
#import "TutorialViewController.h"

#import "Trip.h"


@interface LoaderViewController ()

@end

@implementation LoaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
   // self.navigationController.hidesBarsOnSwipe=YES;
    self.navigationController.navigationBar.hidden=YES;
    
    self.imageUrls=[[NSMutableArray alloc] init];
    self.images = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 84; i++) {
        
        [self.images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"tripronto_%d.png",i]]];
        
    }
    
    //[self downloadImages];
    [self logoAnimation];
}

-(void) logoAnimation
{
    
    if(self.animationImageView)
        self.animationImageView.image=nil;
    
    self.animationImageView.animationImages = self.images;
    self.animationImageView.animationDuration = 1.5;
    self.animationImageView.animationRepeatCount=1;
    
    self.animationImageView.image = [self.animationImageView.animationImages lastObject];
    
    //[self.view addSubview:self.animationImageView];
    [self.animationImageView startAnimating];
    if ([self.animationImageView isAnimating]==NO) {
       // NSLog(@"stop");
    }
    
    [self performSelector:@selector(animationDidFinish) withObject:nil
               afterDelay:self.animationImageView.animationDuration+0.5];
    
}

-(void)animationDidFinish
{
    NSLog(@"stopped %i",[Trip sharedManager].user_id);
    
    if([Trip sharedManager].user_id>0)
    {
    
        TabBarViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else
    {
        TutorialViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
        viewController.imageNameArray=[[NSMutableArray alloc] init];
        viewController.imageNameArray=self.imageUrls;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

-(void) downloadImages
{
    
    AFHTTPRequestOperationManager *apiLoginManager = [AFHTTPRequestOperationManager manager];
    apiLoginManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary* postData=[[NSMutableDictionary alloc] init];
    [postData setObject:ACCESS_KEY forKey:@"access_key"];
    
    [apiLoginManager POST:[NSString stringWithFormat:@"%@/splashes/api-get-splashes",SERVER_BASE_API_URL] parameters:postData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"Splash Result %@",responseObject);
        
        if([responseObject objectForKey:@"splashes"])
        {
            NSMutableArray *imageArray=[NSMutableArray alloc];
            imageArray=[responseObject objectForKey:@"splashes"];
            
            
            for (int i=0; i<imageArray.count; i++) {
                [self.imageUrls addObject:[NSString stringWithFormat:@"%@/%@",SERVER_BASE_API_URL,[[imageArray objectAtIndex:i] objectForKey:@"url"]]];
            }
            
            // [[NSUserDefaults standardUserDefaults] setObject:imageArray forKey:@"splashName"];
            
            //[imageView sd_setImageWithURL:[imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource];
            //[imageView setImageWithURL:[NSURL URLWithString:[food objectForKey:@"foodPicture"]]];
            
            
//            SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//            
//            for (int i =0 ; i<imageArray.count; i++) {
//                
//                NSLog(@"index  %@",[[[imageArray objectAtIndex:i] objectForKey:@"url"] lastPathComponent]);
//                
//                [downloader downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.110:8888/tripronto/%@",[[imageArray objectAtIndex:i] objectForKey:@"url"]]]
//                 
//                                         options:0
//                                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                            // progression tracking code
//                                        }
//                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                                           if (image && finished) {
//                                               // do something with image
//                                               [[SDImageCache sharedImageCache] storeImage:image forKey:[[[imageArray objectAtIndex:i] objectForKey:@"url"]lastPathComponent]];
//                                               [self.imageNameArray addObject:[[[imageArray objectAtIndex:i] objectForKey:@"url"] lastPathComponent]];
//                                               
//                                           }
//                                       }];
//                
//                
//            }
            
            
            
        }
    
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

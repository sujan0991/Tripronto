//
//  PeopleSelectorViewController.m
//  Tripronto
//
//  Created by Tanvir Palash on 12/7/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "PeopleSelectorViewController.h"
#import "Trip.h"
#import "Summary.h"


@interface PeopleSelectorViewController ()
{
    NSArray *numbers;
    NSMutableArray *childAges;

}

@end

@implementation PeopleSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self.view layoutIfNeeded];
    
    
    [Trip sharedManager].adults=0;
    [Summary sharedManager].totalAdults=0;
    [Summary sharedManager].totalChilds=0;
    
    childAges=[[NSMutableArray alloc]init];
    numbers = @[@1,
                    @2,
                    @3,
                    @4,
                    @5,
                    @6,
                    @7,
                    @8,
                    @9,
                    @10,
                    @11,@12,@13,@14,@15,@16,@17];
    
    
    self.stepView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
  //  [self setCornerRadius];

    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.png"]];
    [imageView setFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 200)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    
    self.containerView.parallaxView.delegate = self;
    self.containerView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.step2View.subviews) {
        
        
        contentRect = CGRectUnion(contentRect, view.frame);
        //NSLog(@"contentRect %lf",contentRect.size.height);
    }
    
    contentRect.size.height+=20;
    
    self.containerView.contentSize=contentRect.size;
    
    
    [self.containerView addParallaxWithView:imageView andHeight:200 withTitle:@"Plan a new trip"];
    
    
    [[self.containerView.parallaxView backButton] addTarget:self
                                                     action:@selector(backButtonAction)
                                           forControlEvents:UIControlEventTouchUpInside];
    
    

   // NSLog(@"containerView %@",self.containerView);
    
    
    self.containerView.userInteractionEnabled = YES;
    self.containerView.exclusiveTouch = YES;
    self.containerView.canCancelContentTouches = YES;
    self.containerView.delaysContentTouches = NO;
    
    [self.containerView setContentOffset:CGPointMake(0, -200) animated:YES];
    
    self.adultStepper.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    self.childStepper.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    self.adultStepper.layer.borderWidth=1;
    self.childStepper.layer.borderWidth=1;
    
    
    [self.adultStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.childStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];

    
    self.nameView.layer.borderColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    self.nameView.layer.masksToBounds = NO;
    self.nameView.layer.shadowOffset = CGSizeMake(0, 0);
    self.nameView.layer.shadowRadius = 5;
    self.nameView.layer.shadowOpacity = 0.1;
    self.nameView.layer.zPosition=100;
    self.nameView.layer.shadowColor=[UIColor hx_colorWithHexString:@"#E03365"].CGColor;
    
    
    self.nameField.delegate=self;
    
    self.childAgeCollection.dataSource=self;
    self.childAgeCollection.delegate=self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    
    [self.containerView addGestureRecognizer:tapGesture];
}

-(void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)stepperValueChanged:(ANStepperView*) stepper
{
    NSLog(@"stepper %@",stepper.currentTitle);
    
    
    if(stepper.tag==101)
    {
      
        [Trip sharedManager].adults=[stepper.currentTitle intValue];
        [Summary sharedManager].totalAdults=[stepper.currentTitle intValue];
    
    }
    
    else if(stepper.tag==102)
    {
        [Summary sharedManager].totalChilds=[stepper.currentTitle intValue];
        
        if(childAges.count<[stepper.currentTitle intValue])
        {
            NSMutableDictionary *childAge=[[NSMutableDictionary alloc] init];
            [childAge setObject:[NSNumber numberWithInt:1] forKey:@"age"];
            
            [childAges addObject:childAge];
        }
        else
        {
            [childAges removeLastObject];
            
        }
        
        if([stepper.currentTitle intValue]%2==1)
        {
            NSLog(@"height increased");
            
            [UIView animateWithDuration:1.0 animations:^{
                
                self.containerView.contentSize = CGSizeMake(self.containerView.frame.size.width , self.containerView.frame.size.height+(childAges.count/2)*90);

                self.heightConstraint.constant= ((childAges.count/2)+1)*90;
    
            } completion:^(BOOL finished) {
                ;

            }];
            
        }
        
        [self.childAgeCollection reloadData];
        
    }
    
     NSLog(@"childAges %@",childAges);
}

-(void) setCornerRadius
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.stepNumberView.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                           cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.stepNumberView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.stepNumberView.layer.mask = maskLayer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    //    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}

#pragma mark collectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return childAges.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userBg.png"]];
    
    
    
    
    UILabel *userName = (UILabel *)[cell viewWithTag:302];
    [userName setText:[NSString stringWithFormat:@"Age of child %li",(long)indexPath.row+1]];
 //
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
//        recipeImageView.image = [UIImage imageNamed:[[self.users objectAtIndex:indexPath.row] objectForKey:@"ImgName"]];
    
    
    AKPickerView *pickerView=(AKPickerView*)[cell viewWithTag:301];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[self.view addSubview:self.pickerView];
    
    pickerView.pickerId=indexPath.row;
    pickerView.font = [UIFont fontWithName:@"AzoSans-Regular" size:15];
    pickerView.highlightedFont = [UIFont fontWithName:@"AzoSans-Regular" size:15];
    pickerView.interitemSpacing = 20.0;
    pickerView.fisheyeFactor = 0.001;
    pickerView.pickerViewStyle = AKPickerViewStyle3D;
    pickerView.selectedItem=[[[childAges objectAtIndex:indexPath.row] objectForKey:@"age"] integerValue]-1;
    pickerView.maskDisabled = false;
    
    [pickerView reloadData];
    
    
//    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
//    lpgr.minimumPressDuration = 1.0f;
//    lpgr.allowableMovement = 100.0f;
//    
//    [cell addGestureRecognizer:lpgr];
    
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.bounds.size.width-10)*0.5, 80 );
}


#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [numbers count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%@", numbers[item]];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
   // [childAges objectAtIndex:pickerView.tag-1]=item;
    
//
//    
    NSMutableDictionary *childAge=[[NSMutableDictionary alloc] init];
    [childAge setObject:numbers[item] forKey:@"age"];
    
    
    [childAges replaceObjectAtIndex:pickerView.pickerId withObject:childAge];
    
  //  NSLog(@"childAges %@",childAges );

}



/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */


- (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
{
    label.textColor = [UIColor lightGrayColor];
    label.highlightedTextColor = [UIColor colorWithRed:224.0/255.0 green:51.0/255.0 blue:102.0/255.0 alpha:1.0];
    //label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
    //									   saturation:1.0
    //									   brightness:1.0
    //											alpha:1.0];
}


/*
 - (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
 {
	return CGSizeMake(40, 20);
 }
 */

-(void)hideKeyboard
{
    [self.nameField resignFirstResponder];
    self.nameView.layer.shadowOpacity = 0.1;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.nameView.layer.shadowOpacity = 0.4;
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    self.nameView.layer.shadowOpacity = 0.1;
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    self.nameView.layer.shadowOpacity = 0.1;
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    self.nameView.layer.shadowOpacity = 0.1;
    
}


#pragma mark - UIScrollViewDelegate

/*
 * AKPickerViewDelegate inherits UIScrollViewDelegate.
 * You can use UIScrollViewDelegate methods
 * by simply setting pickerView's delegate.
 *
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Too noisy...
    // NSLog(@"%f", scrollView.contentOffset.x);
}


//-(void)backButtonAction:(id)sender
//{
//    NSLog(@"Back from people");
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}




#pragma mark - Navigation


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if ( [Trip sharedManager].adults) {
        
        return YES;
        
    }
    else{
        
        [KSToastView ks_showToast:@"Please select at least one adult" duration:2.0f];
        return NO;

    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [Trip sharedManager].childs=childAges;
    [Trip sharedManager].title=self.nameField.text;
    //[Summary sharedManager].tripName=self.nameField.text;

}


@end

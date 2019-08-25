//
//  PeopleStepper.m
//  Tripronto
//
//  Created by Tanvir Palash on 12/8/15.
//  Copyright © 2015 Tanvir Palash. All rights reserved.
//

#import "PeopleStepper.h"

@implementation PeopleStepper

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
       
    }
    
    labelSlideLength=5;
    labelSlideDuration=0.1;
    [self setup];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    labelSlideLength=5;
    labelSlideDuration=0.1;
    
    [self setup];
    return self;
}

-(void)setup
{
    
    self.backgroundColor=[UIColor blueColor];
    
    self.leftButton=[[UIButton alloc] init];
    self.leftButton.backgroundColor=[UIColor blueColor];
    [self.leftButton setTitle:@"-" forState:UIControlStateNormal];
    [self addSubview:self.leftButton];
    
    self.rightButton=[[UIButton alloc] init];
    self.rightButton.backgroundColor=[UIColor blueColor];
    [self.rightButton setTitle:@"+" forState:UIControlStateNormal];
    [self addSubview:self.rightButton];
    
    self.counterLabel=[[UILabel alloc]init];
    self.counterLabel.textAlignment=UITextAlignmentCenter;
    self.counterLabel.backgroundColor = [UIColor redColor];
    self.counterLabel.userInteractionEnabled=YES;
    [self addSubview:self.counterLabel];
    
    [self valueForCounterlabel];
    
    
    UIPanGestureRecognizer* panRecognizer=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.maximumNumberOfTouches=1;
    [self.counterLabel addGestureRecognizer:panRecognizer];
    
    
    [self.leftButton addTarget:self action:@selector(leftButtonTouchDown)
                                           forControlEvents:UIControlEventTouchDown];
    [self.leftButton addTarget:self action:@selector(buttonTouchUp)
              forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(buttonTouchUp)
              forControlEvents:UIControlEventTouchUpOutside];
    
    
    [self.rightButton addTarget:self action:@selector(rightButtonTouchDown)
              forControlEvents:UIControlEventTouchDown];
    [self.rightButton addTarget:self action:@selector(buttonTouchUp)
              forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(buttonTouchUp)
              forControlEvents:UIControlEventTouchUpOutside];
    
    
    //[self addObserver:self forKeyPath:@"counterValue" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
   
    
}

-(void)layoutSubviews
{
    labelOriginalCenter=self.counterLabel.center;
    
    CGFloat labelWidthWeight=0.5;
    CGFloat buttonWidth = self.bounds.size.width*((1-labelWidthWeight)/2);
    CGFloat labelWidth= self.bounds.size.width* labelWidthWeight;
    
    self.leftButton.frame = CGRectMake(0,0, buttonWidth, self.bounds.size.height);
    
    self.counterLabel.frame = CGRectMake(buttonWidth, 0, labelWidth,  self.bounds.size.height);
    
    self.rightButton.frame = CGRectMake(labelWidth + buttonWidth,0,buttonWidth,self.bounds.size.height);
}

-(void)valueForCounterlabel
{
    self.counterLabel.text=[NSString stringWithFormat:@"%i",counterValue];
}


-(void)leftButtonTouchDown
{
    if(counterValue>1)
        counterValue-=1;
    [self valueForCounterlabel];
   // [self slideLabelLeft];
}

-(void)rightButtonTouchDown
{
    counterValue+=1;
    [self valueForCounterlabel];
    //[self slideLabelRight];
}

-(void)buttonTouchUp
{
    [self slideLabelToOriginalPosition];
}

-(void)slideLabelLeft
{
    [self slideLabel:-labelSlideLength];
}

-(void)slideLabelRight
{
    [self slideLabel:labelSlideLength];
}


-(void) slideLabel: (CGFloat)slideLength
{
    
    [UIView animateWithDuration:labelSlideDuration animations:^{
        
        self.counterLabel.center = CGPointMake(self.counterLabel.center.x+slideLength , self.counterLabel.center.y);
        
    }];
    
}

-(void)slideLabelToOriginalPosition
{
    [UIView animateWithDuration:labelSlideDuration animations:^{
        
        self.counterLabel.center = labelOriginalCenter;
    }];
    
}

-(void) handlePan: (UIPanGestureRecognizer*) gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:self.counterLabel];
            CGFloat minimumLabelX = labelOriginalCenter.x - labelSlideLength;
            CGFloat maximumLabelX = labelOriginalCenter.x + labelSlideLength;
            
             self.counterLabel.center =  CGPointMake(  MAX(minimumLabelX, MIN(maximumLabelX, self.counterLabel.center.x + translation.x)) , self.counterLabel.center.y);
            
            if  (self.counterLabel.center.x == minimumLabelX)
            {
                counterValue -= 1;
                [self valueForCounterlabel];

            } else if  (self.counterLabel.center.x == maximumLabelX) {
                counterValue += 1;
                [self valueForCounterlabel];

            }
            
            [gesture setTranslation:CGPointZero inView:self.counterLabel];
             break;
        }
           
        case UIGestureRecognizerStateEnded:
        {
            [self slideLabelToOriginalPosition];
            break;

        }
            
        default:
            break;
    }

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // Do whatever you need to do here
    NSLog(@"observer call");
    
    if([keyPath isEqualToString:@"counterValue"])
    {
       // NSInteger oldC = [change objectForKey:NSKeyValueChangeOldKey];
        self.counterLabel.text=[NSString stringWithFormat:@"%i",counterValue];
    }
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"counterValue"];
}

@end

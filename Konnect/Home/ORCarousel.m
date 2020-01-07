//
//  HomeCarousel.m
//  Konnect
//
//  Created by Jacky Mok on 2/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORCarousel.h"
#import "AppDelegate.h"
#define DOT_SIZE 30
@interface ORCarousel ()

@end

@implementation ORCarousel
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFrame:(CGRect)f {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self.view setFrame:f];
       // NSLog (@"OR Carousel Init: %f",self.view.frame.size.width);
        delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
        //   NSLog (@"OR Carousel ViewDidLoad: %f",self.view.frame.size.height);
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        [self.view addSubview:scroll];
        [self.view setClipsToBounds:YES];
        [scroll setClipsToBounds:YES];
        scroll.showsHorizontalScrollIndicator = NO;
        [scroll setBounces:NO];
        [scroll setDelegate:self];
       // NSLog (@"OR Carousel Load d: %f",delegate.screenWidth);
       // NSLog (@"OR Carousel Load: %f",self.view.frame.size.width);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void) pack:(NSArray *)data {
    i = 0;
   // NSLog (@"OR Carousel Pack: %f",self.view.frame.size.width);
    indicators = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-(DOT_SIZE*[data count]/2),self.view.frame.size.height-DOT_SIZE,DOT_SIZE*[data count],DOT_SIZE)];
    [self.view addSubview:indicators];
    for (NSDictionary *d in data) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width,0,self.view.frame.size.width,self.view.frame.size.height)];
        [v setImage:[delegate getImage:[[d objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [v setImage:image];
            [v setContentMode:UIViewContentModeScaleAspectFill];
            [v setClipsToBounds:YES];
        }]];
        [scroll addSubview:v];
        
        [indicators addSubview:[self createDot:CGRectMake(DOT_SIZE*i,0,DOT_SIZE,DOT_SIZE) withTag:i]];
        
        i++;
    }
    [self setDot:0];
    [scroll setContentSize:CGSizeMake(i*self.view.frame.size.width,self.view.frame.size.height)];
}
-(UIView *) createDot:(CGRect)f withTag:(int)t{
    UIView *v = [[UIView alloc] initWithFrame:f];
    v.tag = t;
    UIView *d = [[UIView alloc] initWithFrame:CGRectMake(DOT_SIZE/2-3,DOT_SIZE/2-3,6,6)];
    [d setTag:99];
    d.layer.borderWidth = 1.0f;
    d.layer.borderColor = [UICOLOR_GOLD CGColor];
    [d.layer setCornerRadius:5.0f];
    [v addSubview:d];
    return v;
}
-(void) setDot:(int)index {
    for (UIView *v in indicators.subviews) {
        if (v.tag==index) {
            [[v viewWithTag:99] setBackgroundColor:UICOLOR_GOLD];
        } else {
            [[v viewWithTag:99] setBackgroundColor:[UIColor clearColor]];
        }
    }
}
-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    CGFloat kMaxIndex = i-1;
    CGFloat targetX = scrollView.contentOffset.x + velocity.x * 60.0;
    CGFloat targetIndex = 0.0;
    if (velocity.x > 0) {
        targetIndex = ceil(targetX / self.view.frame.size.width);
    } else if (velocity.x == 0) {
        targetIndex = round(targetX / self.view.frame.size.width);
    } else if (velocity.x < 0) {
        targetIndex = floor(targetX / self.view.frame.size.width);
    }
    if (targetIndex < 0)
        targetIndex = 0;
    if (targetIndex > kMaxIndex)
        targetIndex = kMaxIndex;
    [self setDot:targetIndex];
    targetContentOffset->x = targetIndex * (self.view.frame.size.width);
    //scrollView.decelerationRate = UIScrollViewDecelerationRateFast;//uncomment th
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

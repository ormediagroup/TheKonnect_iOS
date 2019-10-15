//
//  ImageZoomViewController.m
//  eAgent
//
//  Created by Jacky Mok on 7/1/2016.
//  Copyright © 2016 OR Media Limited. All rights reserved.
//

#import "ImageZoomViewController.h"
#import "AppDelegate.h"
@interface ImageZoomViewController ()

@end
@implementation ImageZoomViewController
@synthesize _img;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        base = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        [self.view addSubview:base];
        [base setDelegate:self];
        image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [base setMaximumZoomScale:5.0];
        [base addSubview:image];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
/*
-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
    CGPoint centerImageView = image.center;
    centerImageView.y = self.view.center.y-delegate.headerHeight;
    image.center = centerImageView;

}
 */
- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadImage:(UIImage *)img  {
//    [base setZoomScale:1.0];
    _img = img;
    [image setImage:img];
    //[base setContentSize:CGSizeMake(img.size.width,img.size.height)];
    [base scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    
    image.center = CGPointMake(delegate.screenWidth/2, delegate.screenHeight/2-72);
    /*
    CGFloat scaleX = 1.0f* self.view.frame.size.width / img.size.width;
    CGFloat scaleY = 1.0f* self.view.frame.size.height / img.size.height;
     */
/*    [base setMinimumZoomScale:MIN(scaleX, scaleY)];
    [base setZoomScale:MIN(scaleX, scaleY)];*/
}

@end

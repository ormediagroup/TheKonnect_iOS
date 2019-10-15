//
//  ImageZoomViewController.h
//  eAgent
//
//  Created by Jacky Mok on 7/1/2016.
//  Copyright © 2016 OR Media Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface ImageZoomViewController : UIViewController<UIScrollViewDelegate> {
    UIScrollView *base;
    UIImageView *image;
    AppDelegate *delegate;
    UIImage *_img;
}
-(void) loadImage:(UIImage *)img ;
@property UIImage *_img;

@end

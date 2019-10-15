//
//  ImageGallery.h
//  eAgent
//
//  Created by Jacky Mok on 7/1/2016.
//  Copyright © 2016 OR Media Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@class ImageGallery;
@class ImageZoomViewController;
#define PANEL_HEIGHT 80
@interface ImageGallery : UIViewController {
    UINavigationController *nav;
    AppDelegate *delegate;
    NSArray *images;
    NSMutableArray *vcs;
    int pageidx;
    ImageZoomViewController *viewPanel;
    UIScrollView *panel;
}
-(void) setImages:(NSArray *)_images;
@end

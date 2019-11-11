//
//  HomeCarousel.h
//  Konnect
//
//  Created by Jacky Mok on 2/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@interface ORCarousel : UIViewController <UIScrollViewDelegate>{
    UIScrollView *scroll;
    AppDelegate *delegate;
    UIView *indicators;
    int i;
}
-(void) pack:(NSArray *)data;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFrame:(CGRect)f;
@end


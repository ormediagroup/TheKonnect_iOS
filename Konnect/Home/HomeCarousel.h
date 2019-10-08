//
//  HomeCarousel.h
//  Konnect
//
//  Created by Jacky Mok on 2/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AppDelegate;
@interface HomeCarousel : UIViewController <UIScrollViewDelegate>{
    UIScrollView *scroll;
    AppDelegate *delegate;
    UIView *indicators;
}
-(void) pack:(NSArray *)data;
@end

NS_ASSUME_NONNULL_END

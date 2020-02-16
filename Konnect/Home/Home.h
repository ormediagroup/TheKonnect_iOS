//
//  Home.h
//  Konnect
//
//  Created by Jacky Mok on 25/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
@class AppDelegate;
@class ORCarousel;
NS_ASSUME_NONNULL_BEGIN

@interface Home : ORViewController {
   
    UIImageView *memberTier;
    ORCarousel *carousel;
    UIImageView *ad;
    UIView *bottom;
    UILabel *nameLbl;
    UIButton *submit;
    UIView *bg;
}
@end

NS_ASSUME_NONNULL_END

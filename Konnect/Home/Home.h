//
//  Home.h
//  Konnect
//
//  Created by Jacky Mok on 25/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
@class AppDelegate;
@class HomeCarousel;
NS_ASSUME_NONNULL_BEGIN

@interface Home : ORViewController {
   
    UIImageView *memberTier;
    HomeCarousel *carousel;
    UIImageView *ad;
    UIView *bottom;
    UILabel *nameLbl;
}
@end

NS_ASSUME_NONNULL_END

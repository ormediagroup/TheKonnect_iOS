//
//  ServiceOffice.h
//  Konnect
//
//  Created by Jacky Mok on 7/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"
@class ORCarousel;
NS_ASSUME_NONNULL_BEGIN

@interface ServiceOffice : ORTableViewController {
    UIView *carousel;
    ORCarousel *oc;
    NSDictionary *datasrc;
}

@end

NS_ASSUME_NONNULL_END

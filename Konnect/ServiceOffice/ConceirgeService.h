//
//  ConceirgeService.h
//  Konnect
//
//  Created by Jacky Mok on 25/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"
@class ORCarousel;
NS_ASSUME_NONNULL_BEGIN
@interface ConceirgeService : ORTableViewController<UITextViewDelegate>{
    UIView *carousel;
    NSArray *datasrc;
    ORCarousel *oc;
    NSString *desc;
    UITextField *bookingName, *bookingPhone;
    UITextView *remarks;

}

@end

NS_ASSUME_NONNULL_END

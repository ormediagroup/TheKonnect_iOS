//
//  EventDetails.h
//  Konnect
//
//  Created by Jacky Mok on 10/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Facility.h"
#define EVENT_TOOLBAR_HEIGHT 60
NS_ASSUME_NONNULL_BEGIN

@interface EventDetails : ORViewController {
    NSString * eventID;
    UIView *toolbar;
    NSDictionary *datasrc;
    UIButton *tou;
    
}
@property NSString *eventID;

@end

NS_ASSUME_NONNULL_END

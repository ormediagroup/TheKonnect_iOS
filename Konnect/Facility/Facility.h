//
//  Facility.h
//  Konnect
//
//  Created by Jacky Mok on 12/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
#define FB_TOOLBAR_HEIGHT 60
NS_ASSUME_NONNULL_BEGIN

@interface Facility : ORViewController {
    NSString * facilityid;
    UIView *toolbar;
    NSDictionary *datasrc;
}
@property NSString *facilityid;
@end

NS_ASSUME_NONNULL_END

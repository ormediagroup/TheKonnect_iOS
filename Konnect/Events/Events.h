//
//  Events.h
//  Konnect
//
//  Created by Jacky Mok on 10/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Events : ORTableViewController {
    NSArray *datasrc, *kevents, *vipevents, *otherevents, *pastevents;
    CGFloat rowHeight;
}

@end

NS_ASSUME_NONNULL_END

//
//  EventList.h
//  Konnect
//
//  Created by Jacky Mok on 7/1/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventList : ORTableViewController {
    NSArray *datasrc;
}
@property NSArray *datasrc;
@end

NS_ASSUME_NONNULL_END

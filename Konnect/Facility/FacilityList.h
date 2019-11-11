//
//  FacilityList.h
//  Konnect
//
//  Created by Jacky Mok on 7/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FacilityList : ORTableViewController {
    NSArray *datasrc;
    NSString *title;
}
@property NSString *title;
@end

NS_ASSUME_NONNULL_END

//
//  OfficeNotifications.h
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OfficeNotifications : ORTableViewController  {
    
    NSMutableArray *datasrc;
    BOOL loadingMore;
}

@end

NS_ASSUME_NONNULL_END

//
//  VirtualOffice.h
//  Konnect
//
//  Created by Jacky Mok on 25/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VirtualOffice : ORTableViewController{
    NSString *officeID;
    NSDictionary *datasrc;
    NSArray *fields, *map;

}
@property NSString *officeID;
@end

NS_ASSUME_NONNULL_END

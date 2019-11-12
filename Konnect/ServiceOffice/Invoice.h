//
//  Invoice.h
//  Konnect
//
//  Created by Jacky Mok on 8/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Invoice : ORTableViewController {
    NSDictionary *datasrc;
    NSString *invoiceID;
    NSArray *fields, *map;
}
@property NSString *invoiceID;
@end

NS_ASSUME_NONNULL_END
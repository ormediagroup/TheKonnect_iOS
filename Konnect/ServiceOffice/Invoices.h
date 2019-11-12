//
//  Invoices.h
//  Konnect
//
//  Created by Jacky Mok on 8/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Invoices : ORTableViewController {
    NSString * invoicetype;
    NSDictionary *datasrc;
    NSArray *invoices;
    NSString *invIDs;
}
@property NSString *invoicetype;
@end

NS_ASSUME_NONNULL_END

//
//  Wallet.h
//  Konnect
//
//  Created by Jacky Mok on 6/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORTableViewController.h"
@class PaymentQR;
NS_ASSUME_NONNULL_BEGIN
@interface Wallet : ORTableViewController {
    NSArray *dataSrc;
    PaymentQR *paymentQR;
    CGFloat balance;
    CGFloat points;
    
}

@end

NS_ASSUME_NONNULL_END

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
typedef enum {
    VIEW_TYPE_QRCODE = 1,
    VIEW_TYPE_HISTORY = 2
} VIEW_TYPE;
@interface Wallet : ORTableViewController {
    NSArray *dataSrc;
    VIEW_TYPE viewType;
    PaymentQR *paymentQR;
}

@end

NS_ASSUME_NONNULL_END

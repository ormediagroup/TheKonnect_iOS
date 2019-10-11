//
//  TopUp.h
//  Konnect
//
//  Created by Jacky Mok on 9/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopUp : ORViewController {
    NSArray *dataSrc;
    UIView *paymentBar;
    UIView *ali, *wechat;
    CGFloat chargeAmount;
    CGFloat topupPoints;
    NSString *chargeType;
    NSArray *chargeMap;
    NSMutableArray *btns;
}

@end

NS_ASSUME_NONNULL_END

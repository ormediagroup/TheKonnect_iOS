//
//  ChargeQR.h
//  Konnect
//
//  Created by Jacky Mok on 10/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum {
    STATE_INIT = 1,
    STATE_SCAN = 2
} CHARGE_STATE;
@interface ChargeQR : ORViewController <AVCaptureMetadataOutputObjectsDelegate> {
    NSString *displayCharge;
    NSString *charge;
    CHARGE_STATE state;
    UITextField *chargeTotal;
}

@end

NS_ASSUME_NONNULL_END

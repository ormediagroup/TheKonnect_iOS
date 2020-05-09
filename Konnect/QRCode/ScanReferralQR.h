//
//  ScanReferralQR.h
//  Konnect
//
//  Created by Jacky Mok on 21/4/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@class LoginOrReg;
NS_ASSUME_NONNULL_BEGIN

@interface ScanReferralQR : ORViewController <AVCaptureMetadataOutputObjectsDelegate> {
    LoginOrReg __weak *parent;
    UIImageView *staticImage;
}
@property (weak) LoginOrReg *parent;
-(void) setImage:(UIImage *)img;
@end

NS_ASSUME_NONNULL_END

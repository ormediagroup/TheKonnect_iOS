//
//  PaymentCode.h
//  Konnect
//
//  Created by Jacky Mok on 10/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    PC_STATE_INIT =1,
    PC_STATE_NORMAL = 2,
    PC_STATE_RESET = 3,
    PC_STATE_INIT_2 =4,
} PAYMENT_CODE_STATE;
@interface PaymentCode : ORViewController {
    PAYMENT_CODE_STATE state;
    NSString *code, *verifycode;
    UIView *codeHolder;
    NSString *transactionCode;
    NSString *amount;
    NSString *vendorid;
    NSString *remarks;
}
-(void) paymentRequest:(NSString *)code andAmount:(NSString*)amt;
-(void) paymentRequest:(NSString *)code andAmount:(NSString*)amt forVendor:(NSString *)vid  withRemarks:(NSString *)iid;
@property PAYMENT_CODE_STATE state;

@end

NS_ASSUME_NONNULL_END

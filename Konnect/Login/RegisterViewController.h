//
//  RegisterViewController.h
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
@class LoginOrReg;
NS_ASSUME_NONNULL_BEGIN
typedef enum {
    REG_TYPE_PHONE = 0,
    REG_TYPE_WECHAT =1
    
} REG_TYPE;
@interface RegisterViewController : ORViewController <UITextFieldDelegate> {
    UIButton *areaCode;
    UITextField *phone, *verification;
    UIButton *clearPhone, *clearVerification, *sendVerification, *submit;
    UIView *phoneLine, *verificationLine;
    UILabel *errorMessage;
    UIButton *tou;
    NSTimer *timer;
    REG_TYPE regType;    
    LoginOrReg __weak *parent;
    BOOL showWXMessage;
    BOOL phoneOK;
    int sec;
}
@property (weak) LoginOrReg *parent;
@property BOOL showWXMessage;
@property REG_TYPE regType;
@end

NS_ASSUME_NONNULL_END

//
//  ResetPassword.h
//  Konnect
//
//  Created by Jacky Mok on 12/2/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResetPassword : ORViewController <UITextFieldDelegate>{
    UIButton *areaCode;
    UITextField *phone, *verification, *email, *pw1, *pw2;
    UIButton *clearPhone, *clearVerification, *clearPW1, *clearPW2, *clearEmail, *sendVerification, *submit;
    UIView *phoneLine, *verificationLine, *emailLine, *pw1Line, *pw2Line;
    UILabel *errorMessage;
    NSString *userID;
    NSTimer *timer;
    BOOL phoneOK;
    int sec;
}

@end

NS_ASSUME_NONNULL_END

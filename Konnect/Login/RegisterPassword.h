//
//  RegisterPassword.h
//  Konnect
//
//  Created by Jacky Mok on 12/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
@class LoginOrReg;
NS_ASSUME_NONNULL_BEGIN

@interface RegisterPassword : ORViewController <UITextFieldDelegate> {
    LoginOrReg __weak *parent;
    UILabel *text1, *text2, *text3;
    UITextField *password, *password2;
    UILabel *errorMessage;
    UIView *passwordLine, *password2Line;
    UIButton *submit;
}
@property (weak) LoginOrReg *parent;
@end

NS_ASSUME_NONNULL_END

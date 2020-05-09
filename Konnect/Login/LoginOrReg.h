//
//  LoginViewController.h
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//
#import <AuthenticationServices/AuthenticationServices.h>
#import "ORViewController.h"

@class Introduction;
@class RegisterViewController;
@class RegisterPassword;
@class TieWeChat;
@class ResetPassword;
@class ScanReferralQR;

NS_ASSUME_NONNULL_BEGIN

@interface LoginOrReg : ORViewController <UITextFieldDelegate, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    Introduction __weak *parent;
    UIButton *login, *reg;
    UINavigationController *nav;
    RegisterPassword *regPass;
    UILabel *errMsg;
    UIButton *areaCode;
    UIViewController *loginView;
    UITextField *phone, *password;
    UIButton *clearPhone, *clearPassword;
    UIView *phoneLine, *passwordLine;
    UIView *topLine;
    UIImageView *profile;    
    RegisterViewController *regView;
    TieWeChat *tieWechat;
    UIButton *submit;
    UIImageView *regFlow;
    ResetPassword *resetpw;
    ScanReferralQR *scanQR;
    NSString *referrer;
    NSString *refid;
    UIImagePickerController *imgpicker;
}
@property (weak) Introduction *parent;
@property NSString *referrer, *refid;
-(void) RegStage2;
-(void) RegStage1;
-(void) changeRegFlowState:(int)state;
-(void) scanReferralQR;
-(void) chooseFromAlbum;
-(void) backPressed;
-(void) setReferrer:(NSString *) ref withID:(NSString *)refid;
-(void) killRefScan;
@end
NS_ASSUME_NONNULL_END

//
//  LoginViewController.h
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
@class Introduction;
@class RegisterViewController;
@class RegisterPassword;
@class TieWeChat;
NS_ASSUME_NONNULL_BEGIN
#define CLUB_1 @"香港菁英會"
#define CLUB_2 @"國酒茅台之友協會"
#define CLUB_3 @"江港青年交流促進會"
#define CLUB_4 @"靜安香港聯會"
#define CLUB_5 @"渝港青年交流促進會有限公司"
#define CLUB_6 @"香港工商總會 - 沙田分會"
#define CLUB_7 @"香港工商總會 - 大埔分會"
#define CLUB_8 @"深圳市海歸會"
#define CLUB_9 @"粵港澳大灣區青年協會"
#define CLUB_10 @"上海市徐匯海外聯誼會香港分會"
#define CLUB_11 @"閔行香港聯會"
#define CLUB_12 @"港雋青年交流協會"
#define CLUB_13 @"寧港青年交流協會"
#define CLUB_14 @"幫助青年創業創意協會"
#define CLUB_16 @"香港區塊鏈產業協會"
#define CLUB_17 @"香港特區中央獅子會"
#define CLUB_18 @"香港五邑總會"
#define CLUB_19 @"國際青年創業協會"
#define CLUB_20 @"緬甸交流協會"
#define CLUB_21 @"中國國家行政學院(香港)工商專業同學會"
@interface LoginOrReg : ORViewController <UITextFieldDelegate> {
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
}
@property (weak) Introduction *parent;
-(void) RegStage2;
-(void) RegStage1;
-(void) changeRegFlowState:(int)state;


@end
NS_ASSUME_NONNULL_END

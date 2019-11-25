//
//  RegisterViewController.h
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
@class LoginOrReg;
@class AssoPIcker;
NS_ASSUME_NONNULL_BEGIN
typedef enum {
    REG_TYPE_PHONE = 0,
    REG_TYPE_WECHAT =1    
} REG_TYPE;
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
#define CLUB_15 @"香港區塊鏈產業協會"
#define CLUB_16 @"香港特區中央獅子會"
#define CLUB_17 @"香港五邑總會"
#define CLUB_18 @"國際青年創業協會"
#define CLUB_19 @"緬甸交流協會"
#define CLUB_20 @"中國國家行政學院(香港)工商專業同學會"
@interface RegisterViewController : ORViewController <UITextFieldDelegate> {
    UIButton *areaCode;
    UITextField *phone, *verification, *email;
    UIButton *clearPhone, *clearVerification, *clearEmail, *sendVerification, *submit;
    UIView *phoneLine, *verificationLine, *emailLine;
    UILabel *errorMessage;
    UIButton *tou;
    UIButton *isAssoc;
    NSTimer *timer;
    AssoPIcker *assocPicker;
    UILabel *assoc;
    REG_TYPE regType;    
    LoginOrReg __weak *parent;
    BOOL showWXMessage;
    BOOL phoneOK;
    int sec;
}
@property (weak) LoginOrReg *parent;
@property BOOL showWXMessage;
@property REG_TYPE regType;
@property UILabel  *assoc;
@end

NS_ASSUME_NONNULL_END

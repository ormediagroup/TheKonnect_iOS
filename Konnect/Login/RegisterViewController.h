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
    REG_TYPE_WECHAT =1,
    REG_TYPE_APPLE = 2
} REG_TYPE;
#define CLUB_1 @"尖沙咀獅子會"
#define CLUB_2 @"荷里活獅子會"
#define CLUB_3 @"銀綫灣獅子會"
#define CLUB_4 @"新民獅子會"
#define CLUB_5 @"鑪峯獅子會"
#define CLUB_6 @"香島獅子會"
#define CLUB_7 @"新時代獅子會"
#define CLUB_8 @"星光獅子會"
#define CLUB_9 @"新界東獅子會"
#define CLUB_10 @"淺水灣獅子會"
#define CLUB_11 @"港雋動力青年協會"
#define CLUB_12 @"寧港青年交流協會"
#define CLUB_13 @"飛躍莞港灣區薈"
#define CLUB_14 @"香港服務同盟"
#define CLUB_15 @"粵港澳大灣區青年協會"
#define CLUB_16 @"國際青年創業協會"
#define CLUB_17 @"2GHK"
#define CLUB_18 @"香港滙青社"
#define CLUB_19 @"香港中國企業協會資訊科技行業委員會"
#define CLUB_20 @"互聯網專業協會"
#define CLUB_21 @"青年IT 網絡"
#define CLUB_22 @"英國電腦學會（香港分會）"
#define CLUB_23 @"香港I.T.人協會"
#define CLUB_24 @"香港下一代互聯網學會"
#define CLUB_25 @"香港青聯科技協會"
#define CLUB_26 @"香港科技園公司"
#define CLUB_27 @"香港產學研合作促進會"
#define CLUB_28 @"香港軟件行業協會"
#define CLUB_29 @"香港通訊業聯會"
#define CLUB_30 @"香港創科發展協會"
#define CLUB_31 @"香港資訊科技界國慶活動籌委會"
#define CLUB_32 @"香港電商協會"
#define CLUB_33 @"香港電腦商會"
#define CLUB_34 @"香港電腦教育學會"
#define CLUB_35 @"香港電腦學會"
#define CLUB_36 @"香港數碼港管理有限公司"
#define CLUB_37 @"香港醫療資訊學會"
#define CLUB_38 @"國際信息系統審計協會（中國香港分會）"
#define CLUB_39 @"深圳市科技開發交流中心"
#define CLUB_40 @"深圳市科學技術協會"
#define CLUB_41 @"深港科技合作促進會"
#define CLUB_42 @"深港科技社團聯盟"
#define CLUB_43 @"智慧城市聯盟"
#define CLUB_44 @"粵港澳大灣區科普聯盟"
#define CLUB_45 @"資訊及軟件業商會"
#define CLUB_46 @"電子健康聯盟"
#define CLUB_47 @"電機暨電子工程師學會（香港電腦分會）"

@interface RegisterViewController : ORViewController <UITextFieldDelegate> {
    UIButton *areaCode;
    UITextField *phone, *verification, *email;
    UIButton *clearPhone, *clearVerification, *clearEmail, *sendVerification, *submit;
    UIView *phoneLine, *verificationLine, *emailLine;
    UILabel *errorMessage;
    UIButton *tou;
    UIButton *isAssoc;
    NSTimer *timer;
    UIButton *scanRefQR;
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
@property UIButton *scanRefQR;
@end

NS_ASSUME_NONNULL_END

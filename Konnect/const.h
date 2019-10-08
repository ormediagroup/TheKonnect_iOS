//
//  const.h
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#ifndef const_h
#define const_h

#define FONT_XS 14
#define FONT_S 16
#define FONT_M 18
#define FONT_L 20
#define FONT_XL 22

#define SIDE_PAD 20
#define SIDE_PAD_2 40
#define LINE_HEIGHT 30
#define LINE_PAD 20


#define BACK_TEXT @"返回"
#define TEXT_BACK @"返回"
#define TEXT_SUBMIT @"發送"
#define TEXT_LOGIN @"登錄"
#define TEXT_NETWORK_ERROR @"網絡出錯"
#define TEXT_FORGOT_PASSWORD @"忘記密碼"
#define TEXT_TOU @"使用條款"
#define TEXT_MY_POINTS @"我的積分"
#define TEXT_TOP_UP_POINTS @"充值積分"
#define TEXT_NEXT_STEP @"下一步"
#define LEFT_ARROW @"\U000025C0"
#define DOWN_ARROW @"\U000025BC"
#define CLOSE_X @"\U00002715"

#define UNCHECK_BOX @"\U00002610"
#define CHECK_BOX @"\U00002714"

#define ERR_CONNECTION @"-99"
#define RETURN_OK @"0"


#define WX_ACCESS_TOKEN_KEY @"wxaccesstoken"
#define WX_REFRESH_TOKEN_KEY @"wxrefreshtoken"
#define WX_USER_UNION_ID @"wxunionid"
#define WX_USER_KEY @"wxuser"
#define WX_AUTH_CODE @"wxauthcode"

// access token for API User
#define K_ACCESS_TOKEN_KEY @"kaccesstoken"
#define K_REFRESH_TOKEN_KEY @"krefreshtoken"
// User Token
#define K_USER_OPENID @"kopenid"
#define K_USER_PHONE @"kuserphone"
#define K_USER_NAME @"kuser"
#define K_USER_GENDER @"kusergender"
#define K_USER_EMAIL @"kuseremail"

// User Token
#define K_NOT_LOGGED_IN 400001
#define K_AUTH_ERROR 400002



#define UICOLOR_GOLD UIColorFromRGB(0xD3A06B)
#define UICOLOR_DARK_GREY UIColorFromRGB(0x333333)
#define UICOLOR_LIGHT_GREY UIColorFromRGB(0xaaaaaa)
#define UICOLOR_PURPLE UIColorFromRGB(0x513B59)
#define UICOLOR_BLUE [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
#define UICOLOR_ERROR [UIColor colorWithRed:1 green:100/255.0 blue:100/255.0 alpha:1.0]
#define UICOLOR_VERY_LIGHT_GREY [UIColor colorWithWhite:0.95 alpha:1.0]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



/* Notifications */
#define WX_LOGIN_SUCCESS @"wxls"
#define WX_REGISTRATION_SUCCESS @"wxrs"
#define WX_REGISTER @"wxreg"
#define LOGIN_SUCCESS @"loginsuccess"
#define LOGOUT_SUCCESS @"logoutsuccess"

#define ON_BACK_PRESSED @"onbackpress"
#define HIDE_BACK_BTN @"hidebackbtn"
#define SHOW_BACK_BTN @"showbackbtn"
#define DISABLE_BACK_BTN @"disablebackbtn"
#define ENABLE_BACK_BTN @"enablebackbtn"


#define GO_SLIDE @"goslide"
#define CHANGE_TITLE @"changetitle"
#define LOAD_MESSAGE_DETAIL @"loadmd"

typedef enum {
    VC_TYPE_HOME = 0,
    VC_TYPE_MESSAGE_LIST = 1,
    VC_TYPE_MESSAGE_DETAIL = 2,
    VC_TYPE_SCAN_QRCODE = 3,
    VC_TYPE_MY = 4,
    VC_TYPE_MY_EDITINFO = 5,
    VC_TYPE_MY_WALLET = 6
} VC_TYPE;

#endif /* const_h */
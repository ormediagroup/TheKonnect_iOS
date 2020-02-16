//
//  AppDelegate.h
//  Konnect
//
//  Created by Jacky Mok on 3/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//
/* TODO : Invoice Create per item details
 TODO: Check Login Validity
 
 Version 1.12 (16/2/2020)
 1) Added Search Filters to Association Selection
 2) Added reset password
 3) Fixed Login (Clear Phone)
 4) Updated About Page & link to marketing kit
 5) Add / Open link in Office Promotion
 6) Add News Details
 7) Splitted Polyform event space / pop up lounge from meeting rooms
 8) Created separated flow for event space and popup lounge
 
 Version 1.11
 1) Code Guarded a JPUSH registration error (test)
 
 Version 1.10
 1) Changed Alignment Issue on FNB Page
 2) Changed to use JIGUANG notification
 3) Added Message Badge
 4) Changed Theme Color
 5) Changed Notification Message
 6) Need to fix Notification MEssage Scrolling
 
 Version 1.9 (9/1/2020)
 1) Fixed a crash on FNB food images
 2) Minor Change to set scroll to top on facility
 
 Version 1.8 (7/1/2020)
 1) Added support for dark theme
 2) Revised notification layout
 3) Fixed birthday for user
 4) Enhanced Meeting Room Booking Mechanism
 5) Add Meeting Room TOU
 6) Added Meeting Room Inquiry
 7) Hide Concerige Number from non-vip members
 8) Removed Carousel bottom bar
 9) Changed Event List Structure
 
 Verion 1.7
 1) Minor Text Fix
 
 Version 1.6
 1) 2nd Fixed a bug with unknown member tier
 2) Changed layout to fit an iPad simulator screen
 3) Fixed a crash with people clicking too fast with navigation controller
 
 
 Version 1.6(11/12/2019)
 1) Fixed a bug with unknown member tier
 2) Changed Apple Sign in button to square corner
 3) Added a "skip to homepage" in registration / sign in page
 
 
 Version 1.5 (11/12/2019)
 1) Fixed a bug with registration with no associate
 2) Fixed a display issue with logout
 3) Add swipe left to go back
 4) Add promo spot to FNB
 5) Fixed Booking Confirmation messaging
 6) Retain Search Query for meeting room booking
 7) Changed FNB Booking Interval to 30 mins
 8) Add Meeting Room Booking in Meeting Room Details
 9) Added Meeting Room Cancellation
 10) Changed Event Layout
 11) Added Past Event List
 12) Added ReserveNow Page
 13) Change MeetingRoom so you can book a room directly
 14) Added Apple ID Sign in
 
 Version 1.4
 1) Temp disable Top up
 2) Create Update / Force update
 3) Temp disable sharing
 
 Version 1.3 (26/11/2019)
 1) Registraion - Revised Association list
 2) Home page update member tier icon
 3) F&B page updated
 4) F&B Text Update
 5) Service Office Page overhaul
 6) Contact Us splitted into Biz / Concierge / Normal
 7) Added Concierge Page
 8) Misc. Text changes
 
 Version 1.2
 1) Fixed a problem with old Wechat UnionID cannot login
 
 Version 1.1
 1) Fixed a logout problem (not clearing company and offices in service office)
 2) Change HTTP to HTTPS
 3) Fixed a SEGFAULT on past bills (AOB)
 4) Fixed formatting issue on no min pay booking for FNB
 
 
 Verion 1.0 (14/11/2019)
 1) Fixed a display problem during first login on Membership bar
 2) Add Membership Icon badge in My Page
 3) Changed App name to all caps KONNECT
 4) Added Avatar Support
 
 
 Version 0.9 (12/11/2019)
 1) Updated Search Meeting Room interface
 2) Added booking price to room
 3) Fixed Logout Flow
 4) Enabled Personal / Company Print Quota
 5) Enabled New Payment Mechanism (with payment code) with Event Registration
 6) Meeting Room Lists
 7) Individual Meeting Room UI Update
 8) ScanQR
 9) shortcut to referral QR / payment QR
 
 
Version 0.8 (12/11/2019)
 1) Added Association Selection
 2) Added Pay by Invoice
 3) Added Food images for F&B
 4) Added Printing Top Up
 5) Added Service Office Service (Notifications)
 
Version 0.6 (09/11/2019)
 1) Stability Issue
 
version 0.5
 List of FNB
  - Booking
 Service Office
  - Invoices
 Contact Us
 Meeting Room Search
 Book Meeting Room

 
 
// China Domain
#define domain @"https://thekonnect.cn/"
#define K_API_ENDPOINT @"https://thekonnect.cn/app/"
#define OAUTH_CLIENT_ID @"0zkD0RRsP3LFxm7qGeSiu0CP4H1zA2UBCeeD666V"
#define OAUTH_CLIENT_SECRET @"9RBGeI7VXZer0Qg4yhD8kyKXMYAT5GPeyqVM92I6"
#define WX_APP_ID @"wx77be5b6b4e92dfc3"
#define WX_APP_SECRET @"fdc379ab02a37bc15bd652531a868b32"
 */

 // HK Domain
#define domain @"http://thekonnect.com.hk/"
#define K_API_ENDPOINT @"http://thekonnect.com.hk/app/"
#define OAUTH_CLIENT_ID @"WrLzj4dYnEhk43qVohbnWAlTCcRZs1BosmXLraJP"
#define OAUTH_CLIENT_SECRET @"P09U4zQsR2QNCcHfozfRAQf2ddOFoyuezD8DdY64"
#define WX_APP_ID @"wxe777ccc4f64f1c9e"
#define WX_APP_SECRET @"fc28264a98cd08d79cbac32321566178"

#define WX_SN_DOMAIN @"https://api.weixin.qq.com/sns/oauth2/"
#define WX_SN_VERIFY_TOKEN @"https://api.weixin.qq.com/sns/auth"
#define WX_SN_USERINFO @"https://api.weixin.qq.com/sns/userinfo"
#define WX_SN_TOKEN_ENDPOINT @"access_token"
#define WX_SN_REFRESH_ENDPOINT @"refresh_token"

#define WX_AUTH_SCOPE @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
/*

 */
#define OAUTH_AUTHORIZE_ENDPOINT @"/oauth/authorize"
#define OAUTH_TOKEN_ENDPOINT @"/oauth/token"


#define JPUSH_APP_KEY @"c95d89ad4650afcc11edaf6c"
#define JPUSH_DEVICE_TOKEN @"jpush_device_token"

#import <UIKit/UIKit.h>
#import "const.h"
#import "WXApiManager.h"
#import "KApiManager.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@import Firebase;
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiManagerDelegate, FIRMessagingDelegate, JPUSHRegisterDelegate> {
    CGFloat screenWidth, screenHeight;
    CGFloat headerHeight, footerHeight, statusBarHeight;
    NSCache *imageCache;
    NSUserDefaults *preferences;
    UIActivityIndicatorView *loading;
    BOOL WXisRegistration, isX, AppleIsRegistration;
    int msgBadge;
}
-(BOOL) isLoggedIn;
-(void) addDoneToKeyboard:(UITextField *)t;
//-(void) getWXAccessToken:(NSString *)code;
-(void) getWXAuthCode:(BOOL)isReg;
-(UIImage *) getImage:(NSString *)key callback:(void (^)(UIImage *image))callback;
-(void) makeToast:(NSString *)msg duration:(int)s inView:(UIView *)v;
@property (strong, nonatomic) UIWindow *window;
@property CGFloat screenWidth, screenHeight, headerHeight, footerHeight, statusBarHeight;
@property (strong, nonatomic) NSUserDefaults *preferences;
@property int msgBadge;
@property BOOL isX;
-(void) startLoading:(UIViewController *)vc;
-(void) startLoading;
-(void) stopLoading;
-(void) raiseAlert:(NSString *)title msg:(NSString *)msg;
-(void) raiseAlert:(NSString *)title msg:(NSString *)msg inViewController:(UIViewController *)vc;
-(void) raiseAlertSuccess:(NSString *)title msg:(NSString *)msg;
-(void) networkError;
-(void) logout;
-(BOOL) checkLogin;
-(void) addPlaceHolder:(UITextField*)f text:(NSString *)text;
-(void) addPlaceHolder:(UITextField*)f text:(NSString *)text center:(BOOL)center;
-(void) setSystemBG:(UIView *)p;
-(void) updateMsgBadge;
-(void) clearMsgBadge;
-(UIColor *) getThemeColor;

@end


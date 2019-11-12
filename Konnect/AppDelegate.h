//
//  AppDelegate.h
//  Konnect
//
//  Created by Jacky Mok on 3/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//
/* TODO : Invoice Create per item details

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
/*
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



#import <UIKit/UIKit.h>
#import "const.h"
#import "WXApiManager.h"
#import "KApiManager.h"
@import Firebase;
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiManagerDelegate, FIRMessagingDelegate> {
    CGFloat screenWidth, screenHeight;
    CGFloat headerHeight, footerHeight, statusBarHeight;
    NSCache *imageCache;
    NSUserDefaults *preferences;
    UIActivityIndicatorView *loading;
    BOOL WXisRegistration, isX;
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
-(NSString *) getPaymentCode;

@end


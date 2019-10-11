//
//  AppDelegate.h
//  Konnect
//
//  Created by Jacky Mok on 3/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//


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
-(void) networkError;
-(void) logout;
@end


//
//  AppDelegate.m
//  Konnect
//
//  Created by Jacky Mok on 3/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApiManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize screenWidth, screenHeight, headerHeight, footerHeight, preferences, statusBarHeight;
@synthesize  isX, msgBadge;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    screenWidth  = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    headerHeight=60;
    // is X
    footerHeight=60;
    statusBarHeight = 20;
    msgBadge = 0;
    [WXApiManager sharedManager].delegate = self;
    NSLog(@"WX API Version: %@",[WXApi getApiVersion]);
    [WXApi registerApp:WX_APP_ID enableMTA:YES];
    imageCache = [[NSCache alloc] init];
    
    preferences = [NSUserDefaults standardUserDefaults];
    loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    loading.layer.cornerRadius=50.0f;
    [loading setFrame:CGRectMake((screenWidth-100)/2,(screenHeight-100)/2,100,100)];
    
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            case 2436:
            case 2688:
            case 1792:
                isX = YES;
                break;
            default:
                break;
        }
    }
    if (isX) {
        //STATUS_BAR_HEIGHT = 94;
        footerHeight=80;
        headerHeight=80;
        statusBarHeight = 44;
    }
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    // [application registerForRemoteNotifications];
    /*
    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
                                                        NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error fetching remote instance ID: %@", error);
        } else {
            NSLog(@"Remote instance ID token: %@", result.token);
            NSString* message =
            [NSString stringWithFormat:@"Remote InstanceID token: %@", result.token];
           // self.instanceIDTokenMessage.text = message;
        }
    }];
     */
    
    // first login to K site
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      // 可以添加自定义 categories
      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

     // Required
     // init Push
    
     // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
     [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APP_KEY
                           channel:@"iOS"
                  apsForProduction:YES
             advertisingIdentifier:nil];
    
    // 1) Check if user is registered with Konnect
    // 2)     if yes - check if it's registered with WeChat
    // 3)         if yes - check wx access token is valid
    // 4)            if yes - refresh and refresh wx user data
    // 5)             if no - check refresh token is valid
    // 6)                 if yes - refresh
    // 7)                 if no - reauthorize
    // 8)         if no - check Konnect access token is valid
    // 9)             if yes - no action
    // 10)             if no - check refresh token i valid
    // 11)                 if yes - refresh
    // 12)                 if no - reauthorize
    // 13)    if no - login / register screen
    
    
    // 1) check if registered with konnect
    /*
    NSLog(@"WX_AUTH_CODE %@",[preferences objectForKey:WX_AUTH_CODE]);
    NSLog(@"WX_ACCESS_TOKEN %@",[preferences objectForKey:WX_ACCESS_TOKEN_KEY]);
    
    if (1 || ([preferences objectForKey:K_ACCESS_TOKEN_KEY] && [[preferences objectForKey:K_ACCESS_TOKEN_KEY] isKindOfClass:[NSDictionary class]])) {
        kAccessToken = [preferences objectForKey:K_ACCESS_TOKEN_KEY];
        kRefreshToken = [preferences objectForKey:K_REFRESH_TOKEN_KEY];
        kOpenID = [preferences objectForKey:K_USER_OPENID_KEY];
        // 2)     if yes - check if it's registered with WeChat
        if ([preferences objectForKey:WX_USER_KEY] && [[preferences objectForKey:WX_USER_KEY] isKindOfClass:[NSDictionary class]]) {
            // 3)         if yes - check wx access token is valid
            wxAccessToken = [preferences objectForKey:WX_ACCESS_TOKEN_KEY];
            wxRefreshToken = [preferences objectForKey:WX_REFRESH_TOKEN_KEY];
            wxOpenID = [preferences objectForKey:WX_USER_OPENID_KEY];
            int rc = [self checkWXAccessToken];
            if (rc==0) {
                // 4)            if yes - refresh and refresh wx user data
                NSLog(@"WX Access Token still valid");
                [self getWXUserInfo];
            } else if (rc == 42001 || rc==40001) {
                // token expired
                if ([self refreshWXAccessToken]==0) {
                    
                } else {
                  // let login take cares of it.
                }
            } else {
                // other weird error, reget auth
                [self getWXAuthCode];
            }
        } else {
            // 8)         if no - check Konnect access token is valid
            
        }
    } else {
        // do nothing and let the registration process take over
    }
     */
    return YES;
}


- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    NSString *dToken = JPUSHService.registrationID;
    
     [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-server",domain] param:
        [[NSDictionary alloc] initWithObjects:@[
                                                @"Jpush",
                                                @"uploadPhoneInfo",
                                                @"upload",
                                                dToken,
                                                @"ios",
                                                [preferences objectForKey:K_USER_OPENID]
                                                ]
                                      forKeys:@[
                                                @"c",
                                                @"a",
                                                @"action",
                                                @"registrationID",
                                                @"phoneType",
                                                @"userToken"
                                                ]]
        
                                        interation:0 callback:^(NSDictionary *data) {
                                            //NSLog(@"Wallet %@",data);
                                            NSLog(@"JPush Service registration: %@ %@", [data objectForKey:@"msg"], [self->preferences objectForKey:K_USER_OPENID]);
                                            if ([[data objectForKey:@"rc"] intValue]==0) {
                                            } else {
                                                NSLog(@"JPush Service registration: %@", [data objectForKey:@"msg"]);
                                            }
                                        }];
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"AD Message User Info: %@",[userInfo description]);
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"AD Jumped from Background Notification");
    } else {
        NSLog(@"AD Active Notification");
    
    }
    if ([[userInfo objectForKey:@"Type"] isKindOfClass:[NSString class]] && [[userInfo objectForKey:@"Type"] isEqualToString:@"PaymentRequest"]) {
    
        [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_TRANSACTION_REQUEST
                                                        object:[[NSDictionary alloc] initWithObjects:@[
                                                                                             [userInfo objectForKey:@"PaymentToken"],
                                                                                             [userInfo objectForKey:@"Amount"]
                                                                                                       ]
                                                                                             forKeys:@[
                                                                                                       PAYMENT_TOKEN,
                                                                                                       @"amount"]]];
    }
    
    // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:bva+bvb];
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
-(UIColor *) getThemeColor {
    if ([[preferences objectForKey:K_USER_TIER]  isKindOfClass:[NSString class]] && [[preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_LEGACY]) {
        return UICOLOR_PURPLE;
    } else {
        return UICOLOR_GREEN;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void) addDoneToKeyboard:(UITextField *)t{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(donePressed)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    t.inputAccessoryView = keyboardToolbar;
}
-(void)donePressed
{
    [self.window.rootViewController.view endEditing:YES];
}
-(void) getWXAccessToken {
    NSString *code = [preferences objectForKey:WX_AUTH_CODE];
    if (!code  || [code isEqualToString:@""]) {
        return [self getWXAuthCode:WXisRegistration];
    }
    NSString *urlS = [NSString stringWithFormat:@"%@%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_SN_DOMAIN,WX_SN_TOKEN_ENDPOINT,WX_APP_ID,WX_APP_SECRET,code];
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"GET"];
    
    [urlRequest setURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {        
        if (error) {
            NSLog(@"WX get token %@",[error description]);
        } else {
            NSDictionary *jsondata = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
            if (error) {
                NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"WX get token %@",s);
            } else {
                if ([jsondata objectForKey:@"access_token"] && ![[jsondata objectForKey:@"access_token"] isEqualToString:@""]) {
                    if (self->WXisRegistration) {                        
                        //registration
                        NSDictionary* result = (NSDictionary *)[[KApiManager sharedManager] tieWithWechat:[jsondata objectForKey:@"unionid"] userToken:[self->preferences objectForKey:K_USER_OPENID]];
                        NSLog(@"Delegate Register WX ID %@",result);
                        if ([[result objectForKey:@"rc"] intValue]!=0) {
                            dispatch_async(dispatch_get_main_queue(),^{
                                [self raiseAlert:@"微訊授權失敗" msg:[result objectForKey:@"errmsg"]];
                            });
                        } else {
                            // check WX Auth Code
                            dispatch_async(dispatch_get_main_queue(),^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                                [self makeToast:@"註冊成功！歡迎你成為KONNECT會員。" duration:5 inView:self.window.rootViewController.view];
                            });
                        }
                    } else {
                        dispatch_queue_t createQueue = dispatch_queue_create("SerialQueue", nil);
                        dispatch_async(createQueue, ^(){
                            NSDictionary *result = (NSDictionary *)[[KApiManager sharedManager] logWithWeChat:[jsondata objectForKey:@"unionid"]];
                            dispatch_async(dispatch_get_main_queue(), ^(){
                                NSLog(@"App Delegate Login with Wechat %@",result);                               
                                [self->preferences setObject:[jsondata objectForKey:@"access_token"] forKey:WX_ACCESS_TOKEN_KEY];
                                [self->preferences setObject:[jsondata objectForKey:@"refresh_token"] forKey:WX_REFRESH_TOKEN_KEY];
                                [self->preferences setObject:[jsondata objectForKey:@"unionid"] forKey:WX_USER_UNION_ID];
                                [self->preferences synchronize];
                                NSLog(@"WX Got Access Token: %@",[jsondata objectForKey:@"access_token"]);
                                NSLog(@"WX Got Refresh Token: %@",[jsondata objectForKey:@"refresh_token"]);
                                NSLog(@"WX Got OpenID: %@",[jsondata objectForKey:@"unionid"]);
                                if ([[result objectForKey:@"rc"] intValue]==0) {                                   
                                    // [self getWXUserInfo];
                                    dispatch_queue_t createQueue = dispatch_queue_create("SerialQueue", nil);
                                    dispatch_async(createQueue, ^(){
                                        NSDictionary *data = [[KApiManager sharedManager] logWithWeChat:[self->preferences objectForKey:WX_USER_UNION_ID]];
                                        dispatch_async(dispatch_get_main_queue(), ^(){
                                            if ([[data objectForKey:@"rc"] intValue]==0) {
                                                [self->preferences setObject:[data objectForKey:K_USER_OPENID] forKey:K_USER_OPENID];
                                                [self->preferences setObject:[data objectForKey:K_USER_PHONE] forKey:K_USER_PHONE];
                                                [self->preferences setObject:[data objectForKey:K_USER_NAME] forKey:K_USER_NAME];
                                                [self->preferences setObject:[data objectForKey:K_USER_GENDER] forKey:K_USER_GENDER];
                                                [self->preferences setObject:[data objectForKey:K_USER_EMAIL] forKey:K_USER_EMAIL];
                                                [self->preferences setObject:[data objectForKey:K_USER_NO] forKey:K_USER_NO];
                                                [self->preferences setObject:[data objectForKey:K_USER_TIER] forKey:K_USER_TIER];
                                                [self->preferences setObject:[data objectForKey:K_USER_AVATAR] forKey:K_USER_AVATAR];
                                                [self->preferences synchronize];
                                                NSLog(@"App Wechat Login: %@",data);
                                                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                                            }
                                        });
                                    });
                                } else {
                                    // Phone not registered
                                    [[NSNotificationCenter defaultCenter] postNotificationName:WX_REGISTER object:nil];
                                }
                            });
                        });
                    }
                } else {
                     [self makeToast:[NSString stringWithFormat:@"微訊授權失敗: %@",[jsondata objectForKey:@"errcode"]] duration:4 inView:self.window.rootViewController.view];
                }
            }
        }
    }];
}
-(void) logout {
    [preferences removeObjectForKey:WX_USER_UNION_ID];
    [preferences removeObjectForKey:K_USER_OPENID];
    [preferences removeObjectForKey:K_USER_NAME];
    [preferences removeObjectForKey:K_USER_GENDER];
    [preferences removeObjectForKey:K_USER_EMAIL];
    [preferences removeObjectForKey:K_USER_NO];
    [preferences removeObjectForKey:K_USER_AVATAR];
    [preferences removeObjectForKey:K_USER_TIER];
    [preferences removeObjectForKey:APPLE_USER_ID];
    [preferences synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT_SUCCESS object:nil];
}
-(BOOL) isLoggedIn {
    if ([[preferences objectForKey:K_USER_OPENID] isKindOfClass:[NSString class]]
        && [[preferences objectForKey:K_USER_OPENID] length] >0) {
        return true;
    }
    return false;
    
}
-(BOOL) checkLogin {
    if ([self isLoggedIn]) {
        return YES;
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_PLEASE_LOGIN
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_GO_LOGIN style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_LOGIN object:nil];
            
        }];
        [alert addAction:defaultAction];
        [alert addAction:[UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        return NO;
    }
}
-(void) getWXAuthCode:(BOOL) isReg {
    WXisRegistration = isReg;
    SendAuthReq* req =[[SendAuthReq alloc]init];
    
    req.scope = WX_AUTH_SCOPE;
    req.state = @"1234567890";
    //第三方向微信终端发送一个SendAuthReq消息结构
    //  [WXApi sendReq:req];
    [WXApi sendAuthReq:req viewController:self.window.rootViewController delegate:[WXApiManager sharedManager]];
}
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    if (response.errCode!=0) {
        [self makeToast:[NSString stringWithFormat:@"微訊授權失敗: %d",response.errCode] duration:4 inView:self.window.rootViewController.view];
    } else {
        [preferences setObject:response.code forKey:WX_AUTH_CODE];
        [preferences synchronize];
        [self getWXAccessToken];
    }
}
-(int) refreshWXAccessToken {
    NSString *urlS = [NSString stringWithFormat:@"%@%@?appid=%@&refresh_token=%@&grant_type=refresh_token",WX_SN_DOMAIN,WX_SN_REFRESH_ENDPOINT,WX_APP_ID,
                      [[NSUserDefaults standardUserDefaults] objectForKey:WX_REFRESH_TOKEN_KEY]];
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setURL:url];
    
    
    NSError *err;
    NSURLResponse *resp;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:&resp
                                                     error:&err];
    if (err) {
        NSLog(@"Verify Token Error: %@",[err description]);
        return -99;
    }
    NSMutableDictionary *jsondata = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&err];
    if (err) {
        NSLog(@"Verify Token Error (json): %@",[err description]);
        return -98;
    } else {
        if ([[jsondata objectForKey:@"refresh_token"] isKindOfClass:[NSString class]] && ![[jsondata objectForKey:@"refresh_token"] isEqualToString:@""]) {
            [preferences setObject:[jsondata objectForKey:@"refresh_token"] forKey:WX_ACCESS_TOKEN_KEY];
            [preferences synchronize];
            return 0;
        }
        return [[jsondata objectForKey:@"errcode"] intValue];
    }
}
-(int) checkWXAccessToken {
    NSString *urlS = [NSString stringWithFormat:@"%@?access_token=%@&openid=%@",WX_SN_VERIFY_TOKEN,[[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN_KEY],[[NSUserDefaults standardUserDefaults] objectForKey:WX_USER_UNION_ID]];
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setURL:url];
    

    NSError *err;
    NSURLResponse *resp;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:&resp
                                                     error:&err];
    if (err) {
        NSLog(@"Verify Token Error: %@",[err description]);
        return -99;
    }
    NSMutableDictionary *jsondata = [NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&err];
    if (err) {
        NSLog(@"Verify Token Error (json): %@",[err description]);
        return -98;
    } else {
        if ([jsondata objectForKey:@"errcode"] !=0 ) {
            NSLog(@"WX Verify Token Error: %@",[jsondata objectForKey:@"errcode"]);
        }
        return [[jsondata objectForKey:@"errcode"] intValue];
    }
}
-(void) getWXUserInfo {
    NSString *urlS = [NSString stringWithFormat:@"%@?access_token=%@&openid=%@",WX_SN_USERINFO,[[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN_KEY],[[NSUserDefaults standardUserDefaults] objectForKey:WX_USER_UNION_ID]];
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"WX getUser %@",[error description]);
        } else {
            NSDictionary *jsondata = [NSJSONSerialization
                                      JSONObjectWithData:data
                                      options:kNilOptions
                                      error:&error];
            if (error) {
                NSLog(@"WX getUser %@",[error description]);
                NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"WX getUser %@",s);
            } else {
                if ([jsondata objectForKey:@"unionid"] && ![[jsondata objectForKey:@"unionid"] isEqualToString:@""]) {                    
                    [self->preferences setObject:jsondata forKey:WX_USER_KEY];
                    [self->preferences synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:WX_LOGIN_SUCCESS object:nil];
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self makeToast:[NSString stringWithFormat:@"微訊授權失敗: %@",[jsondata objectForKey:@"errcode"]] duration:4 inView:self.window.rootViewController.view];
                    });
                }
            }
        }
    }];
}

-(void) makeToast:(NSString *)msg duration:(int)s inView:(UIView *)v{
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self->screenWidth-100,50)];
        [lbl setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
        [lbl setText:msg];
        [lbl setNumberOfLines:-1];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl sizeToFit];
        lbl.layer.cornerRadius = 5.0f;
        int top = self->screenHeight-lbl.frame.size.height-40;
        [lbl setFrame:CGRectMake((self->screenWidth-lbl.frame.size.width)/2-20,self->screenHeight,lbl.frame.size.width+40,lbl.frame.size.height+20)];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        
            [v  addSubview:lbl];
            [UIView animateWithDuration:0.6 animations:^{
                [lbl setFrame:CGRectMake(lbl.frame.origin.x,top,lbl.frame.size.width,lbl.frame.size.height)];
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, s * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [lbl removeFromSuperview];
                });
            }];
    });
    
}
-(UIImage *) getImage:(NSString *)key callback:(void (^)(UIImage *image))callback {
    if (![key isKindOfClass:[NSString class]]) return nil;
    NSArray *parts = [key componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];
    if (filename != nil && ![filename isEqual:[NSNull null]]) {
        // NSLog(@"Retrieving %@",key);
        UIImage * _cachedImage = (UIImage *)[imageCache objectForKey:filename];
        if (!_cachedImage) {
            //          NSLog(@"Not found.. loading from url.. %@",filename);
            if (callback !=nil) {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
                dispatch_async(queue, ^{
                    // NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
                    UIImage *image = [self downloadImage:key];
                    if (image) {
                        [self->imageCache setObject:image forKey:filename];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //   UIImage *image = [UIImage imageWithData:imageData];
                        if (callback) {
                            if (image) {
                                callback(image);
                            } else {
                                NSLog(@"AD getImage warning image is null %@",filename);
                            }
                        }
                    });
                });
                _cachedImage = [UIImage imageNamed:@"placeholder.png"];
            } else {
                _cachedImage = [self downloadImage:key];
                if (_cachedImage) {
                    [imageCache setObject:_cachedImage forKey:filename];
                }
            }
        } else {
            // NSLog(@"found in cache.. %@",key);
            dispatch_async(dispatch_get_main_queue(), ^{
                //   UIImage *image = [UIImage imageWithData:imageData];
                if (callback) {
                    callback(_cachedImage);
                }
            });
        }
        return _cachedImage;
    } else {
        return nil;
    }
}
-(UIImage *) downloadImage:(NSString *) url {
    
    // Get an image from the URL below
    //    NSString *utf8url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *parts = [url componentsSeparatedByString:@"/"];
    NSString *filename = [parts lastObject];
    NSString *path = [url stringByReplacingOccurrencesOfString:filename withString:@""];
    NSString *utf8url = [NSString stringWithFormat:@"%@%@",path,[filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *imageurl = [NSURL URLWithString:utf8url];
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageurl]];
    
    
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *file = [filename componentsSeparatedByString:@"."];
    NSString *ext = [file lastObject];
    NSString *outputFilePath = [NSString stringWithFormat:@"%@/%@",docDir, filename];
    NSData *data2;
    if ([ext caseInsensitiveCompare:@"png"]==NSOrderedSame) {
        data2 = [NSData dataWithData:UIImagePNGRepresentation(image)];//1.0f = 100% quality
    } else {
        data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        //    NSLog(@"saving image done");
    }
    [data2 writeToFile:outputFilePath atomically:YES];
    return image;
}
-(void) moveImage:(UIImage *) image name:(NSString *)filename {
    //  NSLog(@"Downloading...");
    // Get an image from the URL below
    //NSLog(@"AD: moving Image with filename %@",filename);
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *file = [filename componentsSeparatedByString:@"."];
    NSString *ext = [file lastObject];
    NSString *outputFilePath = [NSString stringWithFormat:@"%@/%@",docDir, filename];
    NSData *data2;
    if ([ext caseInsensitiveCompare:@"png"]==NSOrderedSame) {
        data2 = [NSData dataWithData:UIImagePNGRepresentation(image)];//1.0f = 100% quality
    } else {
        data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        //    NSLog(@"saving image done");
    }
    [data2 writeToFile:outputFilePath atomically:YES];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
  if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //从通知界面直接进入应用
  }else{
    //从通知设置界面进入应用
  }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  // Required
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [self updateMsgBadge];
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
  }
    if ([@"message" isEqualToString:[userInfo objectForKey:@"type"]]) {
        if ([[userInfo objectForKey:@"ID"] isKindOfClass:[NSString class]] && ![@"" isEqualToString:[userInfo objectForKey:@"ID"]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                   [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MESSAGE_DETAIL],[userInfo objectForKey:@"ID"]] forKeys:@[@"type",@"messageID"]]];
        }
    }
  completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

  // Required, iOS 7 Support
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}

-(void) startLoading {
    [self startLoading:self.window.rootViewController];
}
-(void) startLoading:(UIViewController *)vc  {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->loading startAnimating];
        [vc.view addSubview:self->loading];
    });
}
-(void) stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        [self->loading stopAnimating];
        [self->loading removeFromSuperview];
    });
    
}
-(void) raiseAlert:(NSString *)title msg:(NSString *)msg inViewController:(UIViewController *)vc {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alert animated:YES completion:nil];
    });
}
-(void) raiseAlert:(NSString *)title msg:(NSString *)msg {
    [self raiseAlert:title msg:msg inViewController:self.window.rootViewController];
}
-(void) networkError {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"網絡出錯，請重試"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window.rootViewController presentViewController:alert animated:YES completion:^{
            
        }];
    });
    
}
-(void) raiseAlertSuccess:(NSString *)title msg:(NSString *)msg {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
-(void) addPlaceHolder:(UITextField*)f text:(NSString *)text center:(BOOL)center{
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    if (center) {
        paragraphStyle.alignment = NSTextAlignmentCenter;
    } else {
        paragraphStyle.alignment = NSTextAlignmentLeft;
    }
    f.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:UICOLOR_LIGHT_GREY,
                                                                                           NSParagraphStyleAttributeName:paragraphStyle}];
}
-(void) addPlaceHolder:(UITextField*)f text:(NSString *)text {
    [self addPlaceHolder:f text:text center:NO];
}
-(void) setSystemBG:(UIView *)p {
    if (@available(iOS 13, *)) {
        [p setBackgroundColor:[UIColor systemBackgroundColor]];
    } else {
        [p setBackgroundColor:[UIColor whiteColor]];
    }
}
-(void) updateMsgBadge {
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-message",K_API_ENDPOINT] param:
      [[NSDictionary alloc] initWithObjects:@[
                                              @"get_unread",
                                              ]
                                    forKeys:@[
                                              @"action",
                                              ]]
      
                                      interation:0 callback:^(NSDictionary *data) {
                                          //NSLog(@"Wallet %@",data);
                                          if ([[data objectForKey:@"rc"] intValue]==0) {
                                              self->msgBadge = [[data objectForKey:@"data"] intValue];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_MSG_BADGE object:nil];
                                          } else {
                                              [self raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                          }
                                      }];
    //
}
-(void) clearMsgBadge {
    self->msgBadge = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_MSG_BADGE object:nil];
}
@end


//
//  KApiManager.h
//  Konnect
//
//  Created by Jacky Mok on 8/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#ifndef KApiManager_h
#define KApiManager_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KApiManager : NSObject

+ (instancetype)sharedManager;
-(void) getResultAsync:(NSString *)urlS param:(NSDictionary *)params interation:(int)i callback:(void (^)(NSDictionary *data))callback;
-(NSDictionary *) verifyRegUser:(NSString *)username verification:(NSString *)code withEmail:(NSString *) email andReferer:(NSString *)assoc;
-(NSDictionary *) verifyWXUser:(NSString *)username verification:(NSString *)code unionID:(NSString *)unionid;
-(NSDictionary *) verifyAppleUser:(NSString *)username verification:(NSString *)code appleID:(NSString *)appleid;
-(id) setPassword:(NSString *)userToken password:(NSString *)password;
-(id) tieWithWechat:(NSString *)unionID userToken:(NSString *)userToken;
-(id) logWithWeChat:(NSString *)unionID;
-(id) uploadImage:(UIImage *)i;
-(id) logWithPassword:(NSString *)username withPassord:(NSString *)password;
-(id) logWithApple:(NSString *)appleID;
@end
#endif /* KApiManager_h */

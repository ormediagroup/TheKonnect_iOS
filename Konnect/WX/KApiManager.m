//
//  KApiManager.m
//  Konnect
//
//  Created by Jacky Mok on 8/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//


#import "KApiManager.h"
#import "AppDelegate.h"
#import "const.h"
@implementation KApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static KApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[KApiManager alloc] init];
    });
    return instance;
}

-(NSString *) getKAuthCode {
    NSString *urlS = [NSString stringWithFormat:@"%@%@?response_type=code&client_id=%@",domain,OAUTH_AUTHORIZE_ENDPOINT,OAUTH_CLIENT_ID];
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"GET"];
    
    [urlRequest setURL:url];
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];

    if (error) {
        NSLog(@"OAuth getAuthCode: %@",[error description]);
        return ERR_CONNECTION;
    } else {
        NSDictionary *jsondata = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
        if (error) {
            NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"OAuth getAuthCode: %@",s);
            return ERR_CONNECTION;
        } else {
            return [jsondata objectForKey:@"code"];
        }
    }
}
-(NSString *)getKAccessToken:(NSString *)code {
    NSString *urlS = [NSString stringWithFormat:@"%@%@",domain,OAUTH_TOKEN_ENDPOINT,OAUTH_CLIENT_ID];
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *post = [NSString stringWithFormat:@"grant_type=authorization_code&code=%@&client_id=%@&client_secret=%@",
                      code,
                      OAUTH_CLIENT_ID,
                      OAUTH_CLIENT_SECRET
                      ];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    // setting the body of the post to the reqeust
    [urlRequest setHTTPBody:postData];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set the content-length
    [urlRequest setURL:url];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];
    if (error) {
        NSLog(@"K get access token: %@",[error description]);
        return ERR_CONNECTION;
    } else {
        NSDictionary *jsondata = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
        if (error) {
            NSLog(@"K get access token: %@",[jsondata description]);
            return ERR_CONNECTION;
        } else {
            if ([jsondata objectForKey:@"access_token"] && ![@"" isEqualToString:[jsondata objectForKey:@"access_token"]]) {
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                [preferences setObject:[jsondata objectForKey:@"access_token"] forKey:K_ACCESS_TOKEN_KEY];
                [preferences setObject:[jsondata objectForKey:@"refreh_token"] forKey:K_REFRESH_TOKEN_KEY];
                [preferences synchronize];
                return RETURN_OK;
            } else if ([jsondata objectForKey:@"error"]) {
                NSLog(@"K get access token: %@",[jsondata objectForKey:@"error"]);
                return ERR_CONNECTION;
            }
            NSLog(@"K get access token");
            return ERR_CONNECTION;
        }        
    }
}

/*
// Returns:
    NSError
    jsondata
 */
-(id) getResultSync:(NSString *)urlS param:(NSDictionary *)params interation:(int)i {
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"POST"];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *post = [NSString stringWithFormat:@"%@=%@",K_USER_OPENID,[delegate.preferences objectForKey:K_USER_OPENID]];
    for (NSString *key in params) {
        post = [NSString stringWithFormat:@"%@&%@=%@",
                post,
                key,
                [params objectForKey:key]
                ];
    }
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
     
    // setting the body of the post to the reqeust
    [urlRequest setHTTPBody:postData];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    // set the content-length
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@",[pref objectForKey:K_ACCESS_TOKEN_KEY]] forHTTPHeaderField:@"authorization"];
    [urlRequest setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [urlRequest setURL:url];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&resp error:&error];
    if (error) {
        NSLog(@"K get URL sync %@ with Error %@",urlS, [error description]);
        return error;
    } else {
        NSDictionary *jsondata = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
        if (error) {
            NSLog(@"K get URL sync %@ with Error %@",urlS, [error description]);
            NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Invalid data: %@",datastr);
            return error;
        } else {
            if ([[jsondata objectForKey:@"errcode"] intValue]==K_NOT_LOGGED_IN) {
                if (i==0) {
                    // refresh token
                    if ([[self getKAccessToken:[self getKAuthCode]] isEqualToString:RETURN_OK]) {
                        return [self getResultSync:urlS param:params interation:1];
                    } else {
                        return [NSError errorWithDomain:@"Konnect" code:K_AUTH_ERROR userInfo:nil];
                    }
                }
            }
            return jsondata;
        }
    }
}
-(void) getResultAsync:(NSString *)urlS param:(NSDictionary *)params interation:(int)i callback:(void (^)(NSDictionary *data))callback {
    NSURL *url = [NSURL URLWithString:urlS];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urlRequest setHTTPShouldHandleCookies:NO];
    [urlRequest setTimeoutInterval:60];
    [urlRequest setHTTPMethod:@"POST"];

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *post = [NSString stringWithFormat:@"%@=%@",K_USER_OPENID,[delegate.preferences objectForKey:K_USER_OPENID]];
    for (NSString *key in params) {
        post = [NSString stringWithFormat:@"%@&%@=%@",
                post,
                key,
                [params objectForKey:key]
                ];
    }
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu",[postData length]];
    
    // setting the body of the post to the reqeust
    [urlRequest setHTTPBody:postData];
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    // set the content-length
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:[NSString stringWithFormat:@"Bearer %@",[pref objectForKey:K_ACCESS_TOKEN_KEY]] forHTTPHeaderField:@"authorization"];
    [urlRequest setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [urlRequest setURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSDictionary *jsondata = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
        [delegate stopLoading];
        if (error) {
            NSLog(@"K get URL async %@ with Error %@",urlS, [error description]);
            NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Invalid data: %@",datastr);
        } else {
            if ([[jsondata objectForKey:@"errcode"] intValue]==K_NOT_LOGGED_IN) {
                if (i==0) {
                    // refresh token
                    if ([[self getKAccessToken:[self getKAuthCode]] isEqualToString:RETURN_OK]) {
                        [self getResultAsync:urlS param:params interation:1 callback:callback];
                        return;
                    } else {
                        // return [NSError errorWithDomain:@"Konnect" code:K_AUTH_ERROR userInfo:nil];
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(jsondata);
                });
            }
        }
    }];
}
-(NSDictionary *) login:(NSString *)username pw:(NSString *)pw {
    return [self getResultSync:@"" param:[NSDictionary dictionaryWithObjects:@[username, pw] forKeys:@[@"username",@"pw"]] interation:0];
}
-(id) verifyRegUser:(NSString *)username verification:(NSString *)code  withEmail:(NSString *) email andReferer:(NSString *)assoc{
    return [self getResultSync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                         param:[NSDictionary dictionaryWithObjects:
                                    @[username, code, email,assoc, @"verifycode"] forKeys:@[@"username",@"code",@"emailaddr",@"assoc",@"action"]]
                    interation:0];
}
-(NSDictionary *) verifyWXUser:(NSString *)username verification:(NSString *)code unionID:(NSString *)unionid{
    return [self getResultSync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                         param:[NSDictionary dictionaryWithObjects:
                                @[username, code, unionid, @"verifycodeWX"] forKeys:@[@"username",@"code",@"unionid",@"action"]]
                    interation:0];
}
-(id) setPassword:(NSString *)userToken password:(NSString *)password {    
    return [self getResultSync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                         param:[NSDictionary dictionaryWithObjects:
                                @[userToken, password, @"setPassword"] forKeys:@[K_USER_OPENID,@"userPass",@"action"]]
                    interation:0];
}
-(id) tieWithWechat:(NSString *)unionID userToken:(NSString *)userToken{
    return [self getResultSync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                         param:[NSDictionary dictionaryWithObjects:
                                @[userToken, unionID, @"tieWechat"] forKeys:@[K_USER_OPENID,@"unionid",@"action"]]
                    interation:0];
}
-(id) logWithWeChat:(NSString *)unionID {
    return [self getResultSync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                         param:[NSDictionary dictionaryWithObjects:
                                @[unionID, @"loginWechat"] forKeys:@[@"unionid",@"action"]]
                    interation:0];
}
-(id) logWithPassword:(NSString *)username withPassord:(NSString *)password {
    return [self getResultSync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                         param:[NSDictionary dictionaryWithObjects:
                                @[username, password, @"loginPassword"] forKeys:@[@"username",@"password",@"action"]]
                    interation:0];
}
@end

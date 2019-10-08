//
//  RegisterViewController.m
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "RegisterViewController.h"
#import "const.h"
#import "AppDelegate.h"
#import "LoginOrReg.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize parent, regType, showWXMessage;
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil
                               bundle:nibBundleOrNil]) {
        regType = REG_TYPE_PHONE;
        showWXMessage=NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.    
    areaCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [areaCode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [areaCode setTitle:@"852" forState:UIControlStateNormal];
    UITextField *arrow = [[UITextField alloc] initWithFrame:CGRectMake(70,0,10,LINE_HEIGHT)];
    [arrow setText:DOWN_ARROW];
    [arrow setFont:[UIFont systemFontOfSize:10]];
    [areaCode addSubview:arrow];
    areaCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [areaCode setFrame:CGRectMake(SIDE_PAD_2,0,80,LINE_HEIGHT)];
    [areaCode addTarget:self action:@selector(changeAreaCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:areaCode];
    
    phoneOK = NO;
    
    phone = [[UITextField alloc] initWithFrame:CGRectMake(120,0,delegate.screenWidth-140-SIDE_PAD,LINE_HEIGHT)];
    [phone setKeyboardType:UIKeyboardTypePhonePad];
    [phone setPlaceholder:@"手機號碼"];
    [phone setPlaceholder:@"請輸入8個位手機號碼"];
    [phone setTextAlignment:NSTextAlignmentCenter];
    [delegate addDoneToKeyboard:phone];
    [phone setDelegate:self];
    clearPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearPhone setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearPhone setTitle:CLOSE_X forState:UIControlStateNormal];
    [clearPhone setFrame:CGRectMake(delegate.screenWidth-SIDE_PAD_2-20,0,20,LINE_HEIGHT)];
    [clearPhone addTarget:self action:@selector(clearPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearPhone];
    
    [self.view addSubview:phone];
    {
        phoneLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,LINE_HEIGHT+10,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [phoneLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:phoneLine];
    }
    
    
    verification = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD_2,LINE_HEIGHT+40,delegate.screenWidth-180-SIDE_PAD-SIDE_PAD,LINE_HEIGHT)];
    [verification setKeyboardType:UIKeyboardTypeNumberPad];
    verification.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [verification setSecureTextEntry:YES];
    [verification setPlaceholder:@"請輸6個位入認證碼"];
    verification.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [delegate addDoneToKeyboard:verification];
    [verification setDelegate:self];
    clearVerification = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearVerification setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearVerification setTitle:CLOSE_X forState:UIControlStateNormal];
    [clearVerification setFrame:CGRectMake(delegate.screenWidth-20-SIDE_PAD_2,LINE_HEIGHT+40,20,LINE_HEIGHT)];
    [clearVerification addTarget:self action:@selector(clearVerification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearVerification];
    [self.view addSubview:verification];
    
    sendVerification = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendVerification setTitle:@"發送認證碼" forState:UIControlStateNormal];
    [sendVerification.titleLabel setFont:[UIFont systemFontOfSize:FONT_XS]];
    [sendVerification.layer setCornerRadius:5.0f];
    [self toggleVerificationButton:NO];
    sendVerification.layer.borderWidth= 0.5f;
    [sendVerification setFrame:CGRectMake(delegate.screenWidth-180,LINE_HEIGHT+42,105,LINE_HEIGHT-4)];
    [sendVerification addTarget:self action:@selector(sendVerification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendVerification];
    
    {
        verificationLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,LINE_HEIGHT+LINE_HEIGHT+50,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [verificationLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:verificationLine];
    }
    
    int y =LINE_HEIGHT+LINE_HEIGHT+50+LINE_HEIGHT;
    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(delegate.screenWidth/2-120,y,240,LINE_HEIGHT)];
    [self.view addSubview:h];
    tou = [UIButton buttonWithType:UIButtonTypeCustom];
    [tou setFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
    [tou setTitle:@"我已閱讀並接受" forState:UIControlStateNormal];
    [tou setContentEdgeInsets:UIEdgeInsetsMake(0,30, 0, 0)];
    tou.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    tou.tag = 0;
    [tou setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [tou.titleLabel setFont:[UIFont systemFontOfSize:FONT_XS]];
    [tou addTarget:self action:@selector(toggleCheck) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *tick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked.png"]];
    tick.tag=99;
    [tick setFrame:CGRectMake(0,4,20,20)];
    [tou addSubview:tick];
    [h addSubview:tou];
    
    UIButton *goTOU = [UIButton buttonWithType:UIButtonTypeCustom];
    [goTOU setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [goTOU setTitle:@"《使用條款》" forState:UIControlStateNormal];
    goTOU.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [goTOU.titleLabel setFont:[UIFont systemFontOfSize:FONT_XS]];
    [goTOU setFrame:CGRectMake(146,0,100,LINE_HEIGHT)];
    [h addSubview:goTOU];
    
    y+=LINE_HEIGHT+LINE_HEIGHT;
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setImage:[UIImage imageNamed:@"goldbutton.png"] forState:UIControlStateNormal];
    [submit setFrame:CGRectMake(SIDE_PAD_2, y, delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2, 44)];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self toggleSubmitButton:NO];
    
    UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,submit.frame.size.width, submit.frame.size.height)];
    [btnLbl setText:TEXT_NEXT_STEP];
    [btnLbl setTextColor:UICOLOR_DARK_GREY];
    [btnLbl setFont:[UIFont boldSystemFontOfSize:FONT_L]];
    [submit addSubview:btnLbl];
    [btnLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:submit];
    
    y+= 36+LINE_HEIGHT;
    
    
  
    y += 100;
    errorMessage = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT*2)];
    [errorMessage setTextColor:UICOLOR_ERROR];
    [errorMessage setNumberOfLines:-1];
    [errorMessage setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:errorMessage];
    
}
-(void) viewWillAppear:(BOOL)animated {
    [self textFieldDidEndEditing:phone];
    [self textFieldDidEndEditing:verification];
}
-(void) viewDidAppear:(BOOL)animated {
    if (regType == REG_TYPE_WECHAT && showWXMessage==YES) {
        showWXMessage = NO;
        [delegate raiseAlert:@"微訊綁定成功" msg:@"請輸入你的手機號碼完成註冊。"];
    }
}
-(void) toggleCheck {
    UIImageView *c = [tou viewWithTag:99];
    if (tou.tag==0) {
        tou.tag = 1;
        [c setImage:[UIImage imageNamed:@"checked.png"]];
        [self textFieldDidEndEditing:verification];
    } else {
        tou.tag = 0;
        [c setImage:[UIImage imageNamed:@"unchecked.png"]];
    }
    
}
-(void) clearPhone {
    [phone setText:@""];
    [self toggleSubmitButton:NO];
    [self toggleVerificationButton:NO];
}
-(void) clearVerification{
    [verification setText:@""];
    [self toggleSubmitButton:NO];
}
-(void) donePressed {
    [self setEditing:NO];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == phone) {
        [phoneLine setBackgroundColor:UICOLOR_GOLD];
        [verificationLine setBackgroundColor:[UIColor lightGrayColor]];
    } else if (textField==verification) {
        [verificationLine setBackgroundColor:UICOLOR_GOLD];
        [phoneLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    return YES;
}
-(void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField==phone) {
        if ([areaCode.titleLabel.text isEqualToString:@"852"]) {
            if (phone.text.length==8) {
                [self checkUsername];
            } else {
                [self toggleVerificationButton:NO];
            }
        } else if ([areaCode.titleLabel.text isEqualToString:@"853"]) {
            if (phone.text.length==8) {
                [self checkUsername];
            } else {
                [self toggleVerificationButton:NO];
            }
        } else if ([areaCode.titleLabel.text isEqualToString:@"86"]) {
            if (phone.text.length==11) {
                [self checkUsername];
            } else {
                [self toggleVerificationButton:NO];
            }
        } else {
            
        }
    } else if (textField==verification) {
        if (verification.text.length==6 && phoneOK  && tou.tag==1) {
            [self toggleSubmitButton:YES];
        }
            
    }
}
-(void) submit {
    [delegate startLoading];
    
    NSString *areacodetext = areaCode.titleLabel.text;
    NSString *phonetext = phone.text;
    NSString *vtext = verification.text;
    dispatch_queue_t createQueue = dispatch_queue_create("SerialQueue", nil);
    if (regType == REG_TYPE_PHONE) {
        dispatch_async(createQueue, ^(){
            NSObject *data = [[KApiManager sharedManager] verifyRegUser:[NSString stringWithFormat:@"%@%@",areacodetext,phonetext] verification:vtext];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self->delegate stopLoading];
                [self submitComplete:data];
            });
        });
    } else {
        dispatch_async(createQueue, ^(){
            NSDictionary *data = [[KApiManager sharedManager] verifyWXUser:[NSString stringWithFormat:@"%@%@",areacodetext,phonetext] verification:vtext unionID:[[NSUserDefaults standardUserDefaults] objectForKey:WX_USER_UNION_ID]];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self->delegate stopLoading];
                if ([[data objectForKey:@"errcode"] intValue]!=0) {
                    [delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                } else {
                    if ([[data objectForKey:@"rc"] intValue]==0) {
                        [self->delegate.preferences setObject:[data objectForKey:K_USER_OPENID] forKey:K_USER_OPENID];
                        [self->delegate.preferences setObject:[data objectForKey:K_USER_PHONE] forKey:K_USER_PHONE];
                        [self->delegate.preferences synchronize];                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                        [self->delegate makeToast:@"註冊成功！歡迎你成為Konnect+會員。" duration:5 inView:self->delegate.window.rootViewController.view];
                    } else {
                         [self->errorMessage setText:@"驗證碼不正確"];
                    }
                }
            });
        });
    }
}
 -(void) submitComplete:(NSObject *)data {
     [delegate stopLoading];
     if ([data isKindOfClass:[NSError class]]) {
         [delegate networkError];
     } else {
         NSDictionary *json = (NSDictionary *)data;
         if ([[json objectForKey:@"errcode"] intValue]!=0) {
             [delegate raiseAlert:TEXT_NETWORK_ERROR msg:[json objectForKey:@"errmsg"]];
         } else {
             if ([[json objectForKey:@"rc"] intValue]==0) {
                 NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                 [pref setObject:[json objectForKey:K_USER_OPENID] forKey:K_USER_OPENID];
                 [pref synchronize];
                 NSLog(@"Verify Code: %@",[json description]);
                 [parent RegStage2];
                 [phone setText:@""];
                 [verification setText:@""];
                 [self toggleSubmitButton:NO];
                 [self toggleCheck];
                 [self toggleVerificationButton:NO];
                 [phone setEnabled:YES];
                 [verification setEnabled:YES];
                 [sendVerification setTitle:@"發送認證碼" forState:UIControlStateNormal];
                 
                 [timer invalidate];
                 sec = 60;
                 
                 [errorMessage setText:@""];
             } else if ([[json objectForKey:@"rc"] intValue]==1) {
                 [errorMessage setText:@"驗證碼不正確"];
                 [self toggleSubmitButton:YES];
             } else if ([[json objectForKey:@"rc"] intValue]==2) {
                 [phone setText:@""];
                 [verification setText:@""];
                 [self toggleSubmitButton:NO];
                 [self toggleCheck];
                 [self toggleVerificationButton:NO];
                 [timer invalidate];
                 sec = 60;
                 
                 [errorMessage setText:@""];
                 [delegate raiseAlert:TEXT_NETWORK_ERROR msg:[json objectForKey:@"errmsg"] inViewController:self.navigationController.topViewController];
             }
         }
     }
 }
- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    if (textField==phone) {
        if ([areaCode.titleLabel.text isEqualToString:@"852"]) {
            return newLength <= 8 || returnKey;
        } else if ([areaCode.titleLabel.text isEqualToString:@"853"]) {
            return newLength <= 8 || returnKey;
        } else if ([areaCode.titleLabel.text isEqualToString:@"86"]) {
            return newLength <= 11 || returnKey;
        } else {
            return YES;
        }
    } else if (textField==verification) {        
        return newLength<=6 || returnKey;
    }
    return YES;
}
-(void) checkUsername {
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT] param:
  @{
    @"username":[NSString stringWithFormat:@"%@%@",areaCode.titleLabel.text,phone.text],
    @"action":@"checkuser"
    } interation:0 callback:^(NSDictionary *data) {
        NSLog(@"Check User %@",data);
        if ([[data objectForKey:@"errcode"]intValue] == 0) {
            if ([[data objectForKey:@"userexists"]intValue]==0) {
                [self toggleVerificationButton:YES];
                [self->errorMessage setText:@""];
                self->phoneOK = YES;
            } else {
                [self toggleVerificationButton:NO];
                [self->errorMessage setText:@"電話號碼已被註冊，如果這是你的帳戶，請重設密碼。"];
                self->phoneOK = NO;
            }
        }
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == phone) {
        [phoneLine setBackgroundColor:[UIColor lightGrayColor]];
    } else if (textField==verification) {
        [verificationLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    return TRUE;
}
-(void) toggleVerificationButton:(BOOL)active {
    
    if (active) {
        if (![timer isValid]) {
            [sendVerification setEnabled:YES];
            sendVerification.layer.borderColor = [UICOLOR_GOLD CGColor];
            [sendVerification setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        }
    } else {
        [sendVerification setEnabled:NO];
        sendVerification.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [sendVerification setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}
-(void) toggleSubmitButton:(BOOL)active {
    if (active) {
        [submit setEnabled:YES];
        [submit setBackgroundColor:UICOLOR_GOLD];
    } else {
        [submit setEnabled:NO];
        [submit setBackgroundColor:[UIColor lightGrayColor]];
    }
}
-(void) sendVerification {
    [phone setEnabled:NO];
    [clearPhone setEnabled:NO];
    
    sec = 60;
    [self toggleVerificationButton:NO];
    
    [[KApiManager sharedManager] getResultAsync:
      [NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                                           param:[NSDictionary dictionaryWithObjects:
                                                  @[[NSString stringWithFormat:@"%@%@",areaCode.titleLabel.text,phone.text],@"reguser"] forKeys:@[@"username",@"action"]] interation:0 callback:^(NSDictionary *data) {
                                               if ([[data objectForKey:@"errcode"] intValue]!=0) {
                                                   [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                               } else {
                                                   NSLog(@"Get Verification Code: %@",data);
                                               }
                                           }];
    
    [sendVerification setTitle:@"60s 後可再發送" forState:UIControlStateNormal];
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fireTimer) userInfo:nil repeats:YES];
    
    
    
}
-(void) fireTimer {
    if (--sec <= 0) {
        [timer invalidate];
        [phone setEnabled:YES];
        [clearPhone setEnabled:YES];
        [self toggleVerificationButton:YES];
        [sendVerification setTitle:@"發送認證碼" forState:UIControlStateNormal];
        sec = 0;
        
        return;
    }
    [sendVerification setTitle:[NSString stringWithFormat:@"%ds 後可再發送",sec] forState:UIControlStateNormal];
}
-(void) changeAreaCode:(UIButton *)b {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"請選擇區號"
                                                                   message:nil                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* CN = [UIAlertAction actionWithTitle:@"86" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->areaCode setTitle:@"86" forState:UIControlStateNormal];
        [self->phone setPlaceholder:@"請輸入11個位手機號碼"];
    }];
    [alert addAction:CN];
    
    UIAlertAction* HK = [UIAlertAction actionWithTitle:@"852" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->areaCode setTitle:@"852" forState:UIControlStateNormal];
        if ([self->phone.text length]>8) {
            [self->phone setText:[self->phone.text substringWithRange:NSMakeRange(0,8)]];
        }
        [self->phone setPlaceholder:@"請輸入8個位手機號碼"];
    }];
    [alert addAction:HK];
    
    
    UIAlertAction* MC = [UIAlertAction actionWithTitle:@"853" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->areaCode setTitle:@"853" forState:UIControlStateNormal];
        if ([self->phone.text length]>8) {
            [self->phone setText:[self->phone.text substringWithRange:NSMakeRange(0,8)]];
        }
        [self->phone setPlaceholder:@"請輸入8個位手機號碼"];
    }];
    [alert addAction:MC];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES  completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
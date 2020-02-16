//
//  ResetPassword.m
//  Konnect
//
//  Created by Jacky Mok on 12/2/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "ResetPassword.h"
#import "AppDelegate.h"
@interface ResetPassword ()

@end

@implementation ResetPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    userID = @"";
    int y = 50;
    {
    UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2, 30)];
    [btnLbl setText:TEXT_RESET_PASSWORD];
    [btnLbl setTextColor:UICOLOR_DARK_GREY];
    [btnLbl setFont:[UIFont boldSystemFontOfSize:FONT_M]];
    [self.view addSubview:btnLbl];
    [btnLbl setTextAlignment:NSTextAlignmentCenter];
    
    }
    
      areaCode = [UIButton buttonWithType:UIButtonTypeCustom];
      [areaCode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [areaCode setTitle:@"852" forState:UIControlStateNormal];
      UITextField *arrow = [[UITextField alloc] initWithFrame:CGRectMake(70,0,10,LINE_HEIGHT)];
      [arrow setText:DOWN_ARROW];
      [arrow setFont:[UIFont systemFontOfSize:10]];
      [arrow setTextColor:UICOLOR_LIGHT_GREY];
      [areaCode addSubview:arrow];
      areaCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      [areaCode setFrame:CGRectMake(SIDE_PAD_2,y,80,LINE_HEIGHT)];
      [areaCode addTarget:self action:@selector(changeAreaCode:) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:areaCode];
      
      phoneOK = NO;
      
      phone = [[UITextField alloc] initWithFrame:CGRectMake(120,y,delegate.screenWidth-170-SIDE_PAD,LINE_HEIGHT)];
      [phone setKeyboardType:UIKeyboardTypePhonePad];
      [delegate addPlaceHolder:phone text:TEXT_PLEASE_ENTER_8_DIGIT_PHONE center:YES];
      [phone setTextAlignment:NSTextAlignmentCenter];
      [phone addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
      [delegate addDoneToKeyboard:phone];
      [phone setTextColor:[UIColor darkTextColor]];
      [phone setDelegate:self];
      clearPhone = [UIButton buttonWithType:UIButtonTypeCustom];
      [clearPhone setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [clearPhone setTitle:CLOSE_X forState:UIControlStateNormal];
      [clearPhone setFrame:CGRectMake(delegate.screenWidth-SIDE_PAD_2-20,y,20,LINE_HEIGHT)];
      [clearPhone addTarget:self action:@selector(clearPhone) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:clearPhone];
      [self.view addSubview:phone];
      {
          phoneLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT+10,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
          [phoneLine setBackgroundColor:[UIColor lightGrayColor]];
          [self.view addSubview:phoneLine];
      }      
      verification = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT+40,delegate.screenWidth-180-SIDE_PAD-SIDE_PAD,LINE_HEIGHT)];
      [verification setKeyboardType:UIKeyboardTypeNumberPad];
      verification.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      [verification setSecureTextEntry:YES];
      [verification setTextColor:[UIColor darkTextColor]];
      [delegate addPlaceHolder:verification text:TEXT_PLEASE_ENTER_6_DIGIT_VER center:YES];
      verification.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
      [delegate addDoneToKeyboard:verification];
      [verification setDelegate:self];
      clearVerification = [UIButton buttonWithType:UIButtonTypeCustom];
      [clearVerification setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
      [clearVerification setTitle:CLOSE_X forState:UIControlStateNormal];
      [clearVerification setFrame:CGRectMake(delegate.screenWidth-20-SIDE_PAD_2,y+LINE_HEIGHT+40,20,LINE_HEIGHT)];
      [clearVerification addTarget:self action:@selector(clearVerification) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:clearVerification];
      [self.view addSubview:verification];
      
      sendVerification = [UIButton buttonWithType:UIButtonTypeCustom];
      [sendVerification setTitle:@"發送認證碼" forState:UIControlStateNormal];
      [sendVerification.titleLabel setFont:[UIFont systemFontOfSize:FONT_XS]];
      [sendVerification.layer setCornerRadius:5.0f];
      [self toggleVerificationButton:NO];
      sendVerification.layer.borderWidth= 0.5f;
      [sendVerification setFrame:CGRectMake(delegate.screenWidth-180,y+LINE_HEIGHT+42,105,LINE_HEIGHT-4)];
      [sendVerification addTarget:self action:@selector(sendVerification) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:sendVerification];
      
      {
          verificationLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT+LINE_HEIGHT+50,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
          [verificationLine setBackgroundColor:[UIColor lightGrayColor]];
          [self.view addSubview:verificationLine];
      }
      y +=80+LINE_HEIGHT+LINE_HEIGHT;
    
      /* new PW */
    pw1 = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-140-SIDE_PAD,LINE_HEIGHT)];
    [pw1 setKeyboardType:UIKeyboardTypeDefault];
    [delegate addPlaceHolder:pw1 text:TEXT_NEW_PASSWORD center:YES];
    [pw1 setTextAlignment:NSTextAlignmentCenter];
    [delegate addDoneToKeyboard:pw1];
    [pw1 setTextColor:[UIColor darkTextColor]];
    [pw1 setDelegate:self];
    [pw1 setSecureTextEntry:YES];
    clearPW1 = [UIButton buttonWithType:UIButtonTypeCustom];
    clearPW1.tag = 0;
    [clearPW1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearPW1 setTitle:CLOSE_X forState:UIControlStateNormal];
    [clearPW1 setFrame:CGRectMake(delegate.screenWidth-SIDE_PAD_2-20,y,20,LINE_HEIGHT)];
    [clearPW1 addTarget:self action:@selector(clearPW:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearPW1];
    [self.view addSubview:pw1];
    {
        pw1Line = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT+10,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [pw1Line setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:pw1Line];
    }
      y +=40+LINE_HEIGHT;
      /* new PW2 */
    pw2 = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-140-SIDE_PAD,LINE_HEIGHT)];
    [pw2 setKeyboardType:UIKeyboardTypeDefault];
    [delegate addPlaceHolder:pw2 text:TEXT_CONFIRM_NEW_PASSWORD center:YES];
    [pw2 setTextAlignment:NSTextAlignmentCenter];
    [delegate addDoneToKeyboard:pw2];
    [pw2 setSecureTextEntry:YES];
    [pw2 setTextColor:[UIColor darkTextColor]];
    [pw2 setDelegate:self];
    clearPW2 = [UIButton buttonWithType:UIButtonTypeCustom];
    clearPW2.tag = 1;
    [clearPW2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearPW2 setTitle:CLOSE_X forState:UIControlStateNormal];
    [clearPW2 setFrame:CGRectMake(delegate.screenWidth-SIDE_PAD_2-20,y,20,LINE_HEIGHT)];
    [clearPW2 addTarget:self action:@selector(clearPW:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearPW2];
    [self.view addSubview:pw2];
    {
        pw2Line = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT+10,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [pw2Line setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:pw2Line];
    }

      y+=LINE_HEIGHT+20;
      errorMessage = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT*2)];
      [errorMessage setTextColor:UICOLOR_ERROR];
      [errorMessage setNumberOfLines:-1];
      [errorMessage setTextAlignment:NSTextAlignmentCenter];
      [self.view addSubview:errorMessage];
      y+=LINE_HEIGHT+LINE_HEIGHT;
                                             
      UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
      [submit setImage:[UIImage imageNamed:@"goldbutton.png"] forState:UIControlStateNormal];
      [submit setFrame:CGRectMake(SIDE_PAD_2, y, delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2, 44)];
      [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
      [self toggleSubmitButton:NO];
      
      UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,submit.frame.size.width, submit.frame.size.height)];
      [btnLbl setText:TEXT_RESET_PASSWORD];
      [btnLbl setTextColor:UICOLOR_DARK_GREY];
      [btnLbl setFont:[UIFont boldSystemFontOfSize:FONT_L]];
      [submit addSubview:btnLbl];
      [btnLbl setTextAlignment:NSTextAlignmentCenter];
      [self.view addSubview:submit];
      
      y+= 36+LINE_HEIGHT;
      [self toggleSubmitButton:NO];
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
-(void) submit {
    if ([userID isKindOfClass:[NSString class]] && ([userID isEqualToString:@""] || [verification.text isEqualToString:@""])) {
        [delegate raiseAlert:TEXT_ERROR_MISSING_INFO msg:TEXT_PHONE_VERIFY];
        return;
    }
    if ([pw1.text isEqualToString:@""]) {
        [delegate raiseAlert:TEXT_ERROR_MISSING_INFO msg:TEXT_PLEASE_ENTER_PASSWORD];
        return;
    }
    if (![pw1.text isEqualToString:pw2.text]) {
        [delegate raiseAlert:TEXT_ERROR_MISSING_INFO msg:TEXT_PASSWORD_DONT_MATCH];
        return;
    }    
    [[KApiManager sharedManager] getResultAsync:
    [NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                                         param:[NSDictionary dictionaryWithObjects:
                                                @[userID,verification.text,pw1.text, @"resetpw"] forKeys:@[@"user_id",@"verificationcode",@"newpw",@"action"]] interation:0 callback:^(NSDictionary *data) {
                                             if ([[data objectForKey:@"errcode"] intValue]!=0) {
                                                 [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             } else {
                                                 self->userID = @"";
                                                 [self->phone setText:@""];
                                                 [self->verification setText:@""];
                                                 [self->pw1 setText:@""];
                                                 [self->pw2 setText:@""];
                                                 [self toggleVerificationButton:NO];
                                                 [self toggleSubmitButton:NO];
                                                 [self->delegate raiseAlert:TEXT_SAVE_SUCCESS msg:TEXT_PLEASE_USE_NEWPASSWORD_LOGIN];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
                                                 NSLog(@"Get Verification Code: %@",data);
                                             }
                                         }];
}
-(void) sendVerification {
    [phone setEnabled:NO];
    [clearPhone setEnabled:NO];
    
    sec = 60;
    [self toggleVerificationButton:NO];
    
    [[KApiManager sharedManager] getResultAsync:
      [NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT]
                                           param:[NSDictionary dictionaryWithObjects:
                                                  @[[NSString stringWithFormat:@"%@%@",areaCode.titleLabel.text,phone.text],@"gettokenreset"] forKeys:@[@"username",@"action"]] interation:0 callback:^(NSDictionary *data) {
                                               if ([[data objectForKey:@"errcode"] intValue]!=0) {
                                                   [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                                   [self toggleSubmitButton:NO];
                                               } else {
                                                   self->userID = [[data objectForKey:@"user_id"] stringValue];
                                                   [self toggleSubmitButton:YES];
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
-(void) clearPhone {
    [phone setText:@""];
}
-(void) clearPW:(UIButton *)b {
    if (b.tag==0) {
        [pw1 setText:@""];
    } else {
        [pw2 setText:@""];
    }
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
}\
-(void)textFieldDidChange :(UITextField *) textField{
    //your code
    if ([textField.text isEqualToString:@""]) {
        [self toggleVerificationButton:NO];
    } else {
        if (
            ([areaCode.titleLabel.text isEqualToString:@"86"] && [phone.text length]==11) ||
            ([areaCode.titleLabel.text isEqualToString:@"852"] && [phone.text length]==8) ||
            ([areaCode.titleLabel.text isEqualToString:@"853"] && [phone.text length]==8)
         ) {
            [self toggleVerificationButton:YES];
        } else {
            [self toggleVerificationButton:NO];
        }
    }
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

//
//  RegisterPassword.m
//  Konnect
//
//  Created by Jacky Mok on 12/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "RegisterPassword.h"
#import "LoginOrReg.h"
#import "AppDelegate.h"
#import "KApiManager.h"
@interface RegisterPassword ()

@end

@implementation RegisterPassword
@synthesize parent;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int y = 0 ;
    
    text1 = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
    [text1 setText:@"手機綁定成功！"];
    [text1 setTextAlignment:NSTextAlignmentLeft];
    [text1 setFont:[UIFont boldSystemFontOfSize:FONT_L]];
    [text1 setTextColor:UICOLOR_GOLD];
    [self.view addSubview:text1];
    y+=LINE_HEIGHT;
    
    text2 = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
    [text2 setText:@"請選擇以下任一種登錄方式"];
    [text2 setTextAlignment:NSTextAlignmentLeft];
    [text2 setFont:[UIFont boldSystemFontOfSize:FONT_M]];
    [text2 setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:text2];
    y+=LINE_HEIGHT;
    {
        UILabel *subtext = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT*2)];
        [subtext setText:@"1. 設置您的密碼完成註冊並登錄\n2. 直接使用微訊免密碼登錄"];
        [subtext setNumberOfLines:-1];
        [subtext setTextAlignment:NSTextAlignmentLeft];
        [subtext setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [subtext setTextColor:[UIColor darkGrayColor]];
        [self.view addSubview:subtext];
        y+=LINE_HEIGHT*2+LINE_PAD;
    }
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,LINE_HEIGHT)];
    [password setKeyboardType:UIKeyboardTypeDefault];
    [password setTextAlignment:NSTextAlignmentLeft];
    [password setPlaceholder:@"請輸入最少6個字密碼"];
    [password setSecureTextEntry:YES];
    password.delegate = self;
    [delegate addDoneToKeyboard:password];
    [password setDelegate:self];
    
    
    [self.view addSubview:password];
    {
        passwordLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [passwordLine setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:passwordLine];
    }
    
    y+=LINE_HEIGHT+LINE_PAD;
    
    password2 = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,LINE_HEIGHT)];
    [password2 setKeyboardType:UIKeyboardTypeDefault];
    [password2 setSecureTextEntry:YES];
    password2.delegate = self;
    [password2 setTextAlignment:NSTextAlignmentLeft];
    [password2 setPlaceholder:@"請再輸入密碼"];
    [delegate addDoneToKeyboard:password2];
    [password2 setDelegate:self];
    [self.view addSubview:password2];
    
    {
        password2Line = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [password2Line setBackgroundColor:[UIColor lightGrayColor]];
        [self.view addSubview:password2Line];
    }
    y +=LINE_HEIGHT+LINE_PAD;

    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setImage:[UIImage imageNamed:@"goldbutton.png"] forState:UIControlStateNormal];
    [submit setFrame:CGRectMake(SIDE_PAD_2, y, delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2, 44)];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self toggleSubmitButton:NO];
    
    UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,submit.frame.size.width, submit.frame.size.height)];
    [btnLbl setText:@"完成註冊並登錄"];
    [btnLbl setTextColor:UICOLOR_DARK_GREY];
    [btnLbl setFont:[UIFont boldSystemFontOfSize:FONT_L]];
    [submit addSubview:btnLbl];
    [btnLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:submit];
    
    y+=44+LINE_PAD;
    
    UIButton *wxLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxLogin.layer setBorderColor:[UICOLOR_GOLD CGColor]];
    wxLogin.layer.borderWidth = 1.0f;
    [wxLogin setFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,44)];
    [wxLogin setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [wxLogin setTitle:@"綁定微信免密碼登錄" forState:UIControlStateNormal];
    [wxLogin setContentEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
    [wxLogin addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wxLogin];
    
    UIImageView *wxicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginWechat.png"]];
    [wxicon setFrame:CGRectMake(50,8,28,28)];
    [wxLogin addSubview:wxicon];
    
    y+=LINE_HEIGHT  +LINE_PAD;
    errorMessage = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT*2)];
    [errorMessage setTextColor:UICOLOR_ERROR];
    [errorMessage setNumberOfLines:-1];
    [errorMessage setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:errorMessage];
    
    y+=LINE_HEIGHT+LINE_PAD;
    

}
-(void) wxLogin {    
    [delegate getWXAuthCode:YES];
}
-(void) WXRegistrationSuccess {
    [delegate raiseAlert:@"你已成功綁定微訊！" msg:@""];    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == password) {
        [passwordLine setBackgroundColor:UICOLOR_GOLD];
        [password2Line setBackgroundColor:[UIColor lightGrayColor]];
    } else if (textField==password2Line) {
        [password2Line setBackgroundColor:UICOLOR_GOLD];
        [passwordLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    return YES;
}
-(void) submit {
    [delegate startLoading];
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:K_USER_OPENID];
    if ([password.text length]>=6 && [password2.text isEqualToString:password.text]) {
        NSDictionary *data = [[KApiManager sharedManager] setPassword:userToken password:password.text];
        if ([[data objectForKey:@"rc"] intValue]==0) {
            dispatch_async(dispatch_get_main_queue(),^{
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                [self->delegate makeToast:@"註冊成功！歡迎你成為Konnect+會員。" duration:5 inView:delegate.window.rootViewController.view];
            });
            [password setText:@""];
            [password2 setText:@""];
            [self toggleSubmitButton:NO];
        } else {
            [delegate raiseAlert:@"登入過時" msg:@"請重新註冊"];
            [parent RegStage1];
        }
        
    } else {
        [delegate raiseAlert:@"輸入資料錯誤" msg:@"請重新輸入"];
    }
    [delegate stopLoading];
    
}
-(void) textFieldDidEndEditing:(UITextField *)textField {
    if (textField == password) {
        [passwordLine setBackgroundColor:[UIColor lightGrayColor]];
        if ([password.text length]<6) {
            [errorMessage setText:@"請輸入最少6個字密碼"];
            [self toggleSubmitButton:NO];
        }
    } else if (textField==password2) {
        [password2Line setBackgroundColor:[UIColor lightGrayColor]];
        if (![password2.text isEqualToString:password.text]) {
            [errorMessage setText:@"兩個密碼不相同"];
            [self toggleSubmitButton:NO];
        }
    }
    if ([password.text length]>=6 && [password2.text isEqualToString:password.text]) {
        [self toggleSubmitButton:YES];
        [errorMessage setText:@""];
    }
}
-(void) donePressed {
    [self setEditing:NO];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

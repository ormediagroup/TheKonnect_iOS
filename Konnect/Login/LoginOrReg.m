//
//  LoginViewController.m
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "LoginOrReg.h"
#import "Introduction.h"
#import "WXApiManager.h"
#import "AppDelegate.h"
#import "const.h"
#import "RegisterViewController.h"
#import "RegisterPassword.h"
@interface LoginOrReg ()

@end

@implementation LoginOrReg
@synthesize parent;

- (void)viewDidLoad {
    [super viewDidLoad];    

    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(SIDE_PAD,SIDE_PAD,36,36)];
    [back setImage:[UIImage imageNamed:@"backbtn.png"] forState:UIControlStateNormal];
    [back addTarget:self
            action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:back];
    
    regFlow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"regflow1.png"]];
    [regFlow setFrame:CGRectMake(delegate.screenWidth/2-50,SIDE_PAD+13,100,10)];
    [regFlow setContentMode:UIViewContentModeScaleAspectFit];
    [scroll addSubview:regFlow];
    [self changeRegFlowState:0];
    
    
    topLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD+26,100+LINE_HEIGHT,20,2)];
    [topLine setBackgroundColor:UICOLOR_GOLD];
    [scroll addSubview:topLine];
    {
        login = [UIButton buttonWithType:UIButtonTypeCustom];
        [login setTitle:@"登錄" forState:UIControlStateNormal];
        login.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [login setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [login.titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        login.tag = SIDE_PAD+26;
        [login setFrame:CGRectMake(SIDE_PAD_2,100,100,LINE_HEIGHT)];
        [login addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:login];
    }
    {
        
        reg = [UIButton buttonWithType:UIButtonTypeCustom];
        [reg setTitle:@"註冊" forState:UIControlStateNormal];
        [reg.titleLabel setTextAlignment:NSTextAlignmentLeft];
        reg.tag = SIDE_PAD+88;
        reg.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [reg setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [reg.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [reg setFrame:CGRectMake(60+SIDE_PAD_2,100,100,LINE_HEIGHT)];
        [reg addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:reg];
    }
    loginView = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [self setupLogin];
    regPass = [[RegisterPassword alloc] initWithNibName:nil bundle:nil];
    regPass.parent = self;
    regView = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    regView.parent = self;    
    nav = [[UINavigationController alloc] initWithRootViewController:loginView];
    [nav.view setFrame:CGRectMake(0,200,delegate.screenWidth,delegate.screenHeight-200)];
    [nav setNavigationBarHidden:YES];
    [nav setToolbarHidden:YES];
    [scroll addSubview:nav.view];
    [self.view addSubview:scroll];
}
-(void) viewWillAppear:(BOOL)animated {
    [scroll scrollRectToVisible:CGRectMake(0,0,100,100) animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) backPressed {
    if ([[nav viewControllers] count] >1) {
        [nav popViewControllerAnimated:YES];
    } else {
        [parent backToIntro];
    }
}
-(void) setupLogin {
    int y = 0;
    
    
    areaCode = [UIButton buttonWithType:UIButtonTypeCustom];
    [areaCode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [areaCode setTitle:@"852" forState:UIControlStateNormal];
    areaCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UITextField *arrow = [[UITextField alloc] initWithFrame:CGRectMake(70,0,10,LINE_HEIGHT)];
    [arrow setText:DOWN_ARROW];
    [arrow setFont:[UIFont systemFontOfSize:10]];
    [areaCode addSubview:arrow];
    [areaCode setFrame:CGRectMake(SIDE_PAD_2,y,80,LINE_HEIGHT)];
    [areaCode addTarget:self action:@selector(changeAreaCode:) forControlEvents:UIControlEventTouchUpInside];
    [loginView.view addSubview:areaCode];
    
    
    phone = [[UITextField alloc] initWithFrame:CGRectMake(140,y,delegate.screenWidth-140-SIDE_PAD_2,LINE_HEIGHT)];
    [phone setKeyboardType:UIKeyboardTypePhonePad];
    [phone setPlaceholder:@"手機號碼"];
    [delegate addDoneToKeyboard:phone];
    [phone setDelegate:self];
    clearPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearPhone setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearPhone setTitle:CLOSE_X forState:UIControlStateNormal];
    [clearPhone setFrame:CGRectMake(delegate.screenWidth-SIDE_PAD_2-20,y,20,LINE_HEIGHT)];
    [clearPhone addTarget:self action:@selector(clearPhone) forControlEvents:UIControlEventTouchUpInside];
    [loginView.view addSubview:clearPhone];
    
    [loginView.view addSubview:phone];
    
    {
        phoneLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT+10,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [phoneLine setBackgroundColor:[UIColor lightGrayColor]];
        [loginView.view addSubview:phoneLine];
    }
    
    y+= LINE_HEIGHT+40;
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-40-SIDE_PAD_2,LINE_HEIGHT)];
    [password setKeyboardType:UIKeyboardTypeDefault];
    [password setSecureTextEntry:YES];
    [password setPlaceholder:@"密碼"];
    [delegate addDoneToKeyboard:password];
    [password setDelegate:self];
    clearPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearPassword setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [clearPassword setTitle:CLOSE_X forState:UIControlStateNormal];
    [clearPassword setFrame:CGRectMake(delegate.screenWidth-SIDE_PAD_2-20,y,20,LINE_HEIGHT)];
    [clearPassword addTarget:self action:@selector(clearPassword) forControlEvents:UIControlEventTouchUpInside];
    [loginView.view addSubview:clearPassword];
    
    [loginView.view addSubview:password];
    {
        passwordLine = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y+LINE_HEIGHT+10,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,1)];
        [passwordLine setBackgroundColor:[UIColor lightGrayColor]];
        [loginView.view addSubview:passwordLine];
    }
    
    y+= LINE_HEIGHT+60;
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setImage:[UIImage imageNamed:@"goldbutton.png"] forState:UIControlStateNormal];
    [submit setFrame:CGRectMake(SIDE_PAD_2, y, delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2, 44)];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,submit.frame.size.width, submit.frame.size.height)];
    [btnLbl setText:TEXT_LOGIN];
    [btnLbl setTextColor:UICOLOR_DARK_GREY];
    [btnLbl setFont:[UIFont boldSystemFontOfSize:FONT_L]];
    [submit addSubview:btnLbl];
    [btnLbl setTextAlignment:NSTextAlignmentCenter];
    [loginView.view addSubview:submit];
    
    y+= 36+LINE_HEIGHT;
    
    
    UIButton *wxLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxLogin.layer setBorderColor:[UICOLOR_GOLD CGColor]];
    wxLogin.layer.borderWidth = 1.0f;
    [wxLogin setFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,44)];
    [wxLogin setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [wxLogin setTitle:@"使用微信登錄" forState:UIControlStateNormal];
    [wxLogin setContentEdgeInsets:UIEdgeInsetsMake(0,40,0,0)];
    [wxLogin addTarget:self action:@selector(wxLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginView.view addSubview:wxLogin];
    
    UIImageView *wxicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginWechat.png"]];
    [wxicon setFrame:CGRectMake(80,8,28,28)];
    [wxLogin addSubview:wxicon];
    
    y+=36+LINE_HEIGHT;
    
    {
        UIButton *fop = [UIButton buttonWithType:UIButtonTypeCustom];
        [fop setFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-100,LINE_HEIGHT)];
        fop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [fop setTitle:TEXT_FORGOT_PASSWORD forState:UIControlStateNormal];
        [fop setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [fop.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [fop addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
        [loginView.view addSubview:fop];
        
        UIButton *tou = [UIButton buttonWithType:UIButtonTypeCustom];
        [tou setFrame:CGRectMake(delegate.screenWidth-SIDE_PAD_2-100,y,100,LINE_HEIGHT)];
        tou.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [tou setTitle:TEXT_TOU forState:UIControlStateNormal];
        [tou setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [tou.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [tou addTarget:self action:@selector(gotou) forControlEvents:UIControlEventTouchUpInside];
        [loginView.view addSubview:tou];
    }
    y+=LINE_HEIGHT;
    errMsg = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,LINE_HEIGHT*2)];
    [errMsg setTextColor:UICOLOR_ERROR];
    [errMsg setNumberOfLines:-1];
    [errMsg setTextAlignment:NSTextAlignmentCenter];
    [errMsg setText:@""];
    [loginView.view addSubview:errMsg];
    
    y+= LINE_HEIGHT+LINE_HEIGHT+40;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLoginSuccess) name:WX_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxRegister) name:WX_REGISTER object:nil];
  //  if ([WXApi isWXAppInstalled]) {
    
  //  }
}
-(void) wxLoginSuccess {
   
}

-(void) wxLogin {
    /*
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = @"分享的内容";
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
     */

    [delegate getWXAuthCode:NO];
     
}
-(void) gotou {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_TOU],[NSString stringWithFormat:@"%@/privacy-policy-zh/",domain]] forKeys:@[@"type",@"url"]]];
}
-(void) submit {
    if ([areaCode.titleLabel.text isEqualToString:@"852"] || [areaCode.titleLabel.text isEqualToString:@"853"]) {
        if (phone.text.length!=8) {
            [errMsg setText:@"用戶名稱錯誤"];
            return;
        }
    } else if ([areaCode.titleLabel.text isEqualToString:@"86"]) {
        if (phone.text.length!=11) {
            [errMsg setText:@"用戶名稱錯誤"];
            return;
        }
    } else if ([password.text length]<6) {
        [errMsg setText:@"密碼錯誤"];
        return;
    }
    [errMsg setText:@""];
    dispatch_queue_t createQueue = dispatch_queue_create("SerialQueue", nil);
    NSString *p = [NSString stringWithFormat:@"%@%@",areaCode.titleLabel.text,phone.text];
    NSString *pw = password.text;
    [self->delegate startLoading];
    dispatch_async(createQueue, ^(){
        NSDictionary *data = [[KApiManager sharedManager] logWithPassword:p withPassord:pw];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self->delegate stopLoading];
            if ([[data objectForKey:@"rc"] intValue]==0) {

                [self->delegate.preferences setObject:[data objectForKey:K_USER_OPENID] forKey:K_USER_OPENID];
                [self->delegate.preferences setObject:[data objectForKey:K_USER_PHONE] forKey:K_USER_PHONE];
                [self->delegate.preferences setObject:[data objectForKey:K_USER_NAME] forKey:K_USER_NAME];
                [self->delegate.preferences setObject:[data objectForKey:K_USER_GENDER] forKey:K_USER_GENDER];
                [self->delegate.preferences setObject:[data objectForKey:K_USER_EMAIL] forKey:K_USER_EMAIL];
                [self->delegate.preferences synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                [self->password setText:@""];
                [self->delegate makeToast:@"登入成功" duration:5 inView:self->delegate.window.rootViewController.view];
            } else {
                [self->errMsg setText:[data objectForKey:@"errmsg"]];
            }
            
        });
    });
}
-(void) forgotPassword {
}
-(void)wxRegister {
    regView.regType = REG_TYPE_WECHAT;
    regView.showWXMessage = YES;
    NSLog(@"Going into WX Register");
    [self RegStage1];
}
-(void) clearPhone {
   [phone setText:@""];
}
-(void) clearPassword {
    [password setText:@""];
}
-(void) RegStage2 {
    if ([nav.viewControllers containsObject:regPass]) {
        [nav popToViewController:regPass animated:YES];
    } else {
        [nav pushViewController:regPass animated:YES];
    }
}
- (void) RegStage1 {
    if ([nav.viewControllers containsObject:regView]) {
        [nav popToViewController:regView animated:YES];
    } else {
        [nav pushViewController:regView animated:YES];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    activeField = textField;
    if (textField == phone) {
        [phoneLine setBackgroundColor:UICOLOR_GOLD];
        [passwordLine setBackgroundColor:[UIColor lightGrayColor]];
    } else if (textField==password) {
        [passwordLine setBackgroundColor:UICOLOR_GOLD];
        [phoneLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    activeField = nil;
    if (textField == phone) {
        [phoneLine setBackgroundColor:[UIColor lightGrayColor]];
    } else if (textField==password) {
        [passwordLine setBackgroundColor:[UIColor lightGrayColor]];
    }
    return TRUE;
}

-(void) changeAreaCode:(UIButton *)b {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"請選擇區號"
                                                                   message:nil                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* CN = [UIAlertAction actionWithTitle:@"86" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->areaCode setTitle:@"86" forState:UIControlStateNormal];
    }];
    [alert addAction:CN];
    
    UIAlertAction* HK = [UIAlertAction actionWithTitle:@"852" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->areaCode setTitle:@"852" forState:UIControlStateNormal];
    }];
    [alert addAction:HK];
   
    
    UIAlertAction* MC = [UIAlertAction actionWithTitle:@"853" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->areaCode setTitle:@"853" forState:UIControlStateNormal];
    }];
    [alert addAction:MC];
  
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES  completion:nil];
}
-(void) goLogin:(UIButton *)b {
    if (b==login) {
        [login setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [login.titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [[login viewWithTag:99] setHidden:NO];
        
        [reg setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [reg.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [[reg viewWithTag:99] setHidden:YES];
        [nav popToRootViewControllerAnimated:YES];
        [self changeRegFlowState:0];
    } else {
        [reg setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [reg.titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [[reg viewWithTag:99] setHidden:NO];
        
        [login setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [login.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [[login viewWithTag:99] setHidden:YES];
        regView.regType = REG_TYPE_PHONE;
        regView.showWXMessage = NO;
        if ([nav.viewControllers containsObject:regView]) {
            [nav popToViewController:regView animated:YES];
        } else {
            [nav pushViewController:regView animated:YES];
        }
        [self changeRegFlowState:1];
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect f = self->topLine.frame;
        f.origin.x = b.tag;
        [self->topLine setFrame:f];
        
    }];
}
-(void) changeRegFlowState:(int)state {
    if (state==0) {
        [regFlow setHidden:YES];
    } else {
        [regFlow setHidden:NO];
        if (state==1) {
            [regFlow setImage:[UIImage imageNamed:@"regflow1.png"]];
        } else if (state==2) {
            [regFlow setImage:[UIImage imageNamed:@"regflow2.png"]];
        } else if (state==3) {
            [regFlow setImage:[UIImage imageNamed:@"regflow3.png"]];
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

#pragma mark - WXApiManagerDelegate
/*
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];

}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //显示微信传过来的内容
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    NSString *strMsg = nil;
    
    if ([msg.mediaObject isKindOfClass:[WXAppExtendObject class]]) {
        WXAppExtendObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n附带信息：%@ \n文件大小:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)obj.fileData.length, msg.messageExt];
    }
    else if ([msg.mediaObject isKindOfClass:[WXTextObject class]]) {
        WXTextObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n内容：%@\n", req.openID, msg.title, msg.description, obj.contentText];
    }
    else if ([msg.mediaObject isKindOfClass:[WXImageObject class]]) {
        WXImageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n图片大小:%lu bytes\n", req.openID, msg.title, msg.description, (unsigned long)obj.imageData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXLocationObject class]]) {
        WXLocationObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n经纬度：lng:%f_lat:%f\n", req.openID, msg.title, msg.description, obj.lng, obj.lat];
    }
    else if ([msg.mediaObject isKindOfClass:[WXFileObject class]]) {
        WXFileObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n文件类型：%@ 文件大小:%lu\n", req.openID, msg.title, msg.description, obj.fileExtension, (unsigned long)obj.fileData.length];
    }
    else if ([msg.mediaObject isKindOfClass:[WXWebpageObject class]]) {
        WXWebpageObject *obj = msg.mediaObject;
        strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n描述：%@ \n网页地址：%@\n", req.openID, msg.title, msg.description, obj.webpageUrl];
    }
    //  [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //从微信启动App
    NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", req.openID, msg.messageExt];
    //  [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    //   [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"code:%@ cardid:%@ cardext:%@ cardstate:%u\n",cardItem.encryptCode,cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
    }
    //  [UIAlertView showWithTitle:@"add card resp" message:cardStr sure:nil];
}

- (void)managerDidRecvChooseCardResponse:(WXChooseCardResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@, encryptCode:%@, appId:%@\n",cardItem.cardId,cardItem.encryptCode,cardItem.appID]];
    }
    //  [UIAlertView showWithTitle:@"choose card resp" message:cardStr sure:nil];
}

- (void)managerDidRecvChooseInvoiceResponse:(WXChooseInvoiceResp *)response {
    NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXInvoiceItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@, encryptCode:%@, appId:%@\n",cardItem.cardId,cardItem.encryptCode,cardItem.appID]];
    }
    //  [UIAlertView showWithTitle:@"choose invoice resp" message:cardStr sure:nil];
}



- (void)managerDidRecvSubscribeMsgResponse:(WXSubscribeMsgResp *)response
{
    NSString *title = [NSString stringWithFormat:@"templateId:%@,scene:%@,action:%@,reserved:%@,openId:%@",response.templateId,[NSNumber numberWithInteger:response.scene],response.action,response.reserved,response.openId];
    //  [UIAlertView showWithTitle:title message:nil sure:nil];
}

- (void)managerDidRecvLaunchMiniProgram:(WXLaunchMiniProgramResp *)response
{
    NSString *strTitle = [NSString stringWithFormat:@"LaunchMiniProgram结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errMsg:%@,errcode:%d", response.extMsg, response.errCode];
    //  [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvInvoiceAuthInsertResponse:(WXInvoiceAuthInsertResp *)response
{
    NSString *strTitle = [NSString stringWithFormat:@"电子发票授权开票"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d,wxorderid:%@", response.errCode, response.wxOrderId];
    // [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvNonTaxpayResponse:(WXNontaxPayResp *)response
{
    NSString *strTitle = [NSString stringWithFormat:@"非税支付结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d,wxorderid:%@", response.errCode, response.wxOrderId];
    //  [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvPayInsuranceResponse:(WXPayInsuranceResp *)response
{
    NSString *strTitle = [NSString stringWithFormat:@"医保支付结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d, wxorderid:%@", response.errCode, response.wxOrderId];
    //   [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvOfflineResp:(WXOfflinePayResp *)response
{
    NSString *strTitle = [NSString stringWithFormat:@"离线支付结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d,errMsg:%@", response.errCode,response.errStr];
    //  [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}

- (void)managerDidRecvPay:(PayResp *)resp
{
    NSString *strTitle = [NSString stringWithFormat:@"支付成功 wehcatPay结果"];
    if (resp.errCode == WXSuccess)
    {
        NSString *strMsg = [NSString stringWithFormat:@"returnKey:%@,errcode:%d", resp.returnKey, resp.errCode];
        //    [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
    }
    else
    {
        //     [UIAlertView showWithTitle:@"支付失败" message:nil sure:nil];
    }
}

- (void)managerDidRecvSubscribeMiniProgramMsg:(WXSubscribeMiniProgramMsgResp *)response
{
    NSString *strTitle = [NSString stringWithFormat:@"订阅小程序消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d openid:%@ nickName:%@", response.errCode,response.openId, response.nickName];
    //  [UIAlertView showWithTitle:strTitle message:strMsg sure:nil];
}
 */
@end

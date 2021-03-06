//
//  Home.m
//  Konnect
//
//  Created by Jacky Mok on 25/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Home.h"
#import "AppDelegate.h"
#import "const.h"
#import "ORCarousel.h"
#define CAROUSEL_H 140
@interface Home ()

@end

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:scroll];
    bg = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,140)];
    [bg setBackgroundColor:[delegate getThemeColor]];
    [scroll addSubview:bg];
    
    int y = 0;
    submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setImage:[UIImage imageNamed:@"goldbutton.png"] forState:UIControlStateNormal];
    [submit setFrame:CGRectMake(SIDE_PAD, y, delegate.screenWidth-SIDE_PAD_2, 34)];
    [submit addTarget:self action:@selector(goAccount) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:submit];
    
    nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(10,0,submit.frame.size.width, submit.frame.size.height)];
   
    
    [nameLbl setTextColor:UICOLOR_DARK_GREY];
    [nameLbl setFont:[UIFont systemFontOfSize:FONT_M]];
    [submit addSubview:nameLbl];
    [nameLbl setTextAlignment:NSTextAlignmentCenter];
    [nameLbl sizeToFit];
    [nameLbl setFrame:CGRectMake(10,0,nameLbl.frame.size.width,submit.frame.size.height)];
    
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(submit.frame.size.width-30,0,20,submit.frame.size.height)];
    [rightArrow setImage:[UIImage imageNamed:@"rightarrow.png"]];
    [rightArrow setContentMode:UIViewContentModeScaleAspectFit];
    [submit addSubview:rightArrow];
    
    memberTier = [[UIImageView alloc] initWithFrame:CGRectMake(30+nameLbl.frame.size.width,0,80,34)];
    [memberTier setContentMode:UIViewContentModeScaleAspectFit];
   
    [submit addSubview:memberTier];
    
    y+=submit.frame.size.height+LINE_PAD;
    /*
    carousel = [[ORCarousel alloc] initWithNibName:nil bundle:nil];
    [carousel.view setFrame:CGRectMake(SIDE_PAD, y, delegate.screenWidth-SIDE_PAD_2, 200)];
     */
    carousel = [[ORCarousel alloc] initWithNibName:nil bundle:nil withFrame:CGRectMake(SIDE_PAD, y, delegate.screenWidth-SIDE_PAD_2, CAROUSEL_H)];
    [scroll addSubview:carousel.view];
    
    y+=CAROUSEL_H+LINE_PAD;
    UIView *btns = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,80)];
    [scroll addSubview:btns];
    [btns addSubview:[self makeBtn:0 withImageSrc:@"restauranticon.png" andText:TEXT_FNB]];
    [btns addSubview:[self makeBtn:1 withImageSrc:@"officeicon.png" andText:TEXT_SERVICE_OFFICE]];
    [btns addSubview:[self makeBtn:2 withImageSrc:@"conferenceicon.png" andText:TEXT_ACTIVITY]];
    
    y += (delegate.screenWidth-SIDE_PAD_2)/3 + LINE_PAD;
    ad = [[UIImageView alloc] initWithFrame:CGRectMake
                       (0,y,delegate.screenWidth,50)];
    [ad setContentMode:UIViewContentModeScaleAspectFill];
    [scroll addSubview:ad];
    y+=50+LINE_PAD+LINE_PAD;
    bottom = [[UIView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth,100)];
    [scroll addSubview:bottom];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:[[NSDictionary alloc] initWithObjects:@[@"ios"] forKeys:@[@"platform"]] interation:0 callback:^(NSDictionary *data) {
        if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            if ([[data objectForKey:@"forceupdateversion"] floatValue] >= [version floatValue]) {
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_UPDATE_AVAIL
                                                                               message:TEXT_PROCEED_TO_UPDATE
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_UPDATE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSString *iTunesLink = @"itms-apps://itunes.apple.com/app/apple-store/id1479001446?mt=8";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink] options:@{} completionHandler:^(BOOL success) {}];
                }];
                [alert addAction:defaultAction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
                });
                
            } else if ([[data objectForKey:@"updateversion"] floatValue] >= [version floatValue]) {
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_UPDATE_AVAIL
                                                                               message:TEXT_PROCEED_TO_UPDATE
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_UPDATE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    NSString *iTunesLink = @"itms-apps://itunes.apple.com/app/apple-store/id1479001446?mt=8";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink] options:@{} completionHandler:^(BOOL success) {}];
                }];
                [alert addAction:defaultAction];
                [alert addAction:[UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
                });
                
            }
            if ([[data objectForKey:@"top"] isKindOfClass:[NSArray class]]) {
                [self->carousel pack:[data objectForKey:@"top"]];
                [self->ad setImage:[self->delegate getImage:[[[[data objectForKey:@"ad"] objectAtIndex:0] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
                    [self->ad setImage:image];
                }]];
                [self addBottomPart:[data objectForKey:@"bottom"]];
            }
        } else {
            [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:@""];
        }
    }];
}
    
-(void) pressed:(UIButton *)b {
    if (b.tag==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_FACILITIES],[NSNumber numberWithInt:b.tag]] forKeys:@[@"type",@"facilityid"]]];
    } else if (b.tag==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SERVICE_OFFICE]] forKeys:@[@"type"]]];
    } else if (b.tag==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT]] forKeys:@[@"type"]]];
    }
}
-(UIButton *) makeBtn:(int) tag withImageSrc:(NSString *)imageSrc andText:(NSString *)lbl {
 
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    b1.tag = tag;
    CGFloat w = (delegate.screenWidth-SIDE_PAD_2)/3;
    CGFloat f = tag*w;
    [b1 addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    [b1 setFrame:CGRectMake(f,0,w, w)];
    [scroll addSubview:b1];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15,0,b1.frame.size.width-30, b1.frame.size.height-30)];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setImage:[UIImage imageNamed:imageSrc]];
    [b1 addSubview:icon];
    
    
    
    UILabel *btnText = [[UILabel alloc] initWithFrame:CGRectMake(0,b1.frame.size.height-40,b1.frame.size.width,30)];
    [btnText setText:lbl];
    [btnText setTextAlignment:NSTextAlignmentCenter];
    [btnText setFont:[UIFont boldSystemFontOfSize:FONT_S]];
    [btnText setTextColor:[UIColor lightGrayColor]];
    [b1 addSubview:btnText];

    return b1;
    
}
-(void) goAccount {
    if ([delegate isLoggedIn]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MY_WALLET]] forKeys:@[@"type"]]];
    }
}
-(void) addBottomPart:(NSArray *)data {
    CGFloat x = SIDE_PAD;
    CGFloat y = 0;
    //CGFloat width = (delegate.screenWidth-SIDE_PAD_2-SIDE_PAD)/2;
    CGFloat width = (delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2)/3;
    CGFloat height = width / 315 * 360;
    int k = 0;
    for (NSDictionary *d in data) {
        UIImageView *v =[[UIImageView alloc] initWithFrame:CGRectMake(x,y,width,height)];
        [v setUserInteractionEnabled:YES];
        v.tag = k;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adpressed:)];
        [v addGestureRecognizer:tap];
        [v setImage:[delegate getImage:[[d objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [v setImage:image];
        }]];
        [v setContentMode:UIViewContentModeScaleAspectFit];
        [v setClipsToBounds:YES];
        x+= SIDE_PAD + width;
        if ((x+width) > delegate.screenWidth) {
            x = SIDE_PAD;
            y+=height+LINE_PAD;
        }
        [bottom addSubview:v];
        
        k++;
    }
    [bottom setFrame:CGRectMake(0,bottom.frame.origin.y, bottom.frame.size.width,y+60)];
    [scroll setContentSize:CGSizeMake(delegate.screenWidth,(bottom.frame.origin.y+y+60))];
                                      
}
-(void) adpressed:(UITapGestureRecognizer *)tap  {
    if (tap.view.tag==0) {
        if ([delegate checkLogin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_RESERVE_NOW]] forKeys:@[@"type"]]];
        }
    } else if (tap.view.tag==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_KONNECT_NEWS]] forKeys:@[@"type"]]];
    } else if (tap.view.tag==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_ABOUT_KONNECT]] forKeys:@[@"type"]]];
    } else if (tap.view.tag==3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_CONCIERGE]] forKeys:@[@"type"]]];
    }
}
-(void) viewWillAppear:(BOOL)animated {
    /*
    NSLog(@"HOME: %@",delegate.preferences);
    NSLog(@"Home getting union ID: %@",[[NSUserDefaults standardUserDefaults] objectForKey:WX_USER_UNION_ID]);
    NSLog(@"Home getting user Token: %@",[[NSUserDefaults standardUserDefaults] objectForKey:K_USER_OPENID]);
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_BACK_BTN object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@""];
    [bg setBackgroundColor:[delegate getThemeColor]];
    UIView *con = [bottom viewWithTag:3];
    [con setHidden:NO];
    if ([delegate isLoggedIn]) {
        if ([[delegate.preferences objectForKey:K_USER_NAME] isKindOfClass:[NSString class]]) {
            [nameLbl setText:[delegate.preferences objectForKey:K_USER_NAME]];
        } else if ([[delegate.preferences objectForKey:K_USER_PHONE] isKindOfClass:[NSString class]]){
            [nameLbl setText:[delegate.preferences objectForKey:K_USER_PHONE]];
        }
        [nameLbl sizeToFit];
        [nameLbl setFrame:CGRectMake(10,0,nameLbl.frame.size.width,34)];
        [memberTier setFrame:CGRectMake(30+nameLbl.frame.size.width,0,150,34)];
        
        if ([[delegate.preferences objectForKey:K_USER_TIER] isKindOfClass:[NSString class]] && [[delegate.preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_LEGACY]) {
            [memberTier setImage:[UIImage imageNamed:@"membertierlegacy.png"]];
        } else if ([[delegate.preferences objectForKey:K_USER_TIER] isKindOfClass:[NSString class]] && [[delegate.preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_VIP]) {
            [memberTier setImage:[UIImage imageNamed:@"membertiervip.png"]];
        } else {
            [con setHidden:YES];
            [memberTier setImage:[UIImage imageNamed:@"membertiermember.png"]];
        }
        [submit addSubview:memberTier];
    } else {
        [con setHidden:YES];
        [nameLbl setText:TEXT_VISITOR];
        [nameLbl sizeToFit];
        [nameLbl setFrame:CGRectMake(10,0,nameLbl.frame.size.width,34)];
        [memberTier removeFromSuperview];
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

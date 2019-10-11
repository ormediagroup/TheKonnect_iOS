//
//  ViewController.m
//  Konnect
//
//  Created by Jacky Mok on 3/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Introduction.h"
#import "Home.h"
#import "Header.h"
#import "Footer.h"
#import "MessageList.h"
#import "MessageDetails.h"
#import "ScanQR.h"
#import "My.h"
#import "EditInfo.h"
#import "Wallet.h"
#import "PointsHistory.h"
#import "TopUp.h"
#import "ChargeQR.h"
#import "PaymentCode.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    lc = [[Introduction alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:lc animated:NO];    ;
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHome) name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goLogout) name:LOGOUT_SUCCESS object:nil];
    
    header = [[Header alloc] initWithNibName:nil bundle:nil];
    header.parent = self;
    [header.view setFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight)];
    
    footer = [[Footer alloc] initWithNibName:nil bundle:nil];
    footer.parent = self;
    [footer.view setFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight,delegate.screenWidth,delegate.footerHeight)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goSlide:) name:GO_SLIDE object:nil];
    
    #if DEBUG
        #if TARGET_IPHONE_SIMULATOR
            [delegate.preferences setObject:@"oyhE7w3wBH5m7PdUF7RrwsN9bGgk" forKey:WX_USER_UNION_ID];
            [delegate.preferences synchronize];
        #else
        #endif
    
    #endif
    if ([[delegate.preferences objectForKey:WX_USER_UNION_ID] isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:WX_USER_UNION_ID] isEqualToString:@""]) {
        [delegate startLoading];
        dispatch_queue_t createQueue = dispatch_queue_create("SerialQueue", nil);
        dispatch_async(createQueue, ^(){
            NSDictionary *data = [[KApiManager sharedManager] logWithWeChat:[self->delegate.preferences objectForKey:WX_USER_UNION_ID]];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self->delegate stopLoading];
                if ([data isKindOfClass:[NSError class]]) {
                    [self->delegate raiseAlert:[data description] msg:@""];
                } else if ([[data objectForKey:@"rc"] intValue]==0) {
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_OPENID] forKey:K_USER_OPENID];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_PHONE] forKey:K_USER_PHONE];
                    [self->delegate.preferences synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                }
            });
        });
    } else {
        nav = [[UINavigationController alloc] initWithRootViewController:lc];
        [self.view addSubview:nav.view];
    };
    // Do any additional setup after loading the view.
}
-(void) goHome {
    if (!home) {
        home = [[Home alloc] initWithNibName:nil bundle:nil];
    }
    nav = [[UINavigationController alloc] initWithRootViewController:home];
    [nav setNavigationBarHidden:YES];
    [nav setToolbarHidden:YES];
    [self.view addSubview:nav.view];
    [self.view addSubview:header.view];
    [self.view addSubview:footer.view];
}
-(void) goLogout {
    if (!lc) {
        lc = [[Introduction alloc] initWithNibName:nil bundle:nil];
    }
    nav = [[UINavigationController alloc] initWithRootViewController:lc];
    [nav setNavigationBarHidden:YES];
    [nav setToolbarHidden:YES];
    [self.view addSubview:nav.view];
    [header.view removeFromSuperview];
    [footer.view removeFromSuperview];
}
-(void) goSlide:(NSNotification *)notif {
    if ([notif.object isKindOfClass:[NSDictionary class]]) {
        int type = [[notif.object objectForKey:@"type"] intValue];
        if (type==VC_TYPE_HOME) {
            [nav popToRootViewControllerAnimated:YES];
        } else if (type==VC_TYPE_MESSAGE_LIST) {
            if (!messageList) {
                messageList = [[MessageList alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:messageList];
        } else if (type==VC_TYPE_SCAN_QRCODE) {
            if (!chargeqr) {
                chargeqr = [[ChargeQR alloc] initWithNibName:nil bundle:nil];
            }
            [self pushOrPop:chargeqr];
          /*  if (!scanqr) {
                scanqr = [[ScanQR alloc] initWithNibName:nil bundle:nil];
            }
           [self pushOrPop:scanqr];
           */
        } else if (type==VC_TYPE_MY) {
            if (!my) {
                my = [[My alloc] initWithNibName:nil bundle:nil];
            }
            [self pushOrPop:my];
        } else if (type==VC_TYPE_MY_EDITINFO) {
            if (!editinfo) {
                editinfo = [[EditInfo alloc] initWithNibName:nil bundle:nil];
            }
            [self pushOrPop:editinfo];
        } else if (type==VC_TYPE_MY_WALLET) {
            if (!wallet) {
                wallet = [[Wallet alloc] initWithNibName:nil bundle:nil];
            }
            [self pushOrPop:wallet];
        } else if (type==VC_TYPE_POINT_HISTORY) {
            if (!points) {
                points = [[PointsHistory alloc] initWithStyle:UITableViewStylePlain];
                points.type = TYPE_POINTS;
            }
            [self pushOrPop:points];
        } else if (type==VC_TYPE_PAYMENT_CODE) {
            if (!points) {
                paymentcode = [[PaymentCode alloc] initWithNibName:nil bundle:nil];
                paymentcode.state = PC_STATE_INIT;
            }
            [self pushOrPop:paymentcode];
        } else if (type==VC_TYPE_MESSAGE_DETAIL) {
            if (!messageDetails) {
                messageDetails = [[MessageDetails alloc] initWithNibName:nil bundle:nil];
            }
           [self pushOrPop:messageDetails];
           [messageDetails loadMessage:[[notif.object objectForKey:@"messageID"]intValue]];
        } else if (type==VC_TYPE_TOP_UP) {
            if (!topup) {
                topup = [[TopUp alloc] initWithNibName:nil bundle:nil];
            }
            [self pushOrPop:topup];            
        }
    }
    if ([nav.viewControllers count]>1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_BACK_BTN object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_BACK_BTN object:nil];
    }
}
-(void) pushOrPop:(UIViewController *)v {
    if ([nav.viewControllers containsObject:v]) {
        [nav popToViewController:v animated:YES];
    } else {
        [nav pushViewController:v animated:YES];
    }
}
-(void) onBackPressed {
    [nav popViewControllerAnimated:YES];
}
@end

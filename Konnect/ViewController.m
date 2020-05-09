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
#import "Facility.h"
#import "ImageList.h"
#import "Booking.h"
#import "ORWebViewController.h"
#import "FacilityList.h"
#import "ServiceOffice.h"
#import "ContactUs.h"
#import "Invoices.h"
#import "PastInvoices.h"
#import "Invoice.h"
#import "RefereralQR.h"
#import "Company.h"
#import "Office.h"
#import "SearchMeetingRoom.h"
#import "KonnectNews.h"
#import "NewsDetails.h"
#import "AboutKonnect.h"
#import "Events.h"
#import "EventDetails.h"
#import "Coupons.h"
#import "Reservations.h"
#import "BuyPrintQuota.h"
#import "OfficeNotifications.h"
#import "MeetingRoomList.h"
#import "MeetingRoom.h"
#import "JoinVIPForm.h"
#import "VirtualOffice.h"
#import "OfficePromo.h"
#import "ConceirgeService.h"
#import "ContactOffice.h"
#import "PastEventsList.h"
#import "ReserveNow.h"
#import "EventList.h"
#define SKIP_AUTO_LOGIN 1 //  1 is normal
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    showingController = false;
    lc = [[Introduction alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:lc animated:NO];
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goHome) name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goLogout) name:LOGOUT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goLogin) name:GO_LOGIN object:nil];
    
    header = [[Header alloc] initWithNibName:nil bundle:nil];
    header.parent = self;
    [header.view setFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight)];
    
    footer = [[Footer alloc] initWithNibName:nil bundle:nil];
    footer.parent = self;
    [footer.view setFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight,delegate.screenWidth,delegate.footerHeight)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goSlide:) name:GO_SLIDE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmPayment:) name:RECEIVE_TRANSACTION_REQUEST object:nil];
    #if DEBUG
        #if TARGET_IPHONE_SIMULATOR
            [delegate.preferences setObject:@"oyhE7w3wBH5m7PdUF7RrwsN9bGgk" forKey:WX_USER_UNION_ID];
            [delegate.preferences setObject:@"001297.b8f4a40661ee405b927017a4d3064552.1430" forKey:APPLE_USER_ID];

            [delegate.preferences synchronize];
    
        #else
        #endif
    
    #endif
    
    if (SKIP_AUTO_LOGIN&&[[delegate.preferences objectForKey:WX_USER_UNION_ID] isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:WX_USER_UNION_ID] isEqualToString:@""]) {
        [delegate startLoading];
        dispatch_queue_t createQueue = dispatch_queue_create("SerialQueue", nil);
        dispatch_async(createQueue, ^(){
            NSDictionary *data = [[KApiManager sharedManager] logWithWeChat:[self->delegate.preferences objectForKey:WX_USER_UNION_ID]];
            dispatch_async(dispatch_get_main_queue(), ^(){
                [self->delegate stopLoading];
                NSLog(@"ViewController: %@",[data description]);
                if ([data isKindOfClass:[NSError class]]) {
                    [self->delegate raiseAlert:[data description] msg:@""];
                    self->nav = [[UINavigationController alloc] initWithRootViewController:self->lc];
                    self->nav.delegate = self;;
                    [self.view addSubview:self->nav.view];
                } else if ([[data objectForKey:@"rc"] intValue]==0) {
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_OPENID] forKey:K_USER_OPENID];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_PHONE] forKey:K_USER_PHONE];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_NAME] forKey:K_USER_NAME];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_EMAIL] forKey:K_USER_EMAIL];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_TIER] forKey:K_USER_TIER];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_NO] forKey:K_USER_NO];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_GENDER] forKey:K_USER_GENDER];
                    [self->delegate.preferences setObject:[data objectForKey:K_USER_AVATAR] forKey:K_USER_AVATAR];
                    [self->delegate.preferences synchronize];
                    [self->delegate updateMsgBadge];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                } else {
                    // cannot find login ID
                    [self->delegate raiseAlert:@"" msg:[data objectForKey:@"errmsg"]];
                    self->nav = [[UINavigationController alloc] initWithRootViewController:self->lc];
                    self->nav.delegate = self;;
                    [self.view addSubview:self->nav.view];
                }
            });
        });
    } else if (SKIP_AUTO_LOGIN&&[[delegate.preferences objectForKey:APPLE_USER_ID] isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:APPLE_USER_ID] isEqualToString:@""]) {
           [delegate startLoading];
           dispatch_queue_t createQueue = dispatch_queue_create("SerialQueue", nil);
           dispatch_async(createQueue, ^(){
               NSDictionary *data = [[KApiManager sharedManager] logWithApple:[self->delegate.preferences objectForKey:APPLE_USER_ID]];
               dispatch_async(dispatch_get_main_queue(), ^(){
                   [self->delegate stopLoading];
                   if ([data isKindOfClass:[NSError class]]) {
                       [self->delegate raiseAlert:[data description] msg:@""];
                       self->nav = [[UINavigationController alloc] initWithRootViewController:self->lc];
                       self->nav.delegate = self;;
                       [self.view addSubview:self->nav.view];
                   } else if ([[data objectForKey:@"rc"] intValue]==0) {
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_OPENID] forKey:K_USER_OPENID];
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_PHONE] forKey:K_USER_PHONE];
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_NAME] forKey:K_USER_NAME];
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_EMAIL] forKey:K_USER_EMAIL];
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_TIER] forKey:K_USER_TIER];
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_NO] forKey:K_USER_NO];
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_GENDER] forKey:K_USER_GENDER];
                       [self->delegate.preferences setObject:[data objectForKey:K_USER_AVATAR] forKey:K_USER_AVATAR];
                       [self->delegate.preferences synchronize];
                       [self->delegate updateMsgBadge];
                       [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];
                   } else {
                       // cannot find login ID
                       [self->delegate raiseAlert:@"" msg:[data objectForKey:@"errmsg"]];
                       self->nav = [[UINavigationController alloc] initWithRootViewController:self->lc];
                       self->nav.delegate = self;;
                       [self.view addSubview:self->nav.view];
                   }
               });
           });
    } else {
        nav = [[UINavigationController alloc] initWithRootViewController:lc];
        nav.delegate = self;;
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
    nav.delegate = self;;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [nav.view addGestureRecognizer:swipe];
    [self.view addSubview:nav.view];
    [self.view addSubview:header.view];
    [self.view addSubview:footer.view];
}
-(void) swipe:(UISwipeGestureRecognizer *)swipe {
    [self onBackPressed];
}
-(void) goLogout {
    nav = [[UINavigationController alloc] initWithRootViewController:lc];
    [nav setNavigationBarHidden:YES];
    [nav setToolbarHidden:YES];
    nav.delegate = self;;
    [delegate clearMsgBadge];
    [self.view addSubview:nav.view];
    [header.view removeFromSuperview];
    [footer.view removeFromSuperview];
    
}
-(void) goLogin {
    nav = [[UINavigationController alloc] initWithRootViewController:lc];
    [nav setNavigationBarHidden:YES];
    [nav setToolbarHidden:YES];
    nav.delegate = self;;
    [self.view addSubview:nav.view];
    [header.view removeFromSuperview];
    [footer.view removeFromSuperview];
    [lc login];
}
-(void) confirmPayment:(NSNotification *) notif {    
    if (!paymentcode) {
        paymentcode = [[PaymentCode alloc] initWithNibName:nil bundle:nil];
    }
    paymentcode.state = PC_STATE_NORMAL;
    [paymentcode paymentRequest:[notif.object objectForKey:PAYMENT_TOKEN] andAmount:[notif.object objectForKey:@"amount"] forVendor:[notif.object objectForKey:@"vendorid"] withRemarks:[notif.object objectForKey:@"remarks"]];
    
    [self pushOrPop:paymentcode];
}
-(void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    showingController = NO;
}
-(void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    showingController = YES;
}
-(void) goSlide:(NSNotification *)notif {
    if (showingController) return;
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
            /*
            if (!chargeqr) {
                chargeqr = [[ChargeQR alloc] initWithNibName:nil bundle:nil];
            }
            [self pushOrPop:chargeqr];
             */
            if (!scanqr) {
                scanqr = [[ScanQR alloc] initWithNibName:nil bundle:nil];
            }
           [self pushOrPop:scanqr];
           
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
            if (!paymentcode) {
                paymentcode = [[PaymentCode alloc] initWithNibName:nil bundle:nil];
            }
            paymentcode.state = PC_STATE_INIT;
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
        } else if (type==VC_TYPE_IMAGE_GALLERY) {
            if (!imgList) {
                imgList = [[ImageList alloc] initWithStyle:UITableViewStylePlain];
            }
            if ([[notif.object objectForKey:@"images"] isKindOfClass:[NSArray class]]) {
                imgList.datasrc = [notif.object objectForKey:@"images"];
            }
            [self pushOrPop:imgList];
        } else if (type==VC_TYPE_IMAGE_GALLERY) {
            if (!imgList) {
                imgList = [[ImageList alloc] initWithStyle:UITableViewStylePlain];
            }
            if ([[notif.object objectForKey:@"images"] isKindOfClass:[NSArray class]]) {
                imgList.datasrc = [notif.object objectForKey:@"images"];
            }
            [self pushOrPop:imgList];
        } else if (type==VC_TYPE_RESTAURANT_BOOKING) {
            if (!booking) {
                booking = [[Booking alloc] initWithStyle:UITableViewStylePlain];
            }
            if ([[notif.object objectForKey:@"facility"] isKindOfClass:[NSDictionary class]]) {
                booking.facility =[notif.object objectForKey:@"facility"];
            }
            [self pushOrPop:booking];
        } else if (type==VC_TYPE_FACILITY) {
            if (!facility) {
                facility = [[Facility alloc] initWithNibName:nil bundle:nil];
            }
            facility.facilityid =[notif.object objectForKey:@"facilityID"];
            [self pushOrPop:facility];
        } else if (type==VC_TYPE_TOU) {
            if (!tou) {
                tou = [[ORWebViewController alloc] initWithNibName:nil bundle:nil];
            }
            [tou loadData:[notif.object objectForKey:@"url"]];
            [self.view.window.rootViewController presentViewController:tou animated:YES completion:nil];
        } else if (type==VC_TYPE_FACILITIES) {
            if (!faciliites) {
                faciliites = [[FacilityList alloc] initWithStyle:UITableViewStylePlain];
                faciliites.title = TEXT_FNB;
            }
            [self pushOrPop:faciliites];
        } else if (type==VC_TYPE_SERVICE_OFFICE) {
            if (!serviceOffice) {
                serviceOffice = [[ServiceOffice alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:serviceOffice];
        } else if (type==VC_TYPE_CONTACT_US) {
            if (!contact) {
                contact = [[ContactUs alloc] initWithStyle:UITableViewStylePlain];
            }
           
            contact.title =[notif.object objectForKey:@"title"];
            [self pushOrPop:contact];
            if ([[notif.object objectForKey:@"inquirytype"] isKindOfClass:[NSString class]] && ![[notif.object objectForKey:@"inquirytype"] isEqualToString:@""]) {
                contact.inquirytype = [notif.object objectForKey:@"inquirytype"];
                [contact.tableView reloadData];
            }
        } else if (type==VC_TYPE_INVOICES) {
            if (!invoice) {
                invoice = [[Invoices alloc] initWithStyle:UITableViewStylePlain];
            }
            invoice.invoicetype = [notif.object objectForKey:@"status"];
            [self pushOrPop:invoice];
        } else if (type==VC_TYPE_PAST_INVOICES) {
            if (!pastinvoice) {
                pastinvoice = [[PastInvoices alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:pastinvoice];
        } else if (type==VC_TYPE_INVOICE) {
            if (!inv) {
                inv = [[Invoice alloc] initWithStyle:UITableViewStylePlain];
            }
            inv.invoiceID =[notif.object objectForKey:@"invoiceID"];
            [self pushOrPop:inv];
        } else if (type==VC_TYPE_REFERER_QR) {
            if (!refqr) {
                refqr = [[RefereralQR alloc] initWithNibName:nil bundle:nil];
            }
            [self pushOrPop:refqr];
        
        } else if (type==VC_TYPE_COMPANY) {
            if (!company) {
                company = [[Company alloc] initWithNibName:nil bundle:nil];
            }
            company.companyID = [notif.object objectForKey:@"companyID"];
            [self pushOrPop:company];
        } else if (type==VC_TYPE_OFFICE) {
            if (!office) {
                office = [[Office alloc] initWithNibName:nil bundle:nil];
            }
            office.officeID = [notif.object objectForKey:@"officeID"];
            [self pushOrPop:office];
        } else if (type==VC_TYPE_SEARCH_MEETING_ROOM) {
            if (!searchroom) {
                searchroom = [[SearchMeetingRoom alloc] initWithStyle:UITableViewStylePlain];
            }
            if ([notif.object objectForKey:@"facility"] && [[notif.object objectForKey:@"facility"] isKindOfClass:[NSDictionary class]]) {
                searchroom.facility =[notif.object objectForKey:@"facility"];
            }
            [self pushOrPop:searchroom];
        } else if (type==VC_TYPE_KONNECT_NEWS) {
            if (!knews) {
                knews = [[KonnectNews alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:knews];
        } else if (type==VC_TYPE_NEWS_DETAILS) {
            if (!newsDetails) {
                newsDetails = [[NewsDetails alloc] initWithNibName:nil bundle:nil];
            }
            [newsDetails loadMessage:[[notif.object objectForKey:@"messageID"] intValue]];
            [self pushOrPop:newsDetails];
        } else if (type==VC_TYPE_ABOUT_KONNECT) {
            if (!about) {
                about = [[AboutKonnect alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:about];
        } else if (type==VC_TYPE_EVENT) {
            if (!event) {
                event = [[Events alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:event];
        } else if (type==VC_TYPE_EVENT_DETAILS) {
            if (!eventdetails) {
                eventdetails = [[EventDetails alloc] initWithNibName:nil bundle:nil];
            }
            eventdetails.eventID = [notif.object objectForKey:@"eventID"];
            
            [self pushOrPop:eventdetails];
        } else if (type==VC_TYPE_COUPON) {
            if (!coupon) {
                coupon = [[Coupons alloc] initWithStyle:UITableViewStylePlain];
            }
            
            [self pushOrPop:coupon];
        } else if (type==VC_TYPE_RESERVATIONS) {
            if (!reservation) {
                reservation = [[Reservations alloc] initWithStyle:UITableViewStylePlain];
            }
            
            [self pushOrPop:reservation];
        } else if (type==VC_TYPE_RESERVE_NOW) {
            if (!reserveNow) {
                reserveNow = [[ReserveNow alloc] initWithStyle:UITableViewStylePlain];
            }
            
            [self pushOrPop:reserveNow];
        } else if (type==VC_TYPE_PRINT_TOPUP) {
            if (!printTopup) {
                printTopup = [[BuyPrintQuota alloc] initWithStyle:UITableViewStylePlain];
            }
            
            [self pushOrPop:printTopup];
        } else if (type==VC_TYPE_OFFICE_NOTIFICATION) {
            if (!officenotif) {
                officenotif = [[OfficeNotifications alloc] initWithStyle:UITableViewStylePlain];
            }
            
            [self pushOrPop:officenotif];
        } else if (type==VC_TYPE_OFFICE_INTRO) {
            if (!meetingRoomList) {
                meetingRoomList = [[MeetingRoomList alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:meetingRoomList];
        } else if (type==VC_TYPE_MEETING_ROOM) {
            if (!meetingRoom) {
                meetingRoom = [[MeetingRoom alloc] initWithNibName:nil bundle:nil];
            }
            meetingRoom.facilityID = [notif.object objectForKey:@"facilityID"];
            if ([[notif.object objectForKey:@"queryType"] isKindOfClass:[NSString class]] && [[notif.object objectForKey:@"queryType"] isEqualToString:@"book"]) {
                meetingRoom.bookStartTime = [notif.object objectForKey:@"bookingstarttime"];
                meetingRoom.bookDate = [notif.object objectForKey:@"bookingdate"];
                meetingRoom.bookEndTime = [notif.object objectForKey:@"bookingendtime"];
                meetingRoom.cost = [[notif.object objectForKey:@"cost"] intValue];
                meetingRoom.startTime = [[notif.object objectForKey:@"startTime"] floatValue];
                meetingRoom.endTime = [[notif.object objectForKey:@"endTime"] floatValue];
                meetingRoom.bookingInfo = nil;
            } else if ([[notif.object objectForKey:@"queryType"] isKindOfClass:[NSString class]] && [[notif.object objectForKey:@"queryType"] isEqualToString:@"cancel"]) {
                meetingRoom.bookingInfo = [notif.object objectForKey:@"bookingInfo"];
                meetingRoom.bookStartTime = @"";
                meetingRoom.bookDate = @"";
                meetingRoom.bookEndTime = @"";
                meetingRoom.cost = 0;
                meetingRoom.startTime = 0;
                meetingRoom.endTime = 0;
            } else {
                meetingRoom.bookStartTime = @"";
                meetingRoom.bookDate = @"";
                meetingRoom.bookEndTime = @"";
                meetingRoom.cost = 0;
                meetingRoom.startTime = 0;
                meetingRoom.endTime = 0;
                meetingRoom.bookingInfo = nil;
            }
            [self pushOrPop:meetingRoom];
        } else if (type==VC_TYPE_JOIN_VIP) {
            if (!joinvip) {
                joinvip = [[JoinVIPForm alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:joinvip];
        } else if (type==VC_TYPE_VIRTUAL_OFFICE) {
            if (!virtualoffice) {
                virtualoffice = [[VirtualOffice alloc] initWithStyle:UITableViewStylePlain];
            }
            virtualoffice.officeID = [notif.object objectForKey:@"officeID"];
            [self pushOrPop:virtualoffice];
        } else if (type==VC_TYPE_OFFICE_PROMO) {
            if (!officepromo) {
                officepromo = [[OfficePromo alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:officepromo];
        } else if (type==VC_TYPE_CONCIERGE) {
            if (!conser) {
                conser = [[ConceirgeService alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:conser];
        } else if (type==VC_TYPE_CONTACT_OFFICE) {
            if (!contactOffice) {
                contactOffice = [[ContactOffice alloc] initWithStyle:UITableViewStylePlain];
            }
            
            contactOffice.title =[notif.object objectForKey:@"title"];
            [self pushOrPop:contactOffice];
            if ([[notif.object objectForKey:@"inquirytype"] isKindOfClass:[NSString class]] && ![[notif.object objectForKey:@"inquirytype"] isEqualToString:@""]) {
                contactOffice.inquirytype = [notif.object objectForKey:@"inquirytype"];
                [contactOffice.tableView reloadData];
            }
        } else if (type==VC_TYPE_PAST_ACTIVITIES) {
            if (!pastEvents) {
                pastEvents = [[PastEventsList alloc] initWithStyle:UITableViewStylePlain];
            }
            [self pushOrPop:pastEvents];
        
        } else if (type==VC_TYPE_EVENT_LIST) {
            if (!events) {
                events = [[EventList alloc] initWithStyle:UITableViewStylePlain];
            }
            events.datasrc = [notif.object objectForKey:@"datasrc"];
            [self pushOrPop:events];
        }
        
        
    }
    if ([nav.viewControllers count]>1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_BACK_BTN object:nil];
    } else {
     //   [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_BACK_BTN object:nil];
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

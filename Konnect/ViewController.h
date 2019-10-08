//
//  ViewController.h
//  Konnect
//
//  Created by Jacky Mok on 3/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Introduction;
@class Home;
@class AppDelegate;
@class Header;
@class MessageList;
@class MessageDetails;
@class Footer;
@class ScanQR;
@class My;
@class EditInfo;
@class Wallet;
@interface ViewController : UIViewController {
    Introduction *lc;
    UINavigationController *nav;
    Home *home;
    AppDelegate *delegate;
    Header *header;
    Footer *footer;
    MessageList *messageList;
    MessageDetails *messageDetails;
    ScanQR *scanqr;
    My *my;
    EditInfo *editinfo;
    Wallet *wallet;
    
}
-(void) onBackPressed;

@end


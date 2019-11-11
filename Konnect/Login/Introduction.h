//
//  LoginController.h
//  Konnect
//
//  Created by Jacky Mok on 5/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORViewController.h"
@class LoginOrReg;
#define STATUS_BAR_HEIGHT 44
NS_ASSUME_NONNULL_BEGIN
@interface Introduction : ORViewController <UIScrollViewDelegate>{    
    UIViewController *scrollc;
    UIButton *login;
    UIButton *reg;
    UIView *indicators;
    LoginOrReg *loginVC;
    
    int index;
}
-(void) backToIntro;
-(void) login;
@end

NS_ASSUME_NONNULL_END

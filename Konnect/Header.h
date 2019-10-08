//
//  Header.h
//  Konnect
//
//  Created by Jacky Mok on 26/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
@class AppDelegate;
@class ViewController;
NS_ASSUME_NONNULL_BEGIN
#define STATUS_BAR_HEIGHT 44
@interface Header : UIViewController {
    AppDelegate *delegate;
    ViewController __weak *parent;
    BOOL backEnabled;
    UIButton *back;
    UIImageView *logo;
    UILabel *title;
}
@property (weak) ViewController *parent;
@end

NS_ASSUME_NONNULL_END

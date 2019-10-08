//
//  ORViewController.h
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AppDelegate;
@interface ORViewController : UIViewController {
    AppDelegate *delegate;
    UIScrollView *scroll;
    UITextField *activeField;

}
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
@end

NS_ASSUME_NONNULL_END

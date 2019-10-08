//
//  EditInfo.h
//  Konnect
//
//  Created by Jacky Mok on 4/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORTableViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class AppDelegate;
@interface EditInfo : ORTableViewController <UITextFieldDelegate>{
    NSArray *fields;
    UIAlertController * emailAlertController;
    BOOL edited;
}

@end

NS_ASSUME_NONNULL_END

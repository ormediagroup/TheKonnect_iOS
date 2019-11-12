//
//  AssoPIcker.h
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORTableViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class RegisterViewController;
@interface AssoPIcker : ORTableViewController {
    NSArray *fields;
    RegisterViewController __weak *parent;
    NSMutableArray *selected;
}
@property (weak) RegisterViewController *parent;
@end

NS_ASSUME_NONNULL_END

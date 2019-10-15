//
//  ImageList.h
//  Konnect
//
//  Created by Jacky Mok on 14/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORTableViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class AppDelegate;

@interface ImageList : ORTableViewController {
    NSArray * datasrc;    
}
@property NSArray * datasrc;
@end

NS_ASSUME_NONNULL_END

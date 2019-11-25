//
//  My.h
//  Konnect
//
//  Created by Jacky Mok on 4/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface My : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    AppDelegate *delegate;
    NSArray *labels;
    NSArray *iconsrc;
    UIImagePickerController *imgpicker;
    UIImageView *avatar;    
}

@end

NS_ASSUME_NONNULL_END

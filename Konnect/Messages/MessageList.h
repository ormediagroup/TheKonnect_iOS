//
//  MessageList.h
//  Konnect
//
//  Created by Jacky Mok on 3/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AppDelegate;
@interface MessageList : UITableViewController {
    AppDelegate *delegate;
    NSMutableArray *datasrc;
    BOOL loadingMore;
}

@end

NS_ASSUME_NONNULL_END

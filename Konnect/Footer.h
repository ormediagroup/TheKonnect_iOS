//
//  Footer.h
//  Konnect
//
//  Created by Jacky Mok on 27/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@class ViewController;
NS_ASSUME_NONNULL_BEGIN

@interface Footer : UIViewController {
    AppDelegate *delegate;
    ViewController __weak *parent;

}
@property (weak) ViewController *parent;
@end

NS_ASSUME_NONNULL_END

//
//  MeetingRoom.h
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeetingRoom : ORViewController {
    NSString *facilityID;
    NSDictionary *datasrc;
}
@property NSString *facilityID;
@end
NS_ASSUME_NONNULL_END

//
//  MeetingRoom.h
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"



@interface MeetingRoom : ORViewController {
    NSString *facilityID;
    NSDictionary *datasrc;
    NSString *bookDate, *bookStartTime, *bookEndTime;
    CGFloat startTime, endTime;
    NSDictionary *bookingInfo;
    int cost;
}
@property NSString *facilityID;
@property NSString *bookDate;
@property NSString *bookStartTime;
@property NSString *bookEndTime;
@property CGFloat startTime, endTime;
@property NSDictionary *bookingInfo;
@property int cost;
@end


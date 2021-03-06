//
//  SearchMeetingRoom.m
//  Konnect
//
//  Created by Jacky Mok on 9/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "SearchMeetingRoom.h"
#import "AppDelegate.h"
@interface SearchMeetingRoom ()

@end

@implementation SearchMeetingRoom
@synthesize facility;
-(void) viewWillAppear:(BOOL)animated {
    [self setEditing:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_SEARCH_MEETING_ROOM];
    if ([delegate isLoggedIn]) {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[@"get-booking"]
                                       forKeys:@[@"action"]]
                                         interation:0 callback:^(NSDictionary *data) {
                                             if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
                                                 self->bookedrooms = [data objectForKey:@"data"];
                                                 [self.tableView reloadData];
                                             } else {
                                                 [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             }
                                         }];
    } else {
        self->bookedrooms = @[];
        [self.tableView reloadData];
    }
    
    bookDate = [dateFormat stringFromDate:[NSDate date]];
    isToday = YES;
    refreshDate = NO;
    [starttimepicker selectRow:0 inComponent:0 animated:NO];
    [endtimepicker selectRow:0 inComponent:0 animated:NO];
    NSDateFormatter *hFormat = [[NSDateFormatter alloc] init];
    [hFormat setDateFormat:@"HH"];
    int hr = [[hFormat stringFromDate:[NSDate date]] intValue];
    [hFormat setDateFormat:@"mm"];
    int min = [[hFormat stringFromDate:[NSDate date]] intValue];
    if (min>30) {
        startHr = hr+1;
        startMin = 0;
        bookStartTimeHr = [NSString stringWithFormat:@"%d",(int)floor(startHr)];
        bookStartTimeMin = @"00";
        bookEndTimeHr = [NSString stringWithFormat:@"%d",(int)floor(startHr)];
        bookEndTimeMin = @"30";
        startTime = startHr+startMin;
        endTime = startTime+0.5;
    } else {
        startHr = hr;
        startMin = 0.5;
        bookStartTimeHr = [NSString stringWithFormat:@"%d",(int)floor(startHr)];
        bookStartTimeMin = @"30";
        bookEndTimeHr = [NSString stringWithFormat:@"%d",(int)floor(startHr+1)];
        bookEndTimeMin = @"00";
        startTime = startHr+startMin;
        endTime = startTime+0.5;
    }
}
-(void) viewWillDisappear:(BOOL)animated {
  //  datasrc = @[];    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    bookedrooms = @[];
    datasrc = @[];
    pickerViewToolbar = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    
    UIView *touchbg = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    [touchbg setBackgroundColor:UICOLOR_ALPHA_BACKGROUND];
    [touchbg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeToolbar)]];
    [pickerViewToolbar addSubview:touchbg];
    
    
    CGFloat top = delegate.screenHeight-360;
    
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,top,delegate.screenWidth,50)];
    [toolbar setBackgroundColor:[UIColor whiteColor]];
    [pickerViewToolbar addSubview:toolbar];
    [delegate setSystemBG:toolbar];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    [done setFrame:CGRectMake(delegate.screenWidth-100,0,100,50)];
    [done setTitle:TEXT_DONE forState:UIControlStateNormal];
    [done setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [done addTarget:self action:@selector(selectPickerValue) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:done];
    
    pickerValue = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-100-SIDE_PAD,50)];
    [pickerValue setFont:[UIFont systemFontOfSize:FONT_M]];
    [toolbar addSubview:pickerValue];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,top+50,delegate.screenWidth,10)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [pickerViewToolbar  addSubview:line];
    
    datepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [datepicker setBackgroundColor:[UIColor whiteColor]];
    datepicker.delegate = self;
    datepicker.dataSource = self;
    [delegate setSystemBG:datepicker];
    datepicker.tag = 1;
    
    starttimepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [starttimepicker setBackgroundColor:[UIColor whiteColor]];
    starttimepicker.delegate = self;
    starttimepicker.dataSource = self;
    starttimepicker.tag = 1;
    [delegate setSystemBG:starttimepicker];
    
    endtimepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [endtimepicker setBackgroundColor:[UIColor whiteColor]];
    endtimepicker.delegate = self;
    endtimepicker.dataSource = self;
    endtimepicker.tag = 1;
    [delegate setSystemBG:endtimepicker];
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
}
    
    /*
    bookStartTimeHr = @"09";
    bookStartTimeMin = @"00";
    bookEndTimeHr = @"10";
    bookEndTimeMin = @"00";
    startTime = 9.0;
    endTime = 10.0;
     */
    // [endtimepicker selectRow:10 inComponent:0 animated:NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

-(void) removeToolbar {
    [pickerViewToolbar removeFromSuperview];
}
#pragma mark - Picker view data source
-(void) selectPickerValue {
    UIPickerView *picker = [pickerViewToolbar viewWithTag:1];
    if (picker==datepicker) {
        bookDate = pickerValue.text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==starttimepicker){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==endtimepicker){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [pickerViewToolbar removeFromSuperview];
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        NSDate *now = [NSDate date];
        NSDate *newdate = [now dateByAddingTimeInterval:row*24*60*60];
        return [dateFormat stringFromDate:newdate];
    } else if (pickerView == starttimepicker) {
        CGFloat r = (startHr+startMin+0.5*row);
        int hr = floor(r);
        int min = (r > floor(r))?30:0;
        return [NSString stringWithFormat:@"%02d:%02d",hr,min];
    } else if (pickerView == endtimepicker) {
        CGFloat r = (startTime+0.5+0.5*row);
        int hr = floor(r);
        int min = (r > floor(r))?30:0;
        return [NSString stringWithFormat:@"%02d:%02d",hr,min];
    } else {
        return @"";
    }
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  /*  if (pickerView == starttimepicker || pickerView == endtimepicker) {
        return 2;
    } else {
   */
        return 1;
    //}
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        return 30;
    } else if (pickerView == starttimepicker) {
        if (!isToday) {
            return 48;
        } else {
            int comp = 48-(startHr+startMin)*2;
            return comp;
        }
    } else if (pickerView == endtimepicker) {
        return 48-(startTime*2);
    }
    return 0;
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        NSDate *now = [NSDate date];
        NSDate *newdate = [now dateByAddingTimeInterval:row*24*60*60];
        if (row==0) {
           isToday = YES;
        } else {
            if (isToday) {
                 // switched date
                refreshDate = YES;
            }
           isToday = NO;
        }
        [pickerValue setText:[dateFormat stringFromDate:newdate]];
    } else if (pickerView == starttimepicker) {
        NSArray *st = [[self pickerView:starttimepicker titleForRow:row forComponent:component] componentsSeparatedByString:@":"];
        if ([st count]==2) {
            bookStartTimeHr = st[0];
            bookStartTimeMin = st[1];
        }
        [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin]];
        startTime = [bookStartTimeHr floatValue];
        if (![bookStartTimeMin isEqualToString:@"00"]) {
            startTime+=0.5;
        }
        [endtimepicker reloadAllComponents];
        if (startTime >= endTime) {
            [endtimepicker selectRow:0 inComponent:0 animated:NO];
            endTime = startTime+0.5;
            bookEndTimeHr = [NSString stringWithFormat:@"%02d",(int)floor(endTime)];
            if (endTime > floor(endTime)) {
                bookEndTimeMin = @"30";
            } else {
                bookEndTimeMin = @"00";
            }
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
    } else if (pickerView == endtimepicker) {
        NSArray *et = [[self pickerView:endtimepicker titleForRow:row forComponent:component] componentsSeparatedByString:@":"];
        if ([et count]==2) {
           bookEndTimeHr = et[0];
           bookEndTimeMin = et[1];
        }
        endTime = [bookStartTimeHr floatValue];
        if (![bookEndTimeMin isEqualToString:@"00"]) {
           endTime+=0.5;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section==0) {
        CGFloat headerheight = [super tableView:tableView heightForHeaderInSection:0];
        if ([bookedrooms count]>0) {
            headerheight+=60;
        }
        return headerheight;
    }
    else {
        return 60;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0||section==1) return 0;
    else return delegate.footerHeight;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        
        UIView *h  = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight+60)];
        
        [h setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        if ([bookedrooms count]>0) {

            UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth-SIDE_PAD,60)];
            [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
            [v setTextColor:[UIColor darkTextColor]];
            [v setText:TEXT_BOOKED_ROOM];
            [h addSubview:v];
        }
        return h;
    } else if (section==1) {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,60)];
        [h setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,60)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:[UIColor darkTextColor]];
        [v setText:TEXT_BOOK_ROOM_NOW];
        [h addSubview:v];
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setBackgroundColor:[delegate getThemeColor]];
        [b setTitleColor:UICOLOR_GOLD forState: UIControlStateNormal];
        [b.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        b.layer.cornerRadius = 5.0f;
        [b setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 0.0)];

        [b setTitle:TEXT_INQUIRY_K_SPACE forState:UIControlStateNormal];
        [b setFrame:CGRectMake(delegate.screenWidth-204,10,200,40)];
        [b addTarget:self action:@selector(openEnquiryForm) forControlEvents:UIControlEventTouchUpInside];
        [h addSubview:b];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(16,8,26, 26)];
        [icon setContentMode:UIViewContentModeScaleAspectFit];
        [icon setImage:[UIImage imageNamed:@"cs-gold.png"]];
        [b addSubview:icon];
        return h;
    } else if (section==2) {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,60)];
        [h setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,60)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:[UIColor darkTextColor]];
        if (status==ROOM_STATUS_TYPE_AVAIL) {
            [v setText:TEXT_BOOK_AVAILABLE];
        } else if (status==ROOM_STATUS_TYPE_PARTIAL) {
            [v setText:TEXT_BOOK_PARTIAL];
        } else if (status==ROOM_STATUS_TYPE_PARTIAL) {
            [v setText:TEXT_BOOK_NONE];
        }
        [h addSubview:v];
        return h;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension)];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [bookedrooms count];
    }
    else if (section==1) {
        if (facility && [facility isKindOfClass:[NSDictionary class]]) {
            return 5;
        }
        return 4;
    } else {
        if (status==ROOM_STATUS_TYPE_NONE) {
            return 1;
        } else {
            return [datasrc count];
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1 && indexPath.row==3) {
        if (facility && [facility isKindOfClass:[NSDictionary class]]) {
            return 60;
        } else {
            return LINE_HEIGHT*3;
        }
    } else if (indexPath.section==1 && indexPath.row==4) {
        return LINE_HEIGHT*3;
    } else if (indexPath.section==2 || indexPath.section==0) {
        return 80;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_SEARCH_MEETING_ROOM];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section==0) {
        UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,80,80)];
        [i setContentMode:UIViewContentModeScaleAspectFill];
        [i setClipsToBounds:YES];
        [i setImage:[delegate getImage:[[bookedrooms objectAtIndex:indexPath.row] objectForKey:@"images"] callback:^(UIImage *image) {
            [i setImage:image];
        }]];
        [cell addSubview:i];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        int y=0;
        
        {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+60,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
            [l setText:[[bookedrooms objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
            [l setTextColor:[UIColor darkTextColor]];
            [l setFont:[UIFont systemFontOfSize:FONT_S]];
            [cell addSubview:l];
            y+=LINE_HEIGHT;
        }
        {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+60,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
            [l setText:[[bookedrooms objectAtIndex:indexPath.row]  objectForKey:@"description"]];
            [l setTextColor:[UIColor darkTextColor]];
            [l setFont:[UIFont systemFontOfSize:FONT_XS]];
            [l setTextColor:[UIColor darkTextColor]];
            [cell addSubview:l];
        }
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_BOOK_ROOM_DATE];
            [cell.detailTextLabel setText:bookDate];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_BOOK_ROOM_START_TIME];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin]];
        } else if (indexPath.row==2) {
            [cell.textLabel setText:TEXT_BOOK_ROOM_END_TIME];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@:%@",bookEndTimeHr,bookEndTimeMin]];
        } else if (indexPath.row==3 && (facility && [facility isKindOfClass:[NSDictionary class]])){
            UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,60,60)];
            [i setContentMode:UIViewContentModeScaleAspectFill];
            [i setClipsToBounds:YES];
            [i setImage:[delegate getImage:[facility objectForKey:@"images"] callback:^(UIImage *image) {
                [i setImage:image];
            }]];
            [cell addSubview:i];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            int y=0;
            
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD+60,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
                [l setText:[NSString stringWithFormat:@"%@%@",TEXT_ONLY_SHOW,[facility objectForKey:@"name_zh"]]];
                [l setTextColor:[UIColor darkTextColor]];
                [l setFont:[UIFont systemFontOfSize:FONT_S]];
                [cell addSubview:l];
                y+=LINE_HEIGHT;
            }
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD+60,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
                [l setText:[facility objectForKey:@"capacity"]];
                [l setFont:[UIFont systemFontOfSize:FONT_XS]];
                [l setTextColor:[UIColor darkTextColor]];
                [l setTextColor:[UIColor darkTextColor]];
                [cell addSubview:l];
            }
        } else {
            UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_HEIGHT*3)];
            [l setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
            [cell addSubview:l];
            UIButton *bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
            [bookNow setBackgroundColor:[delegate getThemeColor]];
            [bookNow setFrame:CGRectMake(0,20,delegate.screenWidth,50)];
            [bookNow addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
            [bookNow setTitle:TEXT_SEARCH_MEETING_ROOM forState:UIControlStateNormal];
            [bookNow setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
            [cell addSubview:bookNow];
        }
    } else if (indexPath.section==2) {
        if (status==ROOM_STATUS_TYPE_NONE) {
        } else if (status==ROOM_STATUS_TYPE_AVAIL) {
            UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,80,80)];
            [i setContentMode:UIViewContentModeScaleAspectFill];
            [i setClipsToBounds:YES];
            [i setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"images"] callback:^(UIImage *image) {
                [i setImage:image];
            }]];
            [cell addSubview:i];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            int y=0;
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+70,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
                [l setText:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"name_zh"]];
                [l setTextColor:[UIColor darkTextColor]];
                [l setFont:[UIFont systemFontOfSize:FONT_S]];
                [cell addSubview:l];
                y+=LINE_HEIGHT-10;
            }
            
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+70,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
                [l setText:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"pricetag"]];
                [l setTextColor:[UIColor darkTextColor]];
                [l setFont:[UIFont systemFontOfSize:FONT_XS]];
                [cell addSubview:l];
                y+=LINE_HEIGHT-10;
            }
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+70,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
                [l setText:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"capacity"]];
                
                [l setFont:[UIFont systemFontOfSize:FONT_XS]];
                [l setTextColor:[UIColor darkTextColor]];
                [cell addSubview:l];
            }
            {
                UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [b setFrame:CGRectMake(delegate.screenWidth-100,LINE_HEIGHT*2-10,80,LINE_HEIGHT)];
                [b.titleLabel setTextAlignment:NSTextAlignmentRight];
                [b setTitle:TEXT_BOOK_MEETING_ROOM forState:UIControlStateNormal];
                [b.titleLabel setFont:[UIFont systemFontOfSize:FONT_XS]];
                [b addTarget:self action:@selector(bookRoom:) forControlEvents:UIControlEventTouchUpInside];
                b.tag = indexPath.row;
                [cell addSubview:b];
            }
        }
        
        
    }
    // Configure the cell...
    
    return cell;
}
-(void) search {
    NSString *facilityID = @"";
    if (facility && [facility isKindOfClass:[NSDictionary class]]) {
        facilityID = [facility objectForKey:@"ID"];
    }
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[bookDate,[NSNumber numberWithFloat:startTime],[NSNumber numberWithFloat:endTime],facilityID]
                                   forKeys:@[@"bookingdate",@"bookingstarttime",@"bookingendtime",@"facilityID"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
                                             if ([[data objectForKey:@"available"] count]>0) {
                                                 self->status = ROOM_STATUS_TYPE_AVAIL;
                                                 self->datasrc = [data objectForKey:@"available"];
                                             } else if ([[data objectForKey:@"available"] count]>0) {
                                                 self->status = ROOM_STATUS_TYPE_PARTIAL;
                                                 self->datasrc = [data objectForKey:@"partial"];
                                             } else {
                                                 self->status = ROOM_STATUS_TYPE_NONE;
                                             }
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:@""];
                                         }
                                     }];
    
}
-(void) bookRoom:(UIButton *) b {
    if ([delegate checkLogin]) {
        CGFloat duration = (endTime - startTime)*2;
        int cost = ceil(duration * [[[[datasrc objectAtIndex:b.tag] objectForKey:@"room"] objectForKey:@"price"] intValue]);
        
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:TEXT_PAY_CONFIRM,cost]
                                                                       message:[NSString stringWithFormat:TEXT_CONFIRM_ROOM_BOOK_MSG,
                                                                                [[[datasrc objectAtIndex:b.tag] objectForKey:@"room"] objectForKey:@"name_zh"],
                                                                                bookDate,
                                                                                [NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin],
                                                                                [NSString stringWithFormat:@"%@:%@",bookEndTimeHr,bookEndTimeMin]
                                                                                ]
                                                                preferredStyle:UIAlertControllerStyleAlert
                                    ];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [alert addAction:[UIAlertAction actionWithTitle:TEXT_BOOK_ROOM_NOW style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self bookNow:(int)b.tag];
        }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}
-(void) bookNow:(int)rowid {
    /// [self->delegate raiseAlert:TEXT_BOOK_ROOM_SUCCESS msg:[NSString stringWithFormat:@"%@ %@:%@ - %@:%@",self->bookDate,self->bookStartTimeHr,self->bookStartTimeMin,self->bookStartTimeHr,self->bookStartTimeHr]];
    [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
    CGFloat duration = (endTime - startTime)*2;
    int cost = ceil(duration * [[[[datasrc objectAtIndex:rowid] objectForKey:@"room"] objectForKey:@"price"] intValue]);
  
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[bookDate,[NSNumber numberWithFloat:startTime],[NSNumber numberWithFloat:endTime],
                                             [[[datasrc objectAtIndex:rowid] objectForKey:@"room"] objectForKey:@"ID"],@"book"
                                             ]
                                   forKeys:@[@"bookingdate",@"bookingstarttime",@"bookingendtime",@"vendor_id",@"action"]]
                                     interation:0 callback:^(NSDictionary *bookdata) {
                                         if ([bookdata isKindOfClass:[NSDictionary class]] && [[bookdata objectForKey:@"rc"] intValue]==0) {
                                             [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-payment-token",K_API_ENDPOINT]
                                                                                   param:[[NSDictionary alloc] initWithObjects:@[@"get-token"]
                                                                                                                       forKeys:@[@"action"]]
                                              
                                                                              interation:0 callback:^(NSDictionary *data) {
                                                                                  if ([[data objectForKey:@"rc"] intValue]==0) {
                                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_TRANSACTION_REQUEST object:[[NSDictionary alloc] initWithObjects:@[[data objectForKey:@"data"],[NSNumber numberWithInt:cost],@"meetingroom",[bookdata objectForKey:@"bookingid"]] forKeys:@[PAYMENT_TOKEN,@"amount",@"vendorid",@"remarks"]]];
                                                                                      
                                                                                  } else if ([[data objectForKey:@"rc"] intValue]==2) {
                                                                                      UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_TITLE_NO_PAYMENT_CODE
                                                                                                                                                     message:TEXT_NO_PAYMENT_CODE
                                                                                                                                              preferredStyle:UIAlertControllerStyleAlert];
                                                                                      
                                                                                      UIAlertAction* setCodeAction = [UIAlertAction actionWithTitle:TEXT_SET_PAYMENT_CODE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                                                                                           [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_PAYMENT_CODE]] forKeys:@[@"type"]]];
                                                                                          [self dismissViewControllerAnimated:YES
                                                                                                                   completion:^{}];
                                                                                      }];
                                                                                      [alert addAction:setCodeAction];
                                                                                      UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                                          [self dismissViewControllerAnimated:YES
                                                                                                                   completion:^{
                                                                                                                   }];
                                                                                      }];
                                                                                      [alert addAction:defaultAction];
                                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                                          [self presentViewController:alert animated:YES completion:nil];
                                                                                      });
                                                                                  } else {
                                                                                      [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                                                                  }
                                                                              }];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[bookdata objectForKey:@"errmsg"]];
                                         }
                                     }];
    
}
-(void) openEnquiryForm {
     [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_TOU],[NSString stringWithFormat:@"%@/#/enquiry?userToken=%@",domain,[delegate.preferences objectForKey:K_USER_OPENID]]] forKeys:@[@"type",@"url"]]];
    /*
    NSURL *touURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/#/inquiry",domain]];
       if ([[UIApplication sharedApplication] canOpenURL:touURL]) {
           [[UIApplication sharedApplication] openURL:touURL options:@{} completionHandler:^(BOOL success) {}];
       }
     */
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [datepicker removeFromSuperview];
    [starttimepicker removeFromSuperview];
    [endtimepicker removeFromSuperview];
    if (indexPath.section==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MEETING_ROOM],
                                                 [[bookedrooms objectAtIndex:indexPath.row] objectForKey:@"roomID"],@"cancel",[bookedrooms objectAtIndex:indexPath.row]
                                                 ] forKeys:@[@"type",@"facilityID",@"queryType",@"bookingInfo"]]];
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            [pickerViewToolbar addSubview:datepicker];
            [pickerValue setText:bookDate];
            [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
        } else if (indexPath.row==1) {
            if (!isToday) {
               startHr = 0;
               startMin = 0;
           } else {
               NSDateFormatter *hFormat = [[NSDateFormatter alloc] init];
               [hFormat setDateFormat:@"HH"];
               int hr = [[hFormat stringFromDate:[NSDate date]] intValue];
               [hFormat setDateFormat:@"mm"];
               int min = [[hFormat stringFromDate:[NSDate date]] intValue];
               if (min>30) {
                   startHr = hr+1;
                   startMin = 0;
               } else {
                   startHr = hr;
                   startMin = 0.5;
               }
           }
            [starttimepicker reloadAllComponents];
            if (!isToday && refreshDate) {
                [starttimepicker selectRow:18 inComponent:0 animated:NO];
                refreshDate = NO;
            }
            [pickerViewToolbar addSubview:starttimepicker];
            [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin]];
            [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
        } else if (indexPath.row==2) {
            [pickerViewToolbar addSubview:endtimepicker];
            [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookEndTimeHr,bookEndTimeMin]];
            [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
        } else if (indexPath.row==3 && facility && [facility isKindOfClass:[NSDictionary class]]) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_CANCEL_SEARCH_FILTER_DISPLAY_OTHERS
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_CANCEL_FILTER style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                self->facility = nil;
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }];
            [alert addAction:defaultAction];
            [alert addAction:[UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
            });
        }
    } else if (indexPath.section==2) {
        if (status==ROOM_STATUS_TYPE_AVAIL) {
            CGFloat duration = (endTime - startTime)*2;
            int cost = ceil(duration * [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"price"] intValue]);
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[
                                                     [NSNumber numberWithInt:VC_TYPE_MEETING_ROOM],
                                                     [[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"]objectForKey:@"ID"],
                                                     @"book",
                                                     bookDate,
                                                     [NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin],
                                                     [NSString stringWithFormat:@"%@:%@",bookEndTimeHr,bookEndTimeMin],
                                                     [NSNumber numberWithInteger:cost],
                                                     [NSNumber numberWithFloat:startTime],
                                                     [NSNumber numberWithFloat:endTime]
                                                     ]                                forKeys:@[@"type",@"facilityID",@"queryType",@"bookingdate",@"bookingstarttime",@"bookingendtime",@"cost",@"startTime",@"endTime"]]];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

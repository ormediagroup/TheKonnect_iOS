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
}
-(void) viewWillDisappear:(BOOL)animated {
    datasrc = @[];
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
    datepicker.tag = 1;
    
    starttimepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [starttimepicker setBackgroundColor:[UIColor whiteColor]];
    starttimepicker.delegate = self;
    starttimepicker.dataSource = self;
    starttimepicker.tag = 1;
    
    endtimepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [endtimepicker setBackgroundColor:[UIColor whiteColor]];
    endtimepicker.delegate = self;
    endtimepicker.dataSource = self;
    endtimepicker.tag = 1;
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    bookDate = [dateFormat stringFromDate:[NSDate date]];
    bookStartTimeHr = @"09";
    bookStartTimeMin = @"00";
    bookEndTimeHr = @"10";
    bookEndTimeMin = @"00";
    startTime = 9.0;
    endTime = 10.0;
    [starttimepicker selectRow:9 inComponent:0 animated:NO];
    // [endtimepicker selectRow:10 inComponent:0 animated:NO];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
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
        if (component==0) {
            return [NSString stringWithFormat:@"%02d",(int)row];
        } else {
            return [NSString stringWithFormat:@"%02d",(int)row*30];
        }
    } else if (pickerView == endtimepicker) {
        if (component==0) {
            CGFloat t = floor(startTime + 0.5);
            return [NSString stringWithFormat:@"%02d",(int)(row+t)];
        } else {
            return [NSString stringWithFormat:@"%02d",(int)row*30];
        }
    } else {
        return @"";
    }
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == starttimepicker || pickerView == endtimepicker) {
        return 2;
    } else {
        return 1;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        return 30;
    } else if (pickerView == starttimepicker) {
        if (component==0) {
            return 23;
        } else {
            return 2;
        }
    } else if (pickerView == endtimepicker) {
        if (component==0) {
            CGFloat t = floor(startTime + 0.5);
            return 23 - t;
        } else {
            return 2;
        }
    }
    return 0;
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        NSDate *now = [NSDate date];
        NSDate *newdate = [now dateByAddingTimeInterval:row*24*60*60];
        [pickerValue setText:[dateFormat stringFromDate:newdate]];
    } else if (pickerView == starttimepicker) {
        if (component==0) {
            bookStartTimeHr = [NSString stringWithFormat:@"%02d",(int)row];
        } else {
            bookStartTimeMin = [NSString stringWithFormat:@"%02d",(int)row*30];
        }
        [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin]];
        startTime = [bookStartTimeHr floatValue];
        if (![bookStartTimeMin isEqualToString:@"00"]) {
            startTime+=0.5;
        }
        [endtimepicker reloadAllComponents];
        if (startTime >= endTime) {
            endTime = startTime + 1;
            bookEndTimeHr = [NSString stringWithFormat:@"%02d",((int)row+1)];
            bookEndTimeMin = bookStartTimeMin;
            [endtimepicker selectRow:0 inComponent:0 animated:NO];
            if (floor(endTime)<endTime) {
                [endtimepicker selectRow:1 inComponent:1 animated:NO];
            } else {
                [endtimepicker selectRow:0 inComponent:1 animated:NO];
            }
        }
        
        
    } else if (pickerView == endtimepicker) {
        if (component==0) {
            CGFloat t = floor(startTime + 0.5);
            bookEndTimeHr = [NSString stringWithFormat:@"%02d",(int)(row+t)];
        } else {
            bookEndTimeMin = [NSString stringWithFormat:@"%02d",(int)row*30];
        }
        [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookEndTimeHr,bookEndTimeMin]];
        endTime = [bookEndTimeHr floatValue];
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
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth-SIDE_PAD,60)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:[UIColor darkTextColor]];
        [v setText:TEXT_BOOKED_ROOM];
        [h addSubview:v];
        return h;
    } else if (section==1) {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,60)];
        [h setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,60)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:[UIColor darkTextColor]];
        [v setText:TEXT_BOOK_ROOM_NOW];
        [h addSubview:v];
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
        return 70;
    } else if (indexPath.section==2 || indexPath.section==0) {
        return 80;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_SEARCH_MEETING_ROOM];
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
            [l setFont:[UIFont systemFontOfSize:FONT_S]];
            [cell addSubview:l];
            y+=LINE_HEIGHT;
        }
        {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+60,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
            [l setText:[[bookedrooms objectAtIndex:indexPath.row]  objectForKey:@"description"]];
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
        } else {
            UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,70)];
            [l setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
            [cell addSubview:l];
            UIButton *bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
            [bookNow setBackgroundColor:UICOLOR_PURPLE];
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
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            int y=0;
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+60,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
                [l setText:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"name_zh"]];
                [l setFont:[UIFont systemFontOfSize:FONT_S]];
                [cell addSubview:l];
                y+=LINE_HEIGHT;
            }
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+60,0,delegate.screenWidth-SIDE_PAD_2-60-SIDE_PAD,LINE_HEIGHT)];
                [l setText:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"pricetag"]];
                [l setFont:[UIFont systemFontOfSize:FONT_S]];
                [l setTextAlignment:NSTextAlignmentRight];
                [cell addSubview:l];
            }
            {
                UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+60,y,delegate.screenWidth-SIDE_PAD_2-60,LINE_HEIGHT)];
                [l setText:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"capacity"]];
                [l setFont:[UIFont systemFontOfSize:FONT_XS]];
                [l setTextColor:[UIColor darkTextColor]];
                [cell addSubview:l];
            }
        }
    }
    // Configure the cell...
    
    return cell;
}
-(void) search {
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[bookDate,[NSNumber numberWithFloat:startTime],[NSNumber numberWithFloat:endTime]]
                                   forKeys:@[@"bookingdate",@"bookingstarttime",@"bookingendtime"]]
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
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [datepicker removeFromSuperview];
    [starttimepicker removeFromSuperview];
    [endtimepicker removeFromSuperview];
    if (indexPath.section==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MEETING_ROOM],
                                                 [[bookedrooms objectAtIndex:indexPath.row] objectForKey:@"roomID"] 
                                                 ] forKeys:@[@"type",@"facilityID"]]];
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            [pickerViewToolbar addSubview:datepicker];
            [pickerValue setText:bookDate];
            [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
        } else if (indexPath.row==1) {
            [pickerViewToolbar addSubview:starttimepicker];
            [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin]];
            [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
        } else if (indexPath.row==2) {
            [pickerViewToolbar addSubview:endtimepicker];
            [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookEndTimeHr,bookEndTimeMin]];
            [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
        }
    } else if (indexPath.section==2) {
        if (status==ROOM_STATUS_TYPE_AVAIL) {
            if ([delegate checkLogin]) {
                CGFloat duration = (endTime - startTime)*2;
                int cost = ceil(duration * [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"price"] intValue]);
                
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:TEXT_PAY_CONFIRM,cost]
                                                                               message:[NSString stringWithFormat:TEXT_CONFIRM_ROOM_BOOK_MSG,
                                                                                        [[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"name_zh"],
                                                                                        bookDate,
                                                                                        [NSString stringWithFormat:@"%@:%@",bookStartTimeHr,bookStartTimeMin],
                                                                                        [NSString stringWithFormat:@"%@:%@",bookEndTimeHr,bookEndTimeMin]
                                                                                        ]
                                                                        preferredStyle:UIAlertControllerStyleAlert
                                            ];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [alert addAction:[UIAlertAction actionWithTitle:TEXT_BOOK_ROOM_NOW style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self bookNow:(int)indexPath.row];
                }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
                });
            }
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

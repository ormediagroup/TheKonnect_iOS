//
//  Events.m
//  Konnect
//
//  Created by Jacky Mok on 10/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Events.h"
#import "AppDelegate.h"
#import "const.h"
@interface Events ()

@end

@implementation Events
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_K_EVENT];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-events",
                                             ]
                                   forKeys:@[
                                             @"action",
                                             ]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) return [super tableView:tableView heightForHeaderInSection:0]+60;
    else {
        return 60;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1) return delegate.footerHeight;
    else return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        UIView *h =  [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight+60)];
        [h setBackgroundColor:[UIColor whiteColor]];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth-SIDE_PAD,60)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:UICOLOR_GOLD];
        [v setText:TEXT_K_EVENT];
        [h addSubview:v];
        return h;
        
    } else if (section==1){
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,60)];
        [h setBackgroundColor:[UIColor whiteColor]];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,60)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:UICOLOR_GOLD];
        [v setText:TEXT_RENT_K_SPACE];
        [h addSubview:v];
        return h;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension)];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
        CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
        CGFloat newg = h/w*(delegate.screenWidth-SIDE_PAD_2);
        int y = 0;
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,newg)];
        [v setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [v setImage:image];
        }]];
        y+=newg+LINE_PAD;
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,LINE_HEIGHT)];
        [l setFont:[UIFont systemFontOfSize:FONT_M]];
        [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [l sizeToFit];
        y+=l.frame.size.height;
        {
            NSString *dateString =[[datasrc objectAtIndex:indexPath.row] objectForKey:@"startdate"];
            if (![[[datasrc objectAtIndex:indexPath.row] objectForKey:@"startdate"] isEqualToString:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"enddate"]]) {
                dateString = [NSString stringWithFormat:@"%@ - %@",[[datasrc objectAtIndex:indexPath.row] objectForKey:@"startdate"],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"enddate"]];
            }
            UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
            [m setFont:[UIFont systemFontOfSize:FONT_S]];
            [m setText:dateString];
            [m sizeToFit];
            y+=m.frame.size.height;
        }
        {
            NSString *timeString =[[datasrc objectAtIndex:indexPath.row] objectForKey:@"starttime"];
            if (![[[datasrc objectAtIndex:indexPath.row] objectForKey:@"endtime"] isEqualToString:@""] &&
                ![[[datasrc objectAtIndex:indexPath.row] objectForKey:@"starttime"] isEqualToString:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"endtime"]]) {
                timeString = [NSString stringWithFormat:@"%@ - %@",[[datasrc objectAtIndex:indexPath.row] objectForKey:@"starttime"],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"endtime"]];
            }
            UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
            [m setFont:[UIFont systemFontOfSize:FONT_S]];
            [m setText:timeString];
            [m sizeToFit];
            y+=m.frame.size.height;
        }
        {
            UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
            [m setFont:[UIFont systemFontOfSize:FONT_S]];
            [m setText:[NSString stringWithFormat:@"%@: %@",TEXT_FEE, [[datasrc objectAtIndex:indexPath.row] objectForKey:@"fee"]]];
            [m sizeToFit];
            y+=m.frame.size.height + LINE_PAD;
        }
        y+=50+LINE_PAD+LINE_PAD;
        return y;
    } else {
        return UITableViewAutomaticDimension;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [datasrc count];
    } else {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_K_EVENT];
    
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
        CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
        CGFloat newg = h/w*(delegate.screenWidth-SIDE_PAD_2);
        int y = 0;
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,newg)];
        [v setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [v setImage:image];
        }]];
        [cell addSubview:v];
        y+=newg+LINE_PAD;
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
        [l setFont:[UIFont systemFontOfSize:FONT_M]];
        [l setTextColor:UICOLOR_GOLD];
        [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [l sizeToFit];
        [cell addSubview:l];
        y+=l.frame.size.height;
        {
            NSString *dateString =[[datasrc objectAtIndex:indexPath.row] objectForKey:@"startdate"];
            if (![[[datasrc objectAtIndex:indexPath.row] objectForKey:@"startdate"] isEqualToString:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"enddate"]]) {
                dateString = [NSString stringWithFormat:@"%@: %@ - %@",TEXT_DATE,[[datasrc objectAtIndex:indexPath.row] objectForKey:@"startdate"],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"enddate"]];
            }
            UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
            [m setFont:[UIFont systemFontOfSize:FONT_S]];
            [m setTextColor:[UIColor darkTextColor]];
            [m setText:dateString];
            [m sizeToFit];
            [cell addSubview:m];
            y+=m.frame.size.height;
        }
        {
            NSString *timeString =[[datasrc objectAtIndex:indexPath.row] objectForKey:@"starttime"];
            if (![[[datasrc objectAtIndex:indexPath.row] objectForKey:@"endtime"] isEqualToString:@""] &&
                ![[[datasrc objectAtIndex:indexPath.row] objectForKey:@"starttime"] isEqualToString:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"endtime"]]) {
                timeString = [NSString stringWithFormat:@"%@: %@ - %@",TEXT_TIME,[[datasrc objectAtIndex:indexPath.row] objectForKey:@"starttime"],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"endtime"]];
            }
            UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
            [m setFont:[UIFont systemFontOfSize:FONT_S]];
            [m setTextColor:[UIColor darkTextColor]];
            [m setText:timeString];
            [m sizeToFit];
            [cell addSubview:m];
            y+=m.frame.size.height + LINE_PAD;
        }
        {
            UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
            [m setFont:[UIFont systemFontOfSize:FONT_S]];
            [m setTextColor:[UIColor darkTextColor]];
            [m setText:[NSString stringWithFormat:@"%@: %@",TEXT_FEE, [[datasrc objectAtIndex:indexPath.row] objectForKey:@"fee"]]];
            [m sizeToFit];
            [cell addSubview:m];
            y+=m.frame.size.height + LINE_PAD;
        }
        UIButton *bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
        [bookNow setBackgroundColor:[delegate getThemeColor]];
        [bookNow setFrame:CGRectMake(delegate.screenWidth/2-75,y,150,50)];
        [bookNow.layer setCornerRadius:10.0f];
        bookNow.tag = indexPath.row;
        [bookNow addTarget:self action:@selector(book:) forControlEvents:UIControlEventTouchUpInside];
        [bookNow setTitle:TEXT_LEARN_MORE forState:UIControlStateNormal];
        [bookNow setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [cell addSubview:bookNow];
        
        y+=50+LINE_PAD;
    
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_REGISTER_EVENT];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_RENT_POPUP];
            [cell.detailTextLabel setText:@""];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_RENT_EVENT_SPACE];
            [cell.detailTextLabel setText:@""];
        } else {
            [cell.textLabel setText:TEXT_RENT_MEETING_ROOM];
            [cell.detailTextLabel setText:@""];
        }
        return cell;
    }
    return cell;
}
-(void)book:(UIButton *)b {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_DETAILS],[[datasrc objectAtIndex:b.tag]  objectForKey:@"ID"]] forKeys:@[@"type",@"eventID"]]];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_DETAILS],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"eventID"]]];
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_FACILITY],@"60"] forKeys:@[@"type",@"facilityID"]]];
        } else if (indexPath.row==1) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                  [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_FACILITY],@"61"] forKeys:@[@"type",@"facilityID"]]];
        } else if (indexPath.row==2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SEARCH_MEETING_ROOM]] forKeys:@[@"type"]]];
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

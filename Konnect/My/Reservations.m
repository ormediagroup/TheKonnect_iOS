//
//  Reservations.m
//  Konnect
//
//  Created by Jacky Mok on 11/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Reservations.h"
#import "AppDelegate.h"
@interface Reservations ()

@end

@implementation Reservations

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_RESERVATION];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-booking",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-fnb",
                                             ]
                                   forKeys:@[
                                             @"action",
                                             ]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                            
                                             [self.tableView beginUpdates];
                                             self->fbs = [data objectForKey:@"data"];
                                             NSRange range = NSMakeRange(0, 2);
                                             NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
                                             [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
                                             [self.tableView endUpdates];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-booking",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-events",
                                             ]
                                   forKeys:@[
                                             @"action",
                                             ]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                            
                                             [self.tableView beginUpdates];
                                             self->events = [data objectForKey:@"data"];
                                             [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationFade];
                                            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 1)] withRowAnimation:UITableViewRowAnimationFade];
                                             [self.tableView endUpdates];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-booking",
                                             ]
                                   forKeys:@[
                                             @"action",
                                             ]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             
                                             [self.tableView beginUpdates];
                                             self->meetings = [data objectForKey:@"data"];
                                             [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationFade];
                                             [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 1)] withRowAnimation:UITableViewRowAnimationFade];
                                             [self.tableView endUpdates];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        return [fbs count];
    } else if (section==2) {
        return [events count];
    } else if (section==3){
        return [meetings count];
    } else if (section==0) {
        if ([fbs count]==0 && [events count]==0 && [meetings count]==0) {
            return 1;
        }
    }
    return 0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat h = 0;
    if (section==0) return [super tableView:tableView heightForHeaderInSection:section];
    else if (section==1 && [fbs count]>0) h = 40;
    else if (section==2 && [events count]>0) h = 40;
    else if (section==3 && [meetings count]>0) h = 40;
    return h;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==3) return delegate.footerHeight;
    else return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section>0) {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,40)];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,40)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:UICOLOR_GOLD];
        if (section==1) {
            [v setText:TEXT_BOOK_RESTAURANT];
        } else if (section==2) {
            [v setText:TEXT_K_EVENT];
        } else if (section==3) {
            [v setText:TEXT_BOOK_MEETING_ROOM];
        }
        [h addSubview:v];
        return h;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension)];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        UIView *whiteBadge = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD_2,300)];
        UIImageView *logo  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        int y = 0;
        UILabel *name_zh = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_zh setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
        [name_zh setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_zh setNumberOfLines:-1];
        [name_zh sizeToFit];
        y+=name_zh.frame.size.height;
        
        UILabel *name_en = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_en setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"name_en"]];
        [name_en setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_en setNumberOfLines:-1];
        [name_en sizeToFit];
        y+=name_en.frame.size.height;
        
        UILabel *bookingdate = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingdate setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"bookingdate"]];
        [bookingdate setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingdate setNumberOfLines:-1];
        [bookingdate sizeToFit];
        y+=bookingdate.frame.size.height;
        
        
        UILabel *bookingtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingtime setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"bookingtime"]];
        [bookingtime setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingtime setNumberOfLines:-1];
        [bookingtime sizeToFit];
        y+=bookingtime.frame.size.height;
        y+=SIDE_PAD+LINE_HEIGHT; //for the num people
        return MAX(100+SIDE_PAD,y);
    } else if (indexPath.section==2) {
        UIView *whiteBadge = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD_2,300)];
        UIImageView *logo  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        int y = 0;
        UILabel *name_zh = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_zh setText:[[events objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [name_zh setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_zh setNumberOfLines:-1];
        [name_zh sizeToFit];
        y+=name_zh.frame.size.height;
        
        UILabel *bookingdate = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingdate setText:[[events objectAtIndex:indexPath.row] objectForKey:@"datestring"]];
        [bookingdate setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingdate setNumberOfLines:-1];
        [bookingdate sizeToFit];
        y+=bookingdate.frame.size.height;
        
        
        UILabel *bookingtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingtime setText:[[events objectAtIndex:indexPath.row] objectForKey:@"timestring"]];
        [bookingtime setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingtime setNumberOfLines:-1];
        [bookingtime sizeToFit];
        y+=bookingtime.frame.size.height;
        y+=SIDE_PAD+LINE_HEIGHT; //for the location
        return MAX(100+SIDE_PAD,y);
    } else if (indexPath.section==3) {
        UIView *whiteBadge = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD_2,300)];
        UIImageView *logo  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        int y = 0;
        UILabel *name_zh = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_zh setText:[[meetings objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
        [name_zh setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_zh setNumberOfLines:-1];
        [name_zh sizeToFit];
        y+=name_zh.frame.size.height;
        
        UILabel *bookingdate = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingdate setText:[[meetings objectAtIndex:indexPath.row] objectForKey:@"description"]];
        [bookingdate setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingdate setNumberOfLines:-1];
        [bookingdate sizeToFit];
        y+=bookingdate.frame.size.height;
        
        
        UILabel *bookingtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingtime setText:[[meetings objectAtIndex:indexPath.row] objectForKey:@"address"]];
        [bookingtime setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingtime setNumberOfLines:-1];
        [bookingtime sizeToFit];
        y+=bookingtime.frame.size.height;
        y+=SIDE_PAD+LINE_HEIGHT; //for the location
        return MAX(100+SIDE_PAD,y);
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEXT_RESERVATION];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==1) {
        UIView *whiteBadge = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD,300)];
        UIImageView *logo  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        [logo setImage:[delegate getImage:[[fbs objectAtIndex:indexPath.row] objectForKey:@"images"] callback:^(UIImage *image) {
            [logo setImage:image];
        }]];
    
        [logo setClipsToBounds:YES];
        [logo setContentMode:UIViewContentModeScaleAspectFill];
        [whiteBadge addSubview:logo];
        
        int y = 0;
        UILabel *name_zh = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_zh setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
        [name_zh setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_zh setTextColor:[UIColor darkTextColor]];
        [name_zh setNumberOfLines:-1];
        [name_zh sizeToFit];
        [whiteBadge addSubview:name_zh];
        
        y+=name_zh.frame.size.height;
        
        UILabel *name_en = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_en setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"name_en"]];
        [name_en setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_en setTextColor:[UIColor darkTextColor]];
        [name_en setNumberOfLines:-1];
        [name_en sizeToFit];
        y+=name_en.frame.size.height;
        [whiteBadge addSubview:name_en];
        
        UILabel *bookingdate = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                   y,
                                                                   whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                   30
                                                                   )];
        [bookingdate setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"bookingdate"]];
        [bookingdate setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingdate setTextColor:UICOLOR_GOLD];
        [bookingdate setNumberOfLines:-1];
        [bookingdate sizeToFit];
        [whiteBadge addSubview:bookingdate];
        y+=bookingdate.frame.size.height;
        
        
        UILabel *bookingtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingtime setText:[[fbs objectAtIndex:indexPath.row] objectForKey:@"bookingtime"]];
        [bookingtime setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingtime setTextColor:UICOLOR_GOLD];
        [bookingtime setNumberOfLines:-1];
        [bookingtime sizeToFit];
        [whiteBadge addSubview:bookingtime];
        y+=bookingtime.frame.size.height;
        
        UILabel *bookingppl = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingppl setText:[NSString stringWithFormat:@"%@ %@%@",TEXT_CAPACITY,[[fbs objectAtIndex:indexPath.row] objectForKey:@"reservation"],TEXT_PEOPLE]];
        [bookingppl setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingppl setTextColor:UICOLOR_GOLD];
        [bookingppl setNumberOfLines:-1];
        [bookingppl sizeToFit];
        [whiteBadge addSubview:bookingppl];
        y+=bookingppl.frame.size.height;
        y+=SIDE_PAD;
        
        
        y+=SIDE_PAD;
        [whiteBadge setFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,y)];
        [cell addSubview:whiteBadge];
        
        
    } else if (indexPath.section==2) {
        UIView *whiteBadge = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD,300)];
        UIImageView *logo  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        [logo setImage:[delegate getImage:[[[events objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [logo setImage:image];
        }]];
        
        [logo setClipsToBounds:YES];
        [logo setContentMode:UIViewContentModeScaleAspectFill];
        [whiteBadge addSubview:logo];
        
        int y = 0;
        UILabel *name_zh = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_zh setText:[[events objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [name_zh setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_zh setTextColor:[UIColor darkTextColor]];
        [name_zh setNumberOfLines:-1];
        [name_zh sizeToFit];
        [whiteBadge addSubview:name_zh];
        
        y+=name_zh.frame.size.height;
        
        
        UILabel *bookingdate = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingdate setText:[[events objectAtIndex:indexPath.row] objectForKey:@"datestring"]];
        [bookingdate setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingdate setTextColor:UICOLOR_GOLD];
        [bookingdate setNumberOfLines:-1];
        [bookingdate sizeToFit];
        [whiteBadge addSubview:bookingdate];
        y+=bookingdate.frame.size.height;
        
        
        UILabel *bookingtime = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingtime setText:[[events objectAtIndex:indexPath.row] objectForKey:@"timestring"]];
        [bookingtime setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingtime setTextColor:UICOLOR_GOLD];
        [bookingtime setNumberOfLines:-1];
        [bookingtime sizeToFit];
        [whiteBadge addSubview:bookingtime];
        y+=bookingtime.frame.size.height;
        
        UILabel *bookingppl = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                        SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                        y,
                                                                        whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                        30
                                                                        )];
        [bookingppl setText:[[events objectAtIndex:indexPath.row] objectForKey:@"location"]];
        [bookingppl setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingppl setTextColor:UICOLOR_GOLD];
        [bookingppl setNumberOfLines:-1];
        [bookingppl sizeToFit];
        [whiteBadge addSubview:bookingppl];
        y+=bookingppl.frame.size.height;
        y+=SIDE_PAD;
        
        
        y+=SIDE_PAD;
        [whiteBadge setFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,y)];
        [cell addSubview:whiteBadge];
    } else if (indexPath.section==3) {
        UIView *whiteBadge = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD,300)];
        UIImageView *logo  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        [logo setImage:[delegate getImage:[[meetings objectAtIndex:indexPath.row] objectForKey:@"images"] callback:^(UIImage *image) {
            [logo setImage:image];
        }]];
        
        [logo setClipsToBounds:YES];
        [logo setContentMode:UIViewContentModeScaleAspectFill];
        [whiteBadge addSubview:logo];
        
        int y = 0;
        UILabel *name_zh = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                     SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                     y,
                                                                     whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                     LINE_HEIGHT
                                                                     )];
        [name_zh setText:[[meetings objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
        [name_zh setFont:[UIFont systemFontOfSize:FONT_M]];
        [name_zh setTextColor:[UIColor darkTextColor]];
        [name_zh setNumberOfLines:-1];
        [name_zh sizeToFit];
        [whiteBadge addSubview:name_zh];
        
        y+=name_zh.frame.size.height;
        
        
        UILabel *bookingdate = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                         y,
                                                                         whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                         30
                                                                         )];
        [bookingdate setText:[[meetings objectAtIndex:indexPath.row] objectForKey:@"description"]];
        [bookingdate setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingdate setTextColor:UICOLOR_GOLD];
        [bookingdate setNumberOfLines:-1];
        [bookingdate sizeToFit];
        [whiteBadge addSubview:bookingdate];
        y+=bookingdate.frame.size.height;
        
        
        UILabel *bookingppl = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                        SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                        y,
                                                                        whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                        30
                                                                        )];
        [bookingppl setText:[[meetings objectAtIndex:indexPath.row] objectForKey:@"address"]];
        [bookingppl setFont:[UIFont systemFontOfSize:FONT_S]];
        [bookingppl setTextColor:UICOLOR_GOLD];
        [bookingppl setNumberOfLines:-1];
        [bookingppl sizeToFit];
        [whiteBadge addSubview:bookingppl];
        y+=bookingppl.frame.size.height;
        y+=SIDE_PAD;
        
        
        y+=SIDE_PAD;
        [whiteBadge setFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,y)];
        [cell addSubview:whiteBadge];
    }
    // Configure the cell...
    
    return cell;
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

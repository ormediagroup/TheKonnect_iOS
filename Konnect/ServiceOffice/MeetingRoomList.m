//# This file is deprecated as of Version 1.2 functio not needed
//
//  MeetingRoomList.m
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "MeetingRoomList.h"
#import "AppDelegate.h"
@interface MeetingRoomList ()

@end

@implementation MeetingRoomList
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_SERVICE_OFFICE_DESCRIPTION];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[@"1990-01-01",[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0]]
                                   forKeys:@[@"bookingdate",@"bookingstarttime",@"bookingendtime"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"available"];
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:@""];
                                         }
                                     }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasrc count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_SERVICE_OFFICE_DESCRIPTION];
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
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2+60,0,delegate.screenWidth-SIDE_PAD_2-70-SIDE_PAD,LINE_HEIGHT)];
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
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MEETING_ROOM],[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"room"]objectForKey:@"ID"]] forKeys:@[@"type",@"facilityID"]]];
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

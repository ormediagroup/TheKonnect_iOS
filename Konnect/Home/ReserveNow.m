
//
//  ReserveNow.m
//  Konnect
//
//  Created by Jacky Mok on 9/12/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ReserveNow.h"
#import "AppDelegate.h"
@interface ReserveNow ()

@end

@implementation ReserveNow

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewWillAppear:(BOOL)animated {
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[@"get-reservation-now",@"fnb"]
                                   forKeys:@[@"action",@"type"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
                                             self->events = [data objectForKey:@"events"];
                                             self->fnb = [data objectForKey:@"vendors"];
                                             self->rooms = [data objectForKey:@"available"];
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:@""];
                                         }
                                     }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [fnb count];
    } else if (section==1) {
        return [events count];
    } else if (section==2) {
        return [rooms count];
    }
    return 0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEXT_RESERVATION];
    UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    [i setContentMode:UIViewContentModeScaleAspectFill];
    [i setClipsToBounds:YES];
    [cell addSubview:i];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(110,0,delegate.screenWidth-SIDE_PAD-110,100)];
    [l setFont:[UIFont systemFontOfSize:FONT_S]];
    [cell addSubview:l];
    if (indexPath.section==0) {
        [i setImage:[delegate getImage:[[fnb objectAtIndex:indexPath.row] objectForKey:@"images"] callback:^(UIImage *image) {
            [i setImage:image];
        }]];
        [l setText:[[fnb objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
    } else  if (indexPath.section==1) {
        [i setImage:[delegate getImage:[[[events objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [i setImage:image];
        }]];
        [l setText:[[events objectAtIndex:indexPath.row] objectForKey:@"title"]];
    } else  if (indexPath.section==2) {
        [i setImage:[delegate getImage:[[[rooms objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"images"] callback:^(UIImage *image) {
            [i setImage:image];
        }]];
        [l setText:[[[rooms objectAtIndex:indexPath.row] objectForKey:@"room"] objectForKey:@"name_zh"]];
    }
    
    // Configure the cell...
    
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight+30;
    }
    return 30;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return delegate.footerHeight;
    }
    return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight+30)];
        [h setBackgroundColor:UICOLOR_GOLD];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth-SIDE_PAD,30)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_XS]];
        [v setTextColor:[UIColor whiteColor]];
        [v setText:TEXT_FNB];
        [h addSubview:v];
        return h;
    } else {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,30)];
        [h setBackgroundColor:UICOLOR_GOLD];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,30)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_XS]];
        [v setTextColor:[UIColor whiteColor]];
        [h addSubview:v];
        if (section==1) {
            [v setText:TEXT_K_EVENT];
        } else {
            [v setText:TEXT_MEETING_ROOM];
        }
        return h;
        
    }
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_FACILITY],[[fnb objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"facilityID"]]];
    } else if (indexPath.section==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_DETAILS],[[events objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"eventID"]]];
    } else if (indexPath.section==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MEETING_ROOM],[[[rooms objectAtIndex:indexPath.row] objectForKey:@"room"]objectForKey:@"ID"]] forKeys:@[@"type",@"facilityID"]]];
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

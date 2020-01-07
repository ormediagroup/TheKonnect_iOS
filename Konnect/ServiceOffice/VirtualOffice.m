//
//  VirtualOffice.m
//  Konnect
//
//  Created by Jacky Mok on 25/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "VirtualOffice.h"
#import "AppDelegate.h"
@interface VirtualOffice ()

@end

@implementation VirtualOffice
@synthesize officeID;
- (void)viewDidLoad {
    [super viewDidLoad];
    fields = @[TEXT_COMPANY,TEXT_ADDRESS, TEXT_OFFICE_ROOM_LEASE_END,TEXT_NOTIFICATION];
    map = @[@"company_zh",@"address",@"lease_end",@""];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_MY_VIRTUAL_OFFICE];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-service-office",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"get-virtual-office",officeID]
                                                                              forKeys:@[@"action",@"officeID"]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }
     ];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [map count];
    } else {
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight;
    } else {
        return LINE_PAD;;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1) {
        return delegate.footerHeight;
    }
    return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
    } else {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_PAD)];
        [h setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        return h;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_SERVICE_OFFICE];
    [cell setBackgroundColor:[UIColor whiteColor]];
       [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
       [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section==0) {
        [cell.textLabel setText:[fields objectAtIndex:indexPath.row]];
        [cell.detailTextLabel setText:[datasrc objectForKey:[map objectAtIndex:indexPath.row]]];
        if (indexPath.row==([fields count]-1)) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    } else {
    }
    // Configure the cell...
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==([fields count]-1)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_OFFICE_NOTIFICATION]] forKeys:@[@"type"]]];
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

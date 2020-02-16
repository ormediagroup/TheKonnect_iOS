//
//  AboutKonnect.m
//  Konnect
//
//  Created by Jacky Mok on 10/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "AboutKonnect.h"
#import "AppDelegate.h"
@interface AboutKonnect ()

@end

@implementation AboutKonnect
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_K_NEWS];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[@"get-about"]
                                   forKeys:@[@"action"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             self->marketingKit = [data objectForKey:@"marketingkit"];
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
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    } else {
        return delegate.footerHeight;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
        CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
        CGFloat newg = h/w*(delegate.screenWidth);
        return newg;
    } else {
        return UITableViewAutomaticDimension;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
        [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
        CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
        CGFloat newg = h/w*(delegate.screenWidth-SIDE_PAD_2);
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,newg)];
        [v setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [v setImage:image];
        }]];
        [cell addSubview:v];
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_CS];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
        [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_DL_K_MARKETING];
            [cell.detailTextLabel setText:@""];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_DL_K_PERSONAL_FORM];
            [cell.detailTextLabel setText:@""];
        } else {
            [cell.textLabel setText:TEXT_DL_K_CORPORATE_FORM];
            [cell.detailTextLabel setText:@""];
        }
        return cell;
    }
    
    
    // Configure the cell...
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *pURL1 = self->marketingKit;
    NSString *pURL2 = @"http://thekonnect.com.hk/wp-content/uploads/2019/10/Privacy-Statement-EngVersion_20191015.pdf";
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL1]])
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL1]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL1] options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:pURL2]])
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pURL2] options:@{}completionHandler:^(BOOL success) {
                    
                }];
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

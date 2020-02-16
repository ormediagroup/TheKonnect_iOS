//
//  ServiceOffice.m
//  Konnect
//
//  Created by Jacky Mok on 7/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ServiceOffice.h"
#import "AppDelegate.h"
#import "const.h"
#import "ORCarousel.h"
#define SERVICE_OFFICE_CAROUSEL_HEIGHT 260
@interface ServiceOffice ()

@end

@implementation ServiceOffice
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_SERVICE_OFFICE];
    if (![delegate isLoggedIn]) {
        datasrc = [NSDictionary dictionaryWithObject:@[@[],@[]]  forKey:@[@"company",@"office"] ];
        [self.tableView reloadData];
    } else {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-service-office",K_API_ENDPOINT] param:nil interation:0 callback:^(NSDictionary *data) {
            if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
                self->datasrc = data;
            } else {
            }
            [self.tableView reloadData];
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    carousel = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,SERVICE_OFFICE_CAROUSEL_HEIGHT)];
    oc = [[ORCarousel alloc] initWithNibName:nil bundle:nil withFrame:CGRectMake(0, 0, self->delegate.screenWidth, SERVICE_OFFICE_CAROUSEL_HEIGHT)];
    [carousel addSubview:oc.view];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:nil interation:0 callback:^(NSDictionary *data) {
        if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
            if ([[data objectForKey:@"top"] isKindOfClass:[NSArray class]]) {
                [self->oc pack:[data objectForKey:@"serviceoffice"]];
                [self.tableView reloadData];
            }
        } else {
            [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:@""];
        }
    }];
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
    /*
    if (section==1) {
        return [[datasrc objectForKey:@"company"] count];
    } else if (section==2) {
        return [[datasrc objectForKey:@"office"] count];
    } else if (section==3) {*/
    if (section==1) {
        return 11;
    }
    return 1;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight;
        /*
    } else if (section==1 && [[datasrc objectForKey:@"company"] count]>0) {
        return UITableViewAutomaticDimension+LINE_PAD;
    } else if (section==2 && [[datasrc objectForKey:@"office"] count]>0) {
        return UITableViewAutomaticDimension+LINE_PAD;*/
    } else {
        return 0;
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
        /*
    } else if (section==1|| section==2){
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension+LINE_PAD)];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,LINE_PAD,delegate.screenWidth-SIDE_PAD,UITableViewAutomaticDimension)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_XS]];
        [v setTextColor:[UIColor lightGrayColor]];
        if (section==1) {
            [v setText:TEXT_COMPANY_INFO];
        } else if (section==2) {
            [v setText:TEXT_SERVICE_OFFICE];
        }
        [h addSubview:v];
        return h;*/
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension)];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@"ServiceOffice"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section==0) {
        [cell addSubview:carousel];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        /*
    } else if (indexPath.section==1) {
        [cell.textLabel setText:[[[datasrc objectForKey:@"company"] objectAtIndex:indexPath.row] objectForKey:@"company_zh"]];
    } else if (indexPath.section==2) {
        [cell.textLabel setText:[[[datasrc objectForKey:@"office"] objectAtIndex:indexPath.row] objectForKey:@"room"]];
        */
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_MY_OFFICE];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_MY_VIRTUAL_OFFICE];
        } else if (indexPath.row==2) {
            [cell.textLabel setText:TEXT_KONNECT_CONCERIGE];
        } else if (indexPath.row==3) {
            [cell.textLabel setText:TEXT_BOOK_MEETING_ROOM];
        } else if (indexPath.row==4) {
            [cell.textLabel setText:TEXT_BOOK_POPUP_LOUNGE];
        } else if (indexPath.row==5) {
            [cell.textLabel setText:TEXT_BOOK_POLYFORM_EVENT];
        } else if (indexPath.row==6) {
            [cell.textLabel setText:TEXT_PROMO];
        } else if (indexPath.row==7) {
            [cell.textLabel setText:TEXT_INVOICE];
        } else if (indexPath.row==8) {
            [cell.textLabel setText:TEXT_CS];
        } else if (indexPath.row==9) {
            [cell.textLabel setText:TEXT_SERVICE_OFFICE_TOU];
        } else if (indexPath.row==10) {
            [cell.textLabel setText:TEXT_SERVICE_VIRTUAL_TOU];
        }
    }
    
    // Configure the cell...
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.section==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_COMPANY],[[[datasrc objectForKey:@"company"] objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"companyID"]]];
    } else  if (indexPath.section==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_OFFICE],[[[datasrc objectForKey:@"office"] objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"officeID"]]];
    } else if (indexPath.section==3) {
     */
        if (indexPath.row==0) {
            if ([delegate checkLogin]) {
                if ([[datasrc objectForKey:@"office"] isKindOfClass:[NSArray class]] &&
                    [[datasrc objectForKey:@"office"] count]>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_OFFICE],[[[datasrc objectForKey:@"office"] objectAtIndex:0] objectForKey:@"ID"]] forKeys:@[@"type",@"officeID"]]];
                } else {
                    [delegate raiseAlert:TEXT_NO_SERVICE_OFFICE msg:@""];
                }
            }
            /*
            if ([delegate checkLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                 [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_INVOICES],TEXT_INVOICE_TYPE_PENDING] forKeys:@[@"type",@"status"]]];
            }*/
        } else if (indexPath.row==1) {
            if ([delegate checkLogin]) {
                if ([[datasrc objectForKey:@"virtualoffice"] isKindOfClass:[NSArray class]] &&
                    [[datasrc objectForKey:@"virtualoffice"] count]>0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_VIRTUAL_OFFICE],[[[datasrc objectForKey:@"virtualoffice"] objectAtIndex:0] objectForKey:@"ID"]] forKeys:@[@"type",@"officeID"]]];
                } else {
                    [delegate raiseAlert:TEXT_NO_VIRTUAL_OFFICE msg:@""];
                }
            }
        } else if (indexPath.row==2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_CONCIERGE]] forKeys:@[@"type"]]];
        } else if (indexPath.row==3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SEARCH_MEETING_ROOM]] forKeys:@[@"type"]]];
        } else if (indexPath.row==4) {
             [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                        [[NSDictionary alloc] initWithObjects:@[
                                                                [NSNumber numberWithInt:VC_TYPE_MEETING_ROOM],
                                                                TEXT_POPUP_LOUNGE_ID,
                                                                @"view"
                                                                ]
                                                      forKeys:@[@"type",@"facilityID",@"queryType"]]];
        } else if (indexPath.row==5) {            
                        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                                   [[NSDictionary alloc] initWithObjects:@[
                                                                           [NSNumber numberWithInt:VC_TYPE_MEETING_ROOM],
                                                                           TEXT_POLYFORM_EVENT_ID,
                                                                           @"view"
                                                                           ]
                                                                 forKeys:@[@"type",@"facilityID",@"queryType"]]];
        } else if (indexPath.row==6) {
            // promo
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_OFFICE_PROMO]] forKeys:@[@"type"]]];
            
        } else if (indexPath.row==7) {
            if ([delegate checkLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                 [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_INVOICES],TEXT_INVOICE_TYPE_PENDING] forKeys:@[@"type",@"status"]]];
            }
        } else if (indexPath.row==8) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_CONTACT_OFFICE],TEXT_INQUIRY_SERVICE_OFFICE_SUPPORT] forKeys:@[@"type",@"inquirytype"]]];
        } else if (indexPath.row==9) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_TOU],[NSString stringWithFormat:@"%@service-office-house-rules/",domain]] forKeys:@[@"type",@"url"]]];
        } else if (indexPath.row==10) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_TOU],[NSString stringWithFormat:@"%@virtual-office-house-rules/",domain]] forKeys:@[@"type",@"url"]]];
            
        }
  //  }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return SERVICE_OFFICE_CAROUSEL_HEIGHT;
    }
    return UITableViewAutomaticDimension;
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

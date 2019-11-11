//
//  My.m
//  Konnect
//
//  Created by Jacky Mok on 4/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "My.h"
#import "AppDelegate.h"
@interface My ()

@end

@implementation My

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.tableView setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    labels = @[@"我的資料",@"我的錢包",@"積分記錄",@"預約記錄",TEXT_COUPON,TEXT_SERVICE_OFFICE,TEXT_REFERRAL_QR];
    iconsrc = @[@"editinfo.png",@"waller.png",@"pointshistory.png",@"appointments.png",@"coupons.png",@"office.png",@"referral.png"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@"我的"];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [super viewWillAppear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 8;
    else if (section==1) return 0;
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight;
    } else {
        return LINE_PAD;
    }
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return delegate.footerHeight+LINE_PAD;
    } else {
        return LINE_PAD;
    }
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.footerHeight)];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        return 100;
    } else {
        return LINE_HEIGHT+LINE_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"my"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section==0 && indexPath.row>0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD+50,0,delegate.screenWidth-50-SIDE_PAD_2,LINE_HEIGHT+LINE_HEIGHT)];
        [title setText:[labels objectAtIndex:(indexPath.row-1)]];
        [title setTextColor:[UIColor darkGrayColor]];
        [cell addSubview:title];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconsrc objectAtIndex:(indexPath.row-1)]]];
        [icon setFrame:CGRectMake(SIDE_PAD,0,30,title.frame.size.height)];
        [icon setContentMode:UIViewContentModeScaleAspectFit];
        [cell addSubview:icon];
        
    } else if (indexPath.section==2) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_HEIGHT+LINE_HEIGHT)];
        [title setText:@"退出登錄"];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont systemFontOfSize:FONT_L]];
        [title setTextColor:UICOLOR_GOLD];
        [cell addSubview:title];
        
    }
    
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MY_EDITINFO]] forKeys:@[@"type"]]];
        } else if (indexPath.row==2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MY_WALLET]] forKeys:@[@"type"]]];
        } else if (indexPath.row==3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_POINT_HISTORY]] forKeys:@[@"type"]]];
        } else if (indexPath.row==4) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_RESERVATIONS]] forKeys:@[@"type"]]];
        } else if (indexPath.row==5) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_COUPON]] forKeys:@[@"type"]]];
        } else if (indexPath.row==6) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SERVICE_OFFICE]] forKeys:@[@"type"]]];
        } else if (indexPath.row==7) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_REFERER_QR]] forKeys:@[@"type"]]];
        }
        
    } if (indexPath.section==2) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"你確定要退出登錄?"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        UIAlertAction* logout = [UIAlertAction actionWithTitle:@"退出登錄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self->delegate logout];
        }];
        [alert addAction:logout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        
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

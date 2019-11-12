//
//  AssoPIcker.m
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "AssoPIcker.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
@implementation AssoPIcker
@synthesize parent;
- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.tableView setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    selected = [[NSMutableArray alloc] initWithCapacity:3];
    fields = @[
                CLUB_1,
                CLUB_2,
                CLUB_3,
                CLUB_4,
                CLUB_5,
                CLUB_6,
                CLUB_7,
                CLUB_8,
                CLUB_9,
                CLUB_10,
                CLUB_11,
                CLUB_12,
                CLUB_13,
                CLUB_14,
                CLUB_15
                CLUB_16,
                CLUB_17,
                CLUB_18,
                CLUB_19,
                CLUB_20,
                
               ];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@""];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [super viewWillAppear:animated];
}

-(void)back {
    if ([selected count]==0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_AT_LEAST_1
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_SELECT_AGAIN style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        UIAlertAction* cal = [UIAlertAction actionWithTitle:TEXT_NOT_ASSOC_MEMBER style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            parent.assoc = [selected componentsJoinedByString: @","];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
    } else {
        parent.assoc = [selected componentsJoinedByString: @","];
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
    [v setBackgroundColor:UICOLOR_PURPLE];
    UIButton *back = [UIButton  buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(SIDE_PAD,6,24,24)];
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [back setImage:[UIImage imageNamed:@"backbtnwhite.png"] forState:UIControlStateNormal];
    [back.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    [v addSubview:back];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0,6,delegate.screenWidth-SIDE_PAD,24)];
    [t setText:TEXT_MAX_3];
    [t setTextAlignment:NSTextAlignmentRight];
    [t setFont:[UIFont systemFontOfSize:FONT_XS]];
    [t setTextColor:[UIColor whiteColor]];
    [v addSubview:t];
    return v;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return [fields count];
    else return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assoc"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setText:[fields objectAtIndex:indexPath.row]];
    if ([selected containsObject:[fields objectAtIndex:indexPath.row]]) {
        [cell setBackgroundColor:UICOLOR_GOLD];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([selected containsObject:[fields objectAtIndex:indexPath.row]]) {
        [selected removeObject:[fields objectAtIndex:indexPath.row]];
    } else {
        if ([selected count]>=3) {
            [delegate raiseAlert:TEXT_MAX_3 msg:@"" inViewController:self];
        } else {
            [selected addObject:[fields objectAtIndex:indexPath.row]];
        }
    }
    [self.tableView  reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
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

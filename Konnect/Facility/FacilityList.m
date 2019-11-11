//
//  FacilityList.m
//  Konnect
//
//  Created by Jacky Mok on 7/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "FacilityList.h"
#import "AppDelegate.h"
#import "const.h"
#define FACILITIY_ROW_HEIGHT 250
@interface FacilityList ()

@end

@implementation FacilityList
@synthesize title;
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:title];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-vendors",
                                             @"fnb"
                                             ]
                                   forKeys:@[
                                             @"action",
                                             @"type"
                                             ]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             [self.tableView reloadData];
                                         } else if ([[data objectForKey:@"rc"] intValue]==1) {
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
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
    return FACILITIY_ROW_HEIGHT;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_FACILITY],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"facilityID"]]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"facilities"];
    if ([[[datasrc objectAtIndex:indexPath.row] objectForKey:@"type"] containsString:@"vip"]) {
        [cell setBackgroundColor:UICOLOR_GREEN];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,SIDE_PAD/2,delegate.screenWidth-SIDE_PAD_2,FACILITIY_ROW_HEIGHT-SIDE_PAD)];
    [i setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    if ([[[datasrc objectAtIndex:indexPath.row] objectForKey:@"images"] isKindOfClass:[NSString class]] && ![[[datasrc objectAtIndex:indexPath.row] objectForKey:@"images"] isEqualToString:@""]) {
        [i setImage:[delegate getImage:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"images"] callback:^(UIImage *image) {
            [i setImage:image];
        }]];
    }
    i.layer.cornerRadius =10.0f;
    [i setClipsToBounds:YES];
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,i.frame.size.width,LINE_HEIGHT)];
        [v setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        [i addSubview:v];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,i.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
        [l setTextColor:UICOLOR_GOLD];
        [l setFont:[UIFont boldSystemFontOfSize:FONT_XL]];
        [i addSubview:l];
        [cell addSubview:i];
        

    }
    {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,i.frame.size.height-LINE_HEIGHT,i.frame.size.width,LINE_HEIGHT)];
        [v setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
        [i addSubview:v];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,i.frame.size.height-LINE_HEIGHT,i.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"address"]];
        [l setTextAlignment:NSTextAlignmentRight];
        [l setTextColor:UICOLOR_GOLD];
        [l setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [i addSubview:l];
        [cell addSubview:i];
    }
    
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

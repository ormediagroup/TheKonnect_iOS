//
//  PastEventsList.m
//  Konnect
//
//  Created by Jacky Mok on 9/12/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "PastEventsList.h"
#import "AppDelegate.h"
@interface PastEventsList ()

@end

@implementation PastEventsList
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_PAST_ACTIVITIES];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-past-events",
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasrc count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TEXT_PAST_ACTIVITIES];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,0,140,100)];
    [img setClipsToBounds:YES];
    [img setContentMode:UIViewContentModeScaleAspectFill];
    [img setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
           [img setImage:image];
       }]];
    [img setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [cell addSubview:img];
   
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100+SIDE_PAD_2+SIDE_PAD_2,10,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2-100,20)];
    [l setFont:[UIFont systemFontOfSize:FONT_M]];
    [l setTextColor:UICOLOR_GOLD];
    [l setNumberOfLines:1];
    [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [cell addSubview:l];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(100+SIDE_PAD_2+SIDE_PAD_2,40,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2-100,20)];
    [t setFont:[UIFont systemFontOfSize:FONT_S]];
    [t setTextColor:[UIColor darkTextColor]];
    [t setNumberOfLines:1];
    [t setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [t setText:[NSString stringWithFormat:@"%@",[[datasrc objectAtIndex:indexPath.row] objectForKey:@"startdate"]]];
    [cell addSubview:t];
    
    UILabel *d = [[UILabel alloc] initWithFrame:CGRectMake(100+SIDE_PAD_2+SIDE_PAD_2,60,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2-100,20)];
    [d setFont:[UIFont systemFontOfSize:FONT_S]];
    [d setTextColor:[UIColor darkTextColor]];
    [d setNumberOfLines:1];
    [d setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [d setText:[NSString stringWithFormat:@"%lu %@",(unsigned long)[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"album"] count], TEXT_PAST_ACTIVITIES_PHOTO]];
    [cell addSubview:d];
   
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Configure the cell...
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_IMAGE_GALLERY],[[datasrc objectAtIndex:   indexPath.row] objectForKey:@"album"]] forKeys:@[@"type",@"images"]]];
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


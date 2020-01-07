//
//  EventList.m
//  Konnect
//
//  Created by Jacky Mok on 7/1/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "EventList.h"
#import "AppDelegate.h"
@interface EventList ()

@end
#define EVENT_BADGE_HEIGHT 500
@implementation EventList
@synthesize datasrc;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasrc count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EVENT_BADGE_HEIGHT+SIDE_PAD_2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEXT_K_EVENT];
    [cell setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,SIDE_PAD,delegate.screenWidth-SIDE_PAD_2,EVENT_BADGE_HEIGHT)];
    [box setBackgroundColor:[UIColor whiteColor]];
    box.layer.borderColor = [UICOLOR_VERY_LIGHT_GREY_BORDER CGColor];
    [cell addSubview:box];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,SIDE_PAD,box.frame.size.width-SIDE_PAD_2,350)];
    [img setBackgroundColor:UICOLOR_LIGHT_GREY];
    [img setClipsToBounds:YES];
    [img setContentMode:UIViewContentModeScaleAspectFill];
    [img setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
        [img setImage:image];
    }]];
    [box addSubview:img];
    
    int y = 350+LINE_PAD+LINE_PAD;
    int w = box.frame.size.width-SIDE_PAD_2;
    {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,w,LINE_PAD)];
        [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [l setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [l setTextColor:UICOLOR_GOLD];
        [l setNumberOfLines:1];
        [box addSubview:l];
        y+=LINE_PAD;
    }
    {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,w,LINE_PAD)];
        [l setText:[NSString stringWithFormat:@"%@ %@",TEXT_DATE,[[datasrc objectAtIndex:indexPath.row] objectForKey:@"datestring"]]];
        [l setFont:[UIFont systemFontOfSize:FONT_S]];
        [l setTextColor:[UIColor darkGrayColor]];
        [l setNumberOfLines:1];
        [box addSubview:l];
        y+=LINE_PAD;
    }
    {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,w,LINE_PAD)];
        [l setText:[NSString stringWithFormat:@"%@ %@",TEXT_ADDRESS,[[datasrc objectAtIndex:indexPath.row] objectForKey:@"location"]]];
        [l setFont:[UIFont systemFontOfSize:FONT_S]];
        [l setTextColor:[UIColor darkGrayColor]];
        [l setNumberOfLines:1];
        [box addSubview:l];
        y+=LINE_PAD;
    }
    {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,w,LINE_PAD)];
        [l setText:[NSString stringWithFormat:@"%@ %@",TEXT_FEE,[[datasrc objectAtIndex:indexPath.row] objectForKey:@"fee"]]];
        [l setFont:[UIFont systemFontOfSize:FONT_S]];
        [l setTextColor:[UIColor darkGrayColor]];
        [l setNumberOfLines:1];
        [box addSubview:l];
        y+=LINE_PAD;
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
          [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_DETAILS],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"eventID"]]];
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

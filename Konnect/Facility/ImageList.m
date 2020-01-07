//
//  ImageList.m
//  Konnect
//
//  Created by Jacky Mok on 14/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ImageList.h"
#import "ImageGallery.h"
#import "AppDelegate.h"
#define NUM_ITEMS 2

@interface ImageList ()

@end

@implementation ImageList
@synthesize datasrc;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) onBackPressed {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES
                                                            completion:^{
                                                                
                                                            }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ceil([datasrc count]*1.0/NUM_ITEMS);
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return delegate.screenWidth/NUM_ITEMS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PHOTO"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    /*cell.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.layer.borderWidth = 1.0f;
     */
    int start = (int)indexPath.row*NUM_ITEMS;
    int x = 0;
    for (int i = start; (i < (start + NUM_ITEMS) && i < [datasrc count]); i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(x,0,delegate.screenWidth/NUM_ITEMS, delegate.screenWidth/NUM_ITEMS)];
        [img setUserInteractionEnabled:YES];
        img.tag = i;
        [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)]];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [img setClipsToBounds:YES];
        [img setImage:[delegate getImage:[datasrc objectAtIndex:i] callback:^(UIImage *image) {
            [img setImage:image];
        }]];
        [cell addSubview:img];
        x+=delegate.screenWidth/NUM_ITEMS;
    }
    
    
    // Configure the cell...
    
    return cell;
}
-(void) imageTapped:(UITapGestureRecognizer *)tap {
    ImageGallery *g = [[ImageGallery alloc] initWithNibName:nil bundle:nil];
    [g setImages:datasrc];
    [self.view.window.rootViewController presentViewController:g animated:YES completion:^{
        ;
    }];
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

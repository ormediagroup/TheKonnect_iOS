//
//  ORViewController.m
//  Konnect
//
//  Created by Jacky Mok on 6/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
#import "AppDelegate.h"
@interface ORViewController ()

@end

@implementation ORViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight,delegate.screenWidth,delegate.screenHeight-delegate.headerHeight-delegate.footerHeight)];
    // Do any additional setup after loading the view.
    [scroll setBackgroundColor:[UIColor whiteColor]];
    [scroll setBounces:NO];
    [scroll setContentSize:CGSizeMake(delegate.screenWidth,delegate.screenHeight)];
}
-(void) viewWillAppear:(BOOL)animated {
    [self setEditing:NO];
}
-(void) viewWillDisappear:(BOOL)animated {
    [self setEditing:NO];
    
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+40, 0.0);
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    //[scroll setContentSize:CGSizeMake(delegate.screenWidth,delegate.screenHeight+kbSize.height+40)];
    // If active text field is hidden by keyboard, scroll it so it's visible.
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height+40);
    scroll.scrollEnabled = YES;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [scroll scrollRectToVisible:activeField.frame animated:YES];
    }
    
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    //  [scroll setContentSize:CGSizeMake(delegate.screenWidth,delegate.screenHeight)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

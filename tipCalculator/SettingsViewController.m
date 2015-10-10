//
//  SettingsViewController.m
//  tipCalculator
//
//  Created by Bing Chong Lim on 10/8/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTip;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Load the default settings to show on the settings page
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.defaultTip.selectedSegmentIndex = [defaults integerForKey:@"defaultTipIndex"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onValueChange:(UISegmentedControl *)sender {
    //Update settings whenever there is a change
    [self updateSettings];
}

- (void)updateSettings {
    //Update Settings by saving the change in defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.defaultTip.selectedSegmentIndex forKey:@"defaultTipIndex"];
    //Store the index for tip % to calculate tip difference when there is a change later on
    [defaults setInteger:self.defaultTip.selectedSegmentIndex forKey:@"previousTipIndex"];
    [defaults synchronize];
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

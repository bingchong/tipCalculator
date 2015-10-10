//
//  ViewController.m
//  tipCalculator
//
//  Created by Bing Chong Lim on 10/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountDifferenceMessage;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize the tip difference message to be transparent
    self.tipAmountDifferenceMessage.alpha = 0;
    self.title = @"Tip Calculator";
    [self updateValues];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
    [self updateValues];
    self.tipAmountDifferenceMessage.alpha = 0;
}
- (IBAction)onValueChange:(UISegmentedControl *)sender {
    [self updateValues];
    [self tipDifferenceAnimation];
}

- (void)updateValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Set currentBill value to the key 'previousBill'
    [defaults setFloat:[defaults floatForKey:@"currentBill"] forKey:@"previousBill"];
    //Update currentBill value to the updated bill value
    [defaults setFloat:[self.billTextField.text floatValue] forKey:@"currentBill"];
    [defaults synchronize];
    
    // Get the bill amount
    float billAmount = [self.billTextField.text floatValue];
    
    // Compute the tip and total
    NSArray *tipValues = @[@(0.15), @(0.2), @(0.25)];
    float tipAmount = [tipValues[self.tipControl.selectedSegmentIndex] floatValue] * billAmount;
    float totalAmount = billAmount + tipAmount;
    
    // Update the UI
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    //Load the settings and apply it to the first view load when user open the app
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tipControl.selectedSegmentIndex = [defaults integerForKey:@"defaultTipIndex"];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
    //Update tip amount and total value to reflect the new change in tip percentage
    [self updateValues];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"view will disappear");
    //Hide the tip difference message until the next change in tip amount
    self.tipAmountDifferenceMessage.alpha = 0;
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear");
}

- (void)tipDifferenceAnimation {
    NSArray *tipValues = @[@(0.15), @(0.2), @(0.25)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Optionally initialize the property to a desired starting value
    self.tipAmountDifferenceMessage.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        // Do calculations for tip difference and generate the message
        float previousAmount = [tipValues[[defaults integerForKey:@"previousTipIndex"]] floatValue] * [defaults floatForKey:@"previousBill"];
        float currentAmount = [tipValues[self.tipControl.selectedSegmentIndex] floatValue] * [defaults floatForKey:@"currentBill"];
        NSString *sign = @"+";
        if (currentAmount < previousAmount) {
            sign = @"-";
        }
        self.tipAmountDifferenceMessage.text = [NSString stringWithFormat:@"The change in tip amount is %@$%0.2f", sign, currentAmount-previousAmount];
        // Show the tip difference message
        self.tipAmountDifferenceMessage.alpha = 1;
        //Store the updated index
        [defaults setInteger:self.tipControl.selectedSegmentIndex forKey:@"previousTipIndex"];
    } completion:^(BOOL finished) {
        // Do something here when the animation finishes.
    }];

}

@end

//
//  InfoViewController.m
//  PonchiTimer
//
//  Created by papayabird on 2020/10/26.
//  Copyright © 2020 papayabird. All rights reserved.
//

#import "PCInfoViewController.h"
@interface PCInfoViewController ()

{
    __weak IBOutlet UIImageView *infoImageView;
    int index;
}

@end

@implementation PCInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    index = 0;
    if (@available(iOS 13.0, *)) {
        self.modalInPresentation = YES;
    } else {
        // Fallback on earlier versions
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }else{
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    }
    //
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    infoImageView.layer.cornerRadius = 5;
    infoImageView.layer.masksToBounds = YES;
    
    if (index == 0) {
        infoImageView.image = [UIImage imageNamed:@"Info1"];
        index++;
    }
}

- (IBAction)nextAction:(id)sender {
    if (index == 5) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else {
        infoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Info%i",index + 1]];
        index++;
    }
}

- (void)BGSetting {
    
//    infoImageView.backgroundColor = index
}

@end

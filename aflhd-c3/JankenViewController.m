//
//  JankenViewController.m
//  aflhd-c3
//
//  Created by KUMATA Tomokatsu on 11/19/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "JankenViewController.h"
#import "Konashi.h"

@interface JankenViewController () {
    int screenWidth, screenHeight;
    
    UIButton *gooButton;
    UIButton *chokiButton;
    UIButton *parButton;
}

@end

@implementation JankenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Konashi initialize];
    [[Konashi shared] setReadyHandler:^{
#ifdef DEBUG
        NSLog(@"Konashi Ready.");
#endif
    }];
    
    // MARK: Initial vars
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

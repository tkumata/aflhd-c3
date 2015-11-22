//
//  JankenViewController.m
//  aflhd-c3
//
//  Created by KUMATA Tomokatsu on 11/19/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "JankenViewController.h"
#import "Konashi.h"
#import <AVFoundation/AVFoundation.h>

@interface JankenViewController () {
    int screenWidth, screenHeight;
    
    UIButton *gooButton;
    UIButton *chokiButton;
    UIButton *parButton;
    UIButton *nextJankenButton;
    
    UILabel *talkLabel;
    
    UIButton *backButton;
}

@end

@implementation JankenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 背景画像の設定
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"12247660_893939417359933_6473737247774943716_o.jpg"]];
    
    [Konashi initialize];
    [[Konashi shared] setReadyHandler:^{
#ifdef DEBUG
        NSLog(@"Konashi Ready.");
#endif
    }];
    
    // MARK: Initial vars
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    
    // ボタン 1
    gooButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    gooButton.tag = 201;
    gooButton.frame = CGRectMake(10, screenHeight-40, screenWidth/3-20, 40);
    [[gooButton layer] setBorderWidth:1.0];
    [[gooButton layer] setCornerRadius:5.0];
    [[gooButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [[gooButton layer] setBackgroundColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [gooButton setTitle:[NSString stringWithFormat:@"グー"] forState:UIControlStateNormal];
    [gooButton addTarget:self action:@selector(result:) forControlEvents:UIControlEventTouchDown];
    [gooButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:gooButton];
    
    // ボタン 2
    chokiButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chokiButton.tag = 202;
    chokiButton.frame = CGRectMake(screenWidth/3+10, screenHeight-40, screenWidth/3-20, 40);
    [[chokiButton layer] setBorderWidth:1.0];
    [[chokiButton layer] setCornerRadius:5.0];
    [[chokiButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [[chokiButton layer] setBackgroundColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [chokiButton setTitle:[NSString stringWithFormat:@"チョキ"] forState:UIControlStateNormal];
    [chokiButton addTarget:self action:@selector(result:) forControlEvents:UIControlEventTouchDown];
    [chokiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:chokiButton];
    
    // ボタン 3
    parButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    parButton.tag = 203;
    parButton.frame = CGRectMake(screenWidth*2/3+10, screenHeight-40, screenWidth/3-20, 40);
    [[parButton layer] setBorderWidth:1.0];
    [[parButton layer] setCornerRadius:5.0];
    [[parButton layer] setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [[parButton layer] setBackgroundColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [parButton setTitle:[NSString stringWithFormat:@"パー"] forState:UIControlStateNormal];
    [parButton addTarget:self action:@selector(result:) forControlEvents:UIControlEventTouchDown];
    [parButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:parButton];
    
    // キャラクタのセリフ風なラベル
    talkLabel = [[UILabel alloc] init];
    talkLabel.tag = 301;
    talkLabel.frame = CGRectMake(40, 70, 500, screenHeight-140);
//    [[talkLabel layer] setBorderWidth:1.0];
//    [[talkLabel layer] setCornerRadius:5.0];
//    [[talkLabel layer] setBorderColor:[[UIColor grayColor] CGColor]];
    talkLabel.numberOfLines = 10;
    talkLabel.text = @"じゃーん、けん！";
    talkLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.];
    talkLabel.font = [UIFont boldSystemFontOfSize:60];
    
    // 再選ボタン
    nextJankenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextJankenButton.tag = 302;
    nextJankenButton.frame = CGRectMake(screenWidth/2, screenHeight/2, screenWidth/3, 60);
    [[nextJankenButton layer] setBorderWidth:3.0];
    [[nextJankenButton layer] setCornerRadius:5.0];
    [[nextJankenButton layer] setBorderColor:[[UIColor colorWithRed:1. green:0.74 blue:0. alpha:1.0] CGColor]];
    [[nextJankenButton layer] setBackgroundColor:[[UIColor colorWithRed:1. green:0.74 blue:0. alpha:1.0] CGColor]];
    [nextJankenButton setTitle:[NSString stringWithFormat:@"もういっかいやる"] forState:UIControlStateNormal];
    [nextJankenButton addTarget:self action:@selector(nextJanken) forControlEvents:UIControlEventTouchDown];
    [nextJankenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 戻るボタン
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.tag = 303;
    backButton.frame = CGRectMake(10, 10, screenWidth/3-20, 40);
    [[backButton layer] setBorderWidth:1.0];
    [[backButton layer] setCornerRadius:5.0];
    [[backButton layer] setBorderColor:[[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0] CGColor]];
//    [[backButton layer] setBackgroundColor:[[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0] CGColor]];
    [backButton setTitle:[NSString stringWithFormat:@"おわり"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitleColor:[UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    NSError *error = nil;
    NSString *path_win = [[NSBundle mainBundle] pathForResource:@"button84" ofType:@"mp3"];
    NSURL *url_win = [[NSURL alloc] initFileURLWithPath:path_win];
    self.audioPlayer_win = [[AVAudioPlayer alloc] initWithContentsOfURL:url_win error:&error];
    [self.audioPlayer_win setDelegate:self];
    
    NSString *path_lose = [[NSBundle mainBundle] pathForResource:@"button77" ofType:@"mp3"];
    NSURL *url_lose = [[NSURL alloc] initFileURLWithPath:path_lose];
    self.audioPlayer_lose = [[AVAudioPlayer alloc] initWithContentsOfURL:url_lose error:&error];
    [self.audioPlayer_lose setDelegate:self];
    
    NSString *path_aiko = [[NSBundle mainBundle] pathForResource:@"one01" ofType:@"mp3"];
    NSURL *url_aiko = [[NSURL alloc] initFileURLWithPath:path_aiko];
    self.audioPlayer_aiko = [[AVAudioPlayer alloc] initWithContentsOfURL:url_aiko error:&error];
    [self.audioPlayer_aiko setDelegate:self];

    // init screen
    [self initScreen];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init screen

- (void)initScreen {
    dispatch_async(dispatch_get_main_queue(),^{
        [self.view addSubview:gooButton];
        [self.view addSubview:chokiButton];
        [self.view addSubview:parButton];

        talkLabel.text = @"じゃーん、けん！";
        [self.view addSubview:talkLabel];
        
        // konashi のボタンが押されたか監視する
        [[Konashi shared] setDigitalInputDidChangeValueHandler:^(KonashiDigitalIOPin pin, int value) {
            if ([Konashi digitalRead:KonashiDigitalIO0] && value == 1) {
                [self result:@"グー"];
            }
            if ([Konashi digitalRead:KonashiDigitalIO3] && value == 1) {
                [self result:@"チョキ"];
            }
            if ([Konashi digitalRead:KonashiDigitalIO6] && value == 1) {
                [self result:@"パー"];
            }
        }];
    });
}

#pragma mark - Janken result screen

- (void)result:(id)sender {
    UIButton *btntmp = (UIButton*)sender;
    NSString *tmp = btntmp.currentTitle;
    int plyTe = 0;
    if ([tmp isEqualToString:@"グー"]) plyTe = 0;
    if ([tmp isEqualToString:@"チョキ"]) plyTe = 1;
    if ([tmp isEqualToString:@"パー"]) plyTe = 2;
    
    int comTe = arc4random_uniform(2);
    int result = (plyTe - comTe + 3) % 3;
    
    if (result == 0) {
        talkLabel.text = @"あいこ";
        [self.audioPlayer_aiko play];
    } else if (result == 2) {
        talkLabel.text = [NSString stringWithFormat:@"%@であなたのかち！", tmp];
        [self.audioPlayer_win play];
    } else {
        talkLabel.text = [NSString stringWithFormat:@"%@であなたのまけ！", tmp];
        [self.audioPlayer_lose play];
    }
    
    [[self.view viewWithTag:gooButton.tag] removeFromSuperview];
    [[self.view viewWithTag:chokiButton.tag] removeFromSuperview];
    [[self.view viewWithTag:parButton.tag] removeFromSuperview];
    [self.view addSubview:talkLabel];
    [self.view addSubview:nextJankenButton];
}

#pragma mark - Next janken

- (void)nextJanken {
    [[self.view viewWithTag:nextJankenButton.tag] removeFromSuperview];
    [[self.view viewWithTag:talkLabel.tag] removeFromSuperview];
    [self initScreen];
}

#pragma mark - Back

- (void)dismissView {
    [self dismissViewControllerAnimated:YES completion:nil];
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

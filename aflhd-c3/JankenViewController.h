//
//  JankenViewController.h
//  aflhd-c3
//
//  Created by KUMATA Tomokatsu on 11/19/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface JankenViewController : UIViewController <AVAudioPlayerDelegate>

@property(nonatomic) AVAudioPlayer *audioPlayer_win;
@property(nonatomic) AVAudioPlayer *audioPlayer_lose;
@property(nonatomic) AVAudioPlayer *audioPlayer_aiko;

@end

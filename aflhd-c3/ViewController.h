//
//  ViewController.h
//  aflhd-c3
//
//  Created by KUMATA Tomokatsu on 11/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVAudioPlayerDelegate>

@property(nonatomic) AVAudioPlayer *audioPlayer;
@property(nonatomic) AVAudioPlayer *audioPlayer2;
@property(nonatomic) AVAudioPlayer *audioPlayer3;

@end


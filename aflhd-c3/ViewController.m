//
//  ViewController.m
//  aflhd-c3
//
//  Created by KUMATA Tomokatsu on 11/18/15.
//  Copyright © 2015 KUMATA Tomokatsu. All rights reserved.
//

#import "ViewController.h"
#import "JankenViewController.h"
#import "Konashi.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "BEMAnalogClockView.h"

@interface ViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, BEMAnalogClockDelegate> {
    BOOL isConnected;
    int screenWidth, screenHeight;
    UIImage *charImg1;
    UIImage *charImg2;
    UIImage *charImg3;
    UIImage *charImg4;
    UIImage *charImg5;
    UIImage *charImg6;
    NSArray *aimg1;
    NSArray *knowledgeArray;
    
    UIImageView *titleClockImgView_dummy;
    UIImage *titleClockImg_dummy;
    UIImageView *titleCharImgView;
    UIImageView *titleStrImgView;
    UILabel *titleStrLabel;
    
    NSArray *selectShokuzaiKouhoArray;
    UIButton *selectShokuzaiButton1;
    UIButton *selectShokuzaiButton2;
    UIButton *selectShokuzaiButton3;
    UIImageView *selectShokuzaiImgView;
    UILabel *selectShokuzaiTalkLabel;
    UIImageView *selectShokuzaiImgView1;
    UIImageView *selectShokuzaiImgView2;
    UIImageView *selectShokuzaiImgView3;
    
    UILabel *sentShokuzaiTalkLabel;
    UIImageView *sentShokuzaiCharImg;
    UIButton *backClockButton;
    UIButton *toJankenButton;
    
    UILabel *sentKansoTalkLabel;
    UIImageView *sentKansoCharImg;
    
    BOOL isShokuzaiSelect;
    BEMAnalogClockView *myClock;
}

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
//    self.view.backgroundColor = [UIColor colorWithRed:0.878 green:1.0 blue:1.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 背景画像の設定
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellodot.png"]];
    
    [Konashi initialize];
    [[Konashi shared] setReadyHandler:^{
#ifdef DEBUG
        NSLog(@"Konashi Ready.");
#endif
    }];
    
    // MARK: Initial vars
    isShokuzaiSelect = YES;
    isConnected = NO;
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    
    knowledgeArray = @[\
                       @"ニンジンはアフガニスタン原産のセリ科ニンジン属の二年草。西洋系、東洋系の 2種類に分類できる。",\
                       @"ジャガイモは、ナス科ナス属の植物。地下茎を食品として利用する。",\
                       @"ピーマンはナス科の一年草、およびその果実。トウガラシの栽培品種に分類される。果肉は種子以外ほとんど空洞である。",\
                       @"リンゴの木は、落葉高木で晩春頃に白い 5弁花が開花する。リンゴの果実は直径約 3-15cm、重さ約 35-1000g。色は赤や黄緑または黄色をしている。熟するとヘプタコサンを含んだ蝋状の分泌物に覆われる。",\
                       @"カボチャは、ウリ科カボチャ属の総称である。特にその果実をいう。原産は南北アメリカ大陸。主要生産地は中国、インド、ウクライナ、アフリカ。果実を食用とし、カロテン、ビタミン類を多く含む緑黄色野菜。",\
                       @"タマネギは、ネギ属の多年草。園芸上では一年草もしくは二年草として扱われる。鱗茎、即ち葉は野菜として食用に利用される。色、形状、大きさは様々である。",\
                       @"ブドウは、ブドウ科のつる性落葉低木である。また、その果実のこと。葉は両側に切れ込みのある 15-20cm ほどの大きさで、穂状の花をつける。ブドウ属の植物は数十種あり、日本の山野に分布する、ヤマブドウ、エビヅル、サンカクヅルもブドウ属である。",\
                       @"オクラ(英語:okra)は、アオイ科トロロアオイ属の植物、またはその食用果実である。角オクラは 10cm、丸オクラは 15-20cm くらいに成長した段階の若い果実を食用とし、日本でも広く普及している。大きくなりすぎると繊維が発達して食感が悪くなり、食品価値を失う。"];
    
    // MARK: Set character images
    charImg1 = [UIImage imageNamed:@"fokun.png"];
    charImg2 = [UIImage imageNamed:@"gohankun.png"];
    charImg3 = [UIImage imageNamed:@"kumakurokun.png"];
    charImg4 = [UIImage imageNamed:@"pezumicyan.png"];
    charImg5 = [UIImage imageNamed:@"supun.png"];
    charImg6 = [UIImage imageNamed:@"usapyon.png"];
    aimg1 = [NSArray arrayWithObjects:charImg1, charImg2, charImg3, charImg4, charImg5, charImg6, nil];
    
    // MARK: 初期画面 100
    // 偽の時計 (未使用)
    titleClockImg_dummy = [UIImage imageNamed:@"clock.jpg"];
    titleClockImgView_dummy = [[UIImageView alloc] init];
    titleClockImgView_dummy.tag = 101;
    titleClockImgView_dummy.frame = CGRectMake(screenWidth/2-150, screenHeight/2-150, 300, 300);
    titleClockImgView_dummy.image = titleClockImg_dummy;
    
    // キャラクタ (未使用)
    titleCharImgView = [[UIImageView alloc] init];
    titleCharImgView.tag = 102;
    titleCharImgView.frame = CGRectMake(0, 0, 260, 260);
    titleCharImgView.image = charImg2;
    
    // タイトル副題的な (未使用)
    titleStrLabel = [[UILabel alloc] init];
    titleStrLabel.tag = 104;
    titleStrLabel.frame = CGRectMake(20, screenHeight-80, 260, 80);
    titleStrLabel.text = @"おいしいウォッチ\n\nなにがたべたいかえらんでね。";
    titleStrLabel.numberOfLines = 5;
    
    // タイトルロゴ画像 (未使用)
    titleStrImgView = [[UIImageView alloc] init];
    titleStrImgView.tag = 103;
    titleStrImgView.frame = CGRectMake(200, 0, 200, 200);
    
    // MARK: 食材候補画面 200
    // 食材選択ボタン 1
    selectShokuzaiButton1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectShokuzaiButton1.tag = 201;
    selectShokuzaiButton1.frame = CGRectMake(10, screenHeight-40, screenWidth/3-20, 40);
    [[selectShokuzaiButton1 layer] setBorderWidth:1.0];
    [[selectShokuzaiButton1 layer] setCornerRadius:5.0];
    [[selectShokuzaiButton1 layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [[selectShokuzaiButton1 layer] setBackgroundColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [selectShokuzaiButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 食材選択ボタン 2
    selectShokuzaiButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectShokuzaiButton2.tag = 202;
    selectShokuzaiButton2.frame = CGRectMake(screenWidth/3+10, screenHeight-40, screenWidth/3-20, 40);
    [[selectShokuzaiButton2 layer] setBorderWidth:1.0];
    [[selectShokuzaiButton2 layer] setCornerRadius:5.0];
    [[selectShokuzaiButton2 layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0] CGColor]];
    [[selectShokuzaiButton2 layer] setBackgroundColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [selectShokuzaiButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 食材選択ボタン 3
    selectShokuzaiButton3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectShokuzaiButton3.tag = 203;
    selectShokuzaiButton3.frame = CGRectMake(screenWidth*2/3+10, screenHeight-40, screenWidth/3-20, 40);
    [[selectShokuzaiButton3 layer] setBorderWidth:1.0];
    [[selectShokuzaiButton3 layer] setCornerRadius:5.0];
    [[selectShokuzaiButton3 layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0] CGColor]];
    [[selectShokuzaiButton3 layer] setBackgroundColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [selectShokuzaiButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 食材選択時のキャラクタ (未使用)
    selectShokuzaiImgView = [[UIImageView alloc] init];
    selectShokuzaiImgView.tag = 204;
    selectShokuzaiImgView.frame = CGRectMake(0, 0, 260, 260);
    selectShokuzaiImgView.animationImages = aimg1;
    selectShokuzaiImgView.animationDuration = 8.0f;
    
    // 食材選択時の文言
    selectShokuzaiTalkLabel = [[UILabel alloc] init];
    selectShokuzaiTalkLabel.tag = 205;
    selectShokuzaiTalkLabel.frame = CGRectMake(20, 20, screenWidth-40, 40);
    selectShokuzaiTalkLabel.text = @"なにがいいか、ボタンをおしてね。";
    [[selectShokuzaiTalkLabel layer] setBorderWidth:1.0];
    [[selectShokuzaiTalkLabel layer] setCornerRadius:5.0];
    [[selectShokuzaiTalkLabel layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0] CGColor]];
    [[selectShokuzaiTalkLabel layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
    selectShokuzaiTalkLabel.textAlignment = NSTextAlignmentCenter;
    selectShokuzaiTalkLabel.numberOfLines = 2;
    selectShokuzaiTalkLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    // 選択画面ボタンの上のキャラクタ 1
    selectShokuzaiImgView1 = [[UIImageView alloc] init];
    selectShokuzaiImgView1.tag = 206;
    selectShokuzaiImgView1.frame = CGRectMake(20, 90, screenWidth/3-20, screenWidth/3-20);
    
    // 選択画面ボタンの上のキャラクタ 2
    selectShokuzaiImgView2 = [[UIImageView alloc] init];
    selectShokuzaiImgView2.tag = 206;
    selectShokuzaiImgView2.frame = CGRectMake(screenWidth/3+10, 90, screenWidth/3-20, screenWidth/3-20);
    
    // 選択画面ボタンの上のキャラクタ 3
    selectShokuzaiImgView3 = [[UIImageView alloc] init];
    selectShokuzaiImgView3.tag = 206;
    selectShokuzaiImgView3.frame = CGRectMake(screenWidth*2/3+10, 90, screenWidth/3-20, screenWidth/3-20);
    
    // MARK: 食材送信後画面 300
    // キャラクタのセリフ風なラベル
    sentShokuzaiTalkLabel = [[UILabel alloc] init];
    sentShokuzaiTalkLabel.tag = 301;
    sentShokuzaiTalkLabel.frame = CGRectMake(40, 70, 260, screenHeight-80);
    [[sentShokuzaiTalkLabel layer] setBorderWidth:1.0];
    [[sentShokuzaiTalkLabel layer] setCornerRadius:5.0];
    [[sentShokuzaiTalkLabel layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [[sentShokuzaiTalkLabel layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
    sentShokuzaiTalkLabel.numberOfLines = 10;
    sentShokuzaiTalkLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    
    // キャラクタ
    sentShokuzaiCharImg = [[UIImageView alloc] init];
    sentShokuzaiCharImg.tag = 302;
    sentShokuzaiCharImg.frame = CGRectMake(screenWidth-260, screenHeight/2-140, 260, 260);
    sentShokuzaiCharImg.image = charImg5;
    sentShokuzaiCharImg.userInteractionEnabled = YES;
    
    // 時計へ戻るボタン
    backClockButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backClockButton.tag = 303;
    backClockButton.frame = CGRectMake(10, 10, screenWidth/3-20, 40);
    [[backClockButton layer] setBorderWidth:1.0];
    [[backClockButton layer] setCornerRadius:5.0];
    [[backClockButton layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [[backClockButton layer] setBackgroundColor:[[UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0] CGColor]];
    [backClockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // じゃんけんボタン
    toJankenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    toJankenButton.tag = 303;
    toJankenButton.frame = CGRectMake(screenWidth-50, screenHeight-50, 50, 50);
    [[toJankenButton layer] setBorderWidth:1.0];
    [[toJankenButton layer] setCornerRadius:5.0];
    [[toJankenButton layer] setBorderColor:[[UIColor colorWithRed:232.0 green:66.0 blue:53.0 alpha:0.] CGColor]];
    [toJankenButton setTitle:@"★" forState:UIControlStateNormal];
    [toJankenButton.titleLabel setFont:[UIFont systemFontOfSize:48]];
    [toJankenButton addTarget:self action:@selector(toJankenVC:) forControlEvents:UIControlEventTouchDown];
    [toJankenButton setTitleColor:[UIColor colorWithRed:1. green:0. blue:0. alpha:1.] forState:UIControlStateNormal];
    
    // MARK: 感想送信後画面 400
    // キャラクタのセリフ風なラベル
    sentKansoTalkLabel = [[UILabel alloc] init];
    sentKansoTalkLabel.tag = 401;
    sentKansoTalkLabel.frame = CGRectMake(screenWidth-280, 70, 260, screenHeight-80);
    [[sentKansoTalkLabel layer] setBorderWidth:1.0];
    [[sentKansoTalkLabel layer] setCornerRadius:5.0];
    [[sentKansoTalkLabel layer] setBorderColor:[[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0] CGColor]];
    [[sentKansoTalkLabel layer] setBackgroundColor:[[UIColor whiteColor] CGColor]];
    sentKansoTalkLabel.numberOfLines = 10;
    sentKansoTalkLabel.textColor = [UIColor colorWithRed:1. green:0. blue:0. alpha:1.];
    
    // キャラクタ
    sentKansoCharImg = [[UIImageView alloc] init];
    sentKansoCharImg.tag = 402;
    sentKansoCharImg.frame = CGRectMake(20, 20, 260, 260);
    sentKansoCharImg.image = charImg6;
    
    // MARK: MCSession initialize
    // Setup peer ID
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    // Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    // Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"owatch" session:self.mySession];
    // Setup Advertiser
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"owatch" discoveryInfo:nil session:self.mySession];
    // Start Adv
    self.browserVC.delegate = self;
    self.mySession.delegate = self;
    [self.advertiser start];
    
    // MARK: Sound config
    NSError *error = nil;
    // 遷移時の音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"button53" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.audioPlayer setDelegate:self];
    //
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"button77" ofType:@"mp3"];
    NSURL *url2 = [[NSURL alloc] initFileURLWithPath:path2];
    self.audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error];
    [self.audioPlayer2 setDelegate:self];
    
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"chime" ofType:@"mp3"];
    NSURL *url3 = [[NSURL alloc] initFileURLWithPath:path3];
    self.audioPlayer3 = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:&error];
    [self.audioPlayer3 setDelegate:self];
    
    // MARK: Clock setting
    myClock = [[BEMAnalogClockView alloc] initWithFrame:CGRectMake(screenWidth/2-150, screenHeight/2-150, 300, 300)];
    myClock.enableDigit = YES;
    myClock.realTime = YES;
    myClock.currentTime = YES;
    myClock.hourHandLength = 90;
    myClock.minuteHandLength = 125;
    myClock.secondHandLength = 110;
    myClock.digitColor = [UIColor colorWithRed:1.0 green:0.0 blue:0. alpha:1.0];
    myClock.faceBackgroundColor = [UIColor whiteColor];
    myClock.borderColor = [UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0];
    myClock.hourHandColor = [UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0];
    myClock.minuteHandColor = [UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0];
    myClock.secondHandColor = [UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0];
//    myClock.digitColor = [UIColor colorWithRed:0.90 green:0.26 blue:0.21 alpha:1.0];
//    myClock.faceBackgroundColor = [UIColor whiteColor];
//    myClock.borderColor = [UIColor colorWithRed:0.90 green:0.26 blue:0.21 alpha:1.0];
//    myClock.hourHandColor = [UIColor colorWithRed:0.90 green:0.26 blue:0.21 alpha:1.0];
//    myClock.minuteHandColor = [UIColor colorWithRed:0.90 green:0.26 blue:0.21 alpha:1.0];
//    myClock.secondHandColor = [UIColor colorWithRed:0.90 green:0.26 blue:0.21 alpha:1.0];
    myClock.delegate = self;
    
    // background
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(0, 0, screenWidth, screenHeight);
//    gradient.colors = @[(id)[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1].CGColor,
//                        (id)[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0].CGColor
//                        ];
//    [self.view.layer addSublayer:gradient];
    
    // Start init screen
    [self initScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)analogClock:(BEMAnalogClockView *)clock graduationColorForIndex:(NSInteger)index {
    if (!(index % 1) == 1) {
        return [UIColor colorWithRed:1.0 green:0. blue:0. alpha:1.0];
    } else {
        return [UIColor whiteColor];
    }
}

#pragma mark - Clear screen

- (void)clearScreenSubviews {
    dispatch_async(dispatch_get_main_queue(),^{
        for (UIView *v in self.view.subviews) {
            [v removeFromSuperview];
        }
//        [myClock stopRealTime];
    });
}

#pragma mark - 初期画面

- (void)initScreen {
    [self clearScreenSubviews];
    dispatch_async(dispatch_get_main_queue(),^{
        [self.view addSubview:toJankenButton];
        [self.view addSubview:myClock];
        [myClock startRealTime];
//        [self.view addSubview:titleClockImgView_dummy];
//        [self.view addSubview:titleCharImgView];
//        [self.view addSubview:titleStrImgView];
//        [self.view addSubview:titleStrLabel];
    });
}

#pragma mark - 選択画面

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    [self clearScreenSubviews];
    
    // append message to text box on main thread
    dispatch_async(dispatch_get_main_queue(),^{
        [self.audioPlayer play];

        // 重複しない 3つの乱数
        int i[3];
        int x;
        for (int l = 0; l < 3; l++) {
            i[l] = arc4random_uniform(5);
            x = i[l];
            for (l = 0; l < 3; l++) {
                if (i[l] == x) break;
            }
        }
        
        selectShokuzaiImgView1.image = aimg1[i[0]];
        [self.view addSubview:selectShokuzaiImgView1];
        selectShokuzaiImgView2.image = aimg1[i[1]];
        [self.view addSubview:selectShokuzaiImgView2];
        selectShokuzaiImgView3.image = aimg1[i[2]];
        [self.view addSubview:selectShokuzaiImgView3];
        
        [self.view addSubview:selectShokuzaiTalkLabel];
        [selectShokuzaiImgView startAnimating];
        
        // 親機から受信したデータをデコードする
        selectShokuzaiKouhoArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        // デコードしたデータをボタンに配置し、ボタンを表示する
        [selectShokuzaiButton1 setTitle:selectShokuzaiKouhoArray[0] forState:UIControlStateNormal];
        [selectShokuzaiButton1 addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:selectShokuzaiButton1];
        
        [selectShokuzaiButton2 setTitle:selectShokuzaiKouhoArray[1] forState:UIControlStateNormal];
        [selectShokuzaiButton2 addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:selectShokuzaiButton2];
        
        [selectShokuzaiButton3 setTitle:selectShokuzaiKouhoArray[2] forState:UIControlStateNormal];
        [selectShokuzaiButton3 addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:selectShokuzaiButton3];
        
        // 親機からのデータが食材なのか感想なのか判別する
        // 親機からのデータにこれが入ってないと判別不可能
        if ([selectShokuzaiKouhoArray[3] isEqualToString:@"__shokuzai__"]) {
            isShokuzaiSelect = YES;
        } else {
            isShokuzaiSelect = NO;
        }
        
        // konashi のボタンが押されたか監視する
        [[Konashi shared] setDigitalInputDidChangeValueHandler:^(KonashiDigitalIOPin pin, int value) {
            if ([Konashi digitalRead:KonashiDigitalIO0] && value == 1) {
                [self sendData2:selectShokuzaiKouhoArray[0]];
                NSLog(@"PIO 0");
            }
            if ([Konashi digitalRead:KonashiDigitalIO3] && value == 1) {
                [self sendData2:selectShokuzaiKouhoArray[1]];
                NSLog(@"PIO 3");
            }
            if ([Konashi digitalRead:KonashiDigitalIO6] && value == 1) {
                [self sendData2:selectShokuzaiKouhoArray[2]];
                NSLog(@"PIO 6");
            }
        }];
    });
}

#pragma mark - 送信

- (void)sendData:(id)sender {
    [self.audioPlayer play];
    [self clearScreenSubviews];
    
    UIButton *btntmp = (UIButton*)sender;
    NSString *tmp = btntmp.currentTitle;
    
    if (isShokuzaiSelect == YES) {
        sentShokuzaiTalkLabel.text = [NSString stringWithFormat:@"「%@」ってつたえたよ。", tmp];
    } else {
        sentKansoTalkLabel.text = [NSString stringWithFormat:@"「%@」ってつたえたよ。", tmp];
    }
    
    // 親機へ送るデータをエンコードする
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tmp];
    
    // 実際に送信する
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    // 送信後の画面を構築する
    if (isShokuzaiSelect == YES) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view addSubview:sentShokuzaiCharImg];
            [self.view addSubview:sentShokuzaiTalkLabel];
            [backClockButton setTitle:@"とけいにもどる" forState:UIControlStateNormal];
            [backClockButton addTarget:self action:@selector(initScreen) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:backClockButton];

        });
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view addSubview:sentKansoCharImg];
            [self.view addSubview:sentKansoTalkLabel];
            [backClockButton setTitle:@"とけいにもどる" forState:UIControlStateNormal];
            [backClockButton addTarget:self action:@selector(initScreen) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:backClockButton];
        });
    }
    
    // konashi のボタンが押されたか監視する
    [[Konashi shared] setDigitalInputDidChangeValueHandler:^(KonashiDigitalIOPin pin, int value) {
        if ([Konashi digitalRead:KonashiDigitalIO0] && value == 1) {
            [self changeText];
        }
        if ([Konashi digitalRead:KonashiDigitalIO3] && value == 1) {
            [self changeText];
        }
        if ([Konashi digitalRead:KonashiDigitalIO6] && value == 1) {
            [self changeText];
        }
    }];

}

#pragma mark - konashi SW による送信

- (void)sendData2:(NSString*)tmp {
    [self.audioPlayer play];
    [self clearScreenSubviews];
    
    // konashi SW の場合 sender 処理を抜かす
    
    if (isShokuzaiSelect == YES) {
        sentShokuzaiTalkLabel.text = [NSString stringWithFormat:@"「%@」ってつたえたよ。", tmp];
    } else {
        sentKansoTalkLabel.text = [NSString stringWithFormat:@"「%@」ってつたえたよ。", tmp];
    }
    
    // Convert to NSData
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tmp];
    
    // Send data to connected peer
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error:&error];
    
    if (isShokuzaiSelect == YES) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view addSubview:sentShokuzaiCharImg];
            [self.view addSubview:sentShokuzaiTalkLabel];
            [backClockButton setTitle:@"とけいにもどる" forState:UIControlStateNormal];
            [backClockButton addTarget:self action:@selector(initScreen) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:backClockButton];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(),^{
            [self.view addSubview:sentKansoCharImg];
            [self.view addSubview:sentKansoTalkLabel];
            [backClockButton setTitle:@"とけいにもどる" forState:UIControlStateNormal];
            [backClockButton addTarget:self action:@selector(initScreen) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:backClockButton];
        });
    }
    
    // konashi のボタンが押されたか監視する
    [[Konashi shared] setDigitalInputDidChangeValueHandler:^(KonashiDigitalIOPin pin, int value) {
        if ([Konashi digitalRead:KonashiDigitalIO0] && value == 1) {
            [self changeText];
        }
        if ([Konashi digitalRead:KonashiDigitalIO3] && value == 1) {
            [self changeText];
        }
        if ([Konashi digitalRead:KonashiDigitalIO6] && value == 1) {
            [self changeText];
        }
    }];
    
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if (touch.view.tag == sentShokuzaiCharImg.tag) {
        // タップ処理
        [self changeText];
    }
}

#pragma mark - 送信後画面で遊び 1

- (void)changeText {
    // キャラクタをタップもしくは SW を押下すると食べ物に関する何かが紹介される
    dispatch_async(dispatch_get_main_queue(),^{
        [[self.view viewWithTag:sentShokuzaiTalkLabel.tag] removeFromSuperview];
        int i = arc4random_uniform((int)[knowledgeArray count]);
        sentShokuzaiTalkLabel.text = knowledgeArray[i];
        [self.view addSubview:sentShokuzaiTalkLabel];
        
        int j = arc4random_uniform((int)[aimg1 count]);
        if (j == 6) j = 0;
        sentShokuzaiCharImg.image = aimg1[j];
        [self.view addSubview:sentShokuzaiCharImg];
    });
}

#pragma mark - じゃんけん画面へ遷移

- (void)toJankenVC:(UIButton*)button {
    JankenViewController *jVC = [[JankenViewController alloc] init];
    [self presentViewController:jVC animated:YES completion:nil];
}

#pragma mark - Bluetooth peering button

- (void) showBrowserVC {
    [self presentViewController:self.browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC {
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

// Notifies the delegate, when the user taps the done button
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

// Notifies delegate that the user taps the cancel button.
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        isConnected = YES;
        [Konashi findWithName:@"konashi#4-1793"];
        [self.audioPlayer play];
    } else {
        isConnected = NO;
        [self initScreen];
        [Konashi disconnect];
    }
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
}

@end

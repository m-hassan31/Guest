//
//  VoiceRecorderViewController.h
//  ÜberGuest
//
//  Created by Muhammad Hassan on 05/02/2014.
//  Copyright (c) 2014 Safyan Mughal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CADisplayLink.h>

#import "F3BarGauge.h"

@protocol VoiceRecorderViewControllerDelegate;
@interface VoiceRecorderViewController : UIViewController<UIGestureRecognizerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>{
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
    
    float Pitch;
    NSTimer *timerForPitch;
}
@property(nonatomic,assign) id <VoiceRecorderViewControllerDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIButton *playButton;
@property(nonatomic, strong) IBOutlet UIButton *stopButton;
@property(nonatomic, strong) IBOutlet UIButton *recordButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *touchbutton;
@property (weak, nonatomic) IBOutlet UIView *viewForWave;
@property (weak, nonatomic) IBOutlet UIView *viewForWave2;
@property (nonatomic) CFTimeInterval firstTimestamp;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet F3BarGauge *customRangeBar;
@property (nonatomic) NSUInteger loopCount;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;


- (IBAction) startRecording;
- (IBAction) playRecording;
- (IBAction) stopButton:(id)sender;
- (IBAction) saveVoice:(id)sender;

@end

@protocol VoiceRecorderViewControllerDelegate <NSObject>
-(void)voiceSaved:(VoiceRecorderViewController*)voiceRecorder atPath:(NSString*)voicePath;
@end

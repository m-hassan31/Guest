//
//  VoiceRecorderViewController.m
//  ÜberGuest
//
//  Created by Muhammad Hassan on 05/02/2014.
//  Copyright (c) 2014 Safyan Mughal. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "VoiceRecorderViewController.h"
#import "UserInfo.h"
#import "AbstractFetcher.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "F3BarGauge.h"
#define kVoiceFileName      @"test.caf"
@interface VoiceRecorderViewController ()

@end

@implementation VoiceRecorderViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) initialize {
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(myButtonLongPressed:)];
    // you can control how many seconds before the gesture is recognized
    gesture.minimumPressDuration =0;
    [self.touchbutton addGestureRecognizer:gesture];
    
    [self setTitle:@"Voice Recorder"];
    
    
    // Upload Voice Button
//    UIBarButtonItem *uploadVoiceButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveVoice)];
//    [self.navigationItem setRightBarButtonItem:uploadVoiceButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - Helper Methods

-(void) dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addShapeLayer
{
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.path = [[self pathAtInterval:2.0] CGPath];
    self.shapeLayer.fillColor = [[UIColor redColor] CGColor];
    self.shapeLayer.lineWidth = 1.0;
    self.shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    [self.viewForWave.layer addSublayer:self.shapeLayer];
}

- (void)startDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    if (!self.firstTimestamp)
        self.firstTimestamp = displayLink.timestamp;
    
    self.loopCount++;
    
    NSTimeInterval elapsed = (displayLink.timestamp - self.firstTimestamp);
    
    self.shapeLayer.path = [[self pathAtInterval:elapsed] CGPath];
    
    //    if (elapsed >= kSeconds)
    //    {
    //       // [self stopDisplayLink];
    //        self.shapeLayer.path = [[self pathAtInterval:0] CGPath];
    //
    //        self.statusLabel.text = [NSString stringWithFormat:@"loopCount = %.1f frames/sec", self.loopCount / kSeconds];
    //    }
}

- (UIBezierPath *)pathAtInterval:(NSTimeInterval) interval
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, self.viewForWave.bounds.size.height / 2.0)];
    
    CGFloat fractionOfSecond = interval - floor(interval);
    
    CGFloat yOffset = self.viewForWave.bounds.size.height * sin(fractionOfSecond * M_PI * Pitch*8);
    
    [path addCurveToPoint:CGPointMake(self.viewForWave.bounds.size.width, self.viewForWave.bounds.size.height / 2.0)
            controlPoint1:CGPointMake(self.viewForWave.bounds.size.width / 2.0, self.viewForWave.bounds.size.height / 2.0 - yOffset)
            controlPoint2:CGPointMake(self.viewForWave.bounds.size.width / 2.0, self.viewForWave.bounds.size.height / 2.0 + yOffset)];
    
    return path;
}

- (void) myButtonLongPressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Touch down");
        
        [self.touchbutton setBackgroundImage:[UIImage imageNamed:@"listing_done_btn~iphone.png"] forState:UIControlStateNormal];
        [self startRecording];
        
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"Long press Ended");
        [self stopRecording];
        [self.touchbutton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
}

-(IBAction) startRecording
{
    self.viewForWave.hidden = NO;
    [self addShapeLayer];
    [self startDisplayLink];
    // kSeconds = 150.0;
    NSLog(@"startRecording");
    audioRecorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
    //    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:kVoiceFileName];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    audioRecorder.meteringEnabled = YES;
    if ([audioRecorder prepareToRecord] == YES){
        audioRecorder.meteringEnabled = YES;
        [audioRecorder record];
        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
    
}

- (void)levelTimerCallback:(NSTimer *)timer {
	[audioRecorder updateMeters];
	NSLog(@"Average input: %f Peak input: %f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0]);
    
    float linear = pow (10, [audioRecorder peakPowerForChannel:0] / 20);
    NSLog(@"linear===%f",linear);
    float linear1 = pow (10, [audioRecorder averagePowerForChannel:0] / 20);
    NSLog(@"linear1===%f",linear1);
    if (linear1>0.03) {
        
        Pitch = linear1+.20;//pow (10, [audioRecorder averagePowerForChannel:0] / 20);//[audioRecorder peakPowerForChannel:0];
    }
    else {
        
        Pitch = 0.0;
    }
    //Pitch =linear1;
    NSLog(@"Pitch==%f",Pitch);
    _customRangeBar.value = Pitch;//linear1+.30;
    [_progressView setProgress:Pitch];
    float minutes = floor(audioRecorder.currentTime/60);
    float seconds = audioRecorder.currentTime - (minutes * 60);
    
    NSString *time = [NSString stringWithFormat:@"%0.0f.%0.0f",minutes, seconds];
    [self.statusLabel setText:[NSString stringWithFormat:@"%@ sec", time]];
    NSLog(@"recording");
    
}
-(void) stopRecording
{
    NSLog(@"stopRecording");
    // kSeconds = 0.0;
    self.viewForWave.hidden = YES;
    [audioRecorder stop];
    NSLog(@"stopped");
    [self stopDisplayLink];
    self.shapeLayer.path = [[self pathAtInterval:0] CGPath];
    [timerForPitch invalidate];
    timerForPitch = nil;
    _customRangeBar.value = 0.0;
}

-(IBAction) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:kVoiceFileName];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(void) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
    
}

-(IBAction)stopButton:(id)sender {
    if ([sender tag] == 1000) {
        [sender setTag:1001];
        [self stopRecording];
    }else {
        [sender setTag:1000];
        [self stopPlaying];
    }
}

-(IBAction)saveVoice {
//    if (self.delegate) {
//        if ([self.delegate respondsToSelector:@selector(voiceSaved:atPath:)]) {
//            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
//                                                                    NSDocumentDirectory, NSUserDomainMask, YES);
//            NSString *docsDir = [dirPaths objectAtIndex:0];
//            NSString *soundFilePath = [docsDir
//                                       stringByAppendingPathComponent:kVoiceFileName];
//            [self.delegate voiceSaved:self atPath:soundFilePath];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
    
    [self.activity setColor:[UIColor blackColor]];
    [self.activity startAnimating];
    
    NSURL *url = [[NSURL alloc] init];
    url = audioRecorder.url;
    NSLog(@"Audio Voice URL = %@", url);
    url = [self convertToWav];
    NSLog(@"New URL = %@", url);
//    [self uploadVoice:url];
}

-(void) uploadVoice:(NSURL *)voiceUrl {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"recordTest" ofType:@"wav"];
    
    NSData *postData = [NSData dataWithContentsOfFile:filePath];
    //nsdata to string
//    NSString *content = [[NSString alloc]  initWithBytes:[postData bytes]
//                                                  length:[postData length] encoding: NSUTF8StringEncoding];
    
    GenericFetcher *fetcher = [[GenericFetcher alloc] init];
    NSString *apiKey = [[UserInfo instance] apiKey];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:postData forKey:kvoice];
    
    NSLog(@"Camous url------> %@",[URLBuilder urlForMethod:[NSString stringWithFormat:@"/voice_upload/%@", apiKey] withParameters:params]);
    
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:[NSString stringWithFormat:@"upload_guest_voice/%@", apiKey] withParameters:nil] withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
        
        int status = [[dict valueForKey:@"status"] intValue];
        NSLog(@"Status = %d", status);
        if (status == 1) {
            [self.activity stopAnimating];
            NSLog(@"Status = %d", status);
            [[UserInfo instance] setUserVoiceLink:kvoice];
            [[UserInfo instance] saveUserInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.activity stopAnimating];
            NSLog(@"Status = %d", status);
            [self showAlert:@"Voice Message" message:@"Voice is not uploaded."];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"Error while uploading voice!!!");
    }];
}

-(void) showAlert:(NSString *) title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(NSURL *) convertToWav
{
    // set up an AVAssetReader to read from the
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *cafFilePath = [docsDir
                               stringByAppendingPathComponent:kVoiceFileName];
    
    
    NSURL *assetURL = [NSURL fileURLWithPath:cafFilePath];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    NSError *assetError = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset error:&assetError];
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return nil;
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    if (! [assetReader canAddOutput: assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return nil;
    }
    [assetReader addOutput: assetReaderOutput];
    
    NSString *title = @"test";
    NSArray *docDirs = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [docDirs objectAtIndex: 0];
    NSString *wavFilePath = [[docDir stringByAppendingPathComponent :title]
                             stringByAppendingPathExtension:@"wav"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil];
    }
    NSURL *exportURL = [NSURL fileURLWithPath:wavFilePath];
    NSLog(@"Wav URL = %@", exportURL);
//    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
//                                                          fileType:AVFileTypeWAVE
//                                                             error:&assetError];
//    if (assetError)
//    {
//        NSLog (@"error: %@", assetError);
//        return;
//    }
    return exportURL;
}

@end

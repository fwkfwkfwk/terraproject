
@import AVFoundation;

#import "SKTAudio.h"

@interface SKTAudio()
@property (nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic) AVAudioPlayer *soundEffectPlayer;
@end

@implementation SKTAudio

+ (instancetype)sharedInstance {
  static dispatch_once_t pred;
  static SKTAudio *sharedInstance;
  dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
  return sharedInstance;
}

- (void)playBackgroundMusic:(NSString *)filename {
  NSError *error;
  NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
  self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
  self.backgroundMusicPlayer.numberOfLoops = -1;
  [self.backgroundMusicPlayer prepareToPlay];
  [self.backgroundMusicPlayer play];
}

- (void)pauseBackgroundMusic {
  [self.backgroundMusicPlayer pause];
}

- (void)resumeBackgroundMusic {
  [self.backgroundMusicPlayer play];
}

- (void)playSoundEffect:(NSString*)filename {
  NSError *error;
  NSURL *soundEffectURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
  self.soundEffectPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundEffectURL error:&error];
  self.soundEffectPlayer.numberOfLoops = 0;
  [self.soundEffectPlayer prepareToPlay];
  [self.soundEffectPlayer play];
}

@end

//
//  Flyer.m
//  Terra
//
//  Terra Studio.
//

#import "Flyer.h"

#define kFlyerWidth 64
#define kFlyerHeight 64

@interface Flyer ()
@property (nonatomic, strong) SKAction *seekingAnim;
@property (nonatomic, strong) SKAction *attackingAnim;
@property (nonatomic, strong) SKAction *playAttackSound;
@property (nonatomic, strong) SKAction *playCloseEyeSound;

@end

@implementation Flyer

- (id)initWithImageNamed:(NSString *)name
{
  if (self = [super initWithImageNamed:name]) {
    self.playDyingSound = [SKAction playSoundFileNamed:@"flyerdie.wav" waitForCompletion:NO];
    self.playAttackSound = [SKAction playSoundFileNamed:@"flyerattack.wav" waitForCompletion:NO];
    self.playCloseEyeSound = [SKAction playSoundFileNamed:@"flyercloseeye.wav" waitForCompletion:NO];
  }
  return self;
}

- (void)loadAnimations {
  self.seekingAnim = [self loadAnimationFromPlist:@"seekingAnim" forClass:@"Flyer"];
  self.attackingAnim = [self loadAnimationFromPlist:@"attackingAnim" forClass:@"Flyer"];
  self.dyingAnim = [self loadAnimationFromPlist:@"dyingAnim" forClass:@"Flyer"];
}

- (void)update:(NSTimeInterval)delta {
  if (self.characterState == kStateDead) {
    self.desiredPosition = self.position;
    return;
  }

  CGFloat distance = CGPointDistance(self.position, self.player.position);
  if (distance > 1000) {
    self.desiredPosition = self.position;
    self.isActive = NO;
    return;
  } else {
    self.isActive = YES;
  }

  CGFloat speed;
  if (distance < 100) {
    [self changeState:kStateAttacking];
    speed = 100;
  } else if ((!self.player.flipX && self.player.position.x < self.position.x) || (self.player.flipX && self.player.position.x > self.position.x)) {
    [self changeState:kStateHiding];
    speed = 0;
  } else {
    [self changeState:kStateSeeking];
    speed = 60;
  }

  CGPoint v = CGPointNormalize(CGPointSubtract(self.player.position, self.position));
  self.velocity = CGPointMultiplyScalar(v, speed);

  if (self.position.x < self.player.position.x) {
    self.flipX = NO;
  } else {
    self.flipX = YES;
  }

  CGPoint stepVelocity = CGPointMultiplyScalar(self.velocity, delta);
  self.desiredPosition = CGPointAdd(self.position, stepVelocity);
}

- (void)changeState:(CharacterState)newState {
  if (newState == self.characterState) return;
  [self removeAllActions];
  self.characterState = newState;

  SKAction *action = nil;
  switch (newState) {
    case kStateSeeking: {
      action = [SKAction repeatActionForever:self.seekingAnim];
      break;
    }
    case kStateHiding: {
      [self runAction:self.playCloseEyeSound];
      [self setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"Flyer4.png"]];
      [self setSize:self.texture.size];
      break;
    }
    case kStateAttacking: {
      [self runAction:self.playAttackSound];
      action = [SKAction repeatActionForever:self.attackingAnim];
      break;
    }
    case kStateDead: {
      [self runAction:self.playDyingSound];
      action = [SKAction sequence:@[self.dyingAnim, [SKAction performSelector:@selector(removeSelf) onTarget:self]]];
      break;
    }
    default:
      break;
  }
  if (action != nil) {
    [self runAction:action];
  }
}

- (CGRect)collisionBoundingBox {
  return CGRectMake(
      self.desiredPosition.x - (kFlyerWidth / 2), 
      self.desiredPosition.y - (kFlyerHeight / 2),
      kFlyerWidth, kFlyerHeight);
}

@end

//
//  Player.m
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "Player.h"
#import "PSKLevelScene.h"

#define kPlayerWidth 30
#define kPlayerHeight 38

#define kWalkingAcceleration 1600
#define kDamping 0.85
#define kMaxSpeed 250
#define kJumpForce 400
#define kJumpCutoff 150
#define kJumpOut 360
#define kWallSlideSpeed -30
#define kKnockback 100
#define kCoolDown 1.5

@interface Player ()
@property (nonatomic, assign) BOOL jumpReset;
@property (nonatomic, strong) SKAction *walkingAnim;
@property (nonatomic, strong) SKAction *jumpUpAnim;
@property (nonatomic, strong) SKAction *wallSlideAnim;
@property (nonatomic, strong) SKAction *dyingAnim;

@property (nonatomic, strong) SKAction *playJumpSound;
@property (nonatomic, strong) SKAction *playDoubleJumpSound;
@property (nonatomic, strong) SKAction *playDyingSound;
@property (nonatomic, strong) SKAction *playBounceSound;

@end

@implementation Player

- (id)initWithImageNamed:(NSString *)name {
  if (self = [super initWithImageNamed:name]) {
    self.velocity = CGPointMake(0.0, 0.0);
	self.isActive = YES;
    self.jumpReset = YES;
    self.life = 500;
      
    self.playJumpSound = [SKAction playSoundFileNamed:@"jump1.wav" waitForCompletion:NO];
    self.playDoubleJumpSound = [SKAction playSoundFileNamed:@"jump2.wav" waitForCompletion:NO];
    self.playDyingSound = [SKAction playSoundFileNamed:@"player_die.wav" waitForCompletion:NO];
    self.playBounceSound = [SKAction playSoundFileNamed:@"bounce.wav" waitForCompletion:NO];
  }
  return self;
}

- (void)update:(NSTimeInterval)dt {
  if (self.characterState == kStateDead) {
    self.desiredPosition = self.position;
    return;
  }

  CharacterState newState = self.characterState;

  CGPoint joyForce = CGPointZero;
  if (self.hud.joyDirection == kJoyDirectionLeft) {
    self.flipX = YES;
    joyForce = CGPointMake(-kWalkingAcceleration, 0);
  } else if (self.hud.joyDirection == kJoyDirectionRight) {
    self.flipX = NO;
    joyForce = CGPointMake(kWalkingAcceleration, 0);
  }

  CGPoint joyForceStep = CGPointMultiplyScalar(joyForce, dt);
  self.velocity = CGPointAdd(self.velocity, joyForceStep);

  if (self.hud.jumpState == kJumpButtonOn) {
    if ((self.characterState == kStateJumping || self.characterState == kStateFalling) && self.jumpReset && self.canDoubleJump) {
      self.velocity = CGPointMake(self.velocity.x, kJumpForce);
      self.jumpReset = NO;
      newState = kStateDoubleJumping;
    } else if ((self.onGround || self.characterState == kStateWallSliding) && self.jumpReset) {
      self.velocity = CGPointMake(self.velocity.x, kJumpForce);
      self.jumpReset = NO;

      if (self.characterState == kStateWallSliding) {
         NSInteger direction = -1;
         if (self.flipX) {
            direction = 1;
         }
         self.velocity = CGPointMake(direction * kJumpOut, self.velocity.y);
      }

      newState = kStateJumping;
      self.onGround = NO;
    }
  } else {
    if (self.velocity.y > kJumpCutoff) {
      self.velocity = CGPointMake(self.velocity.x, kJumpCutoff);
    }
    self.jumpReset = YES;
  }

  if (self.onGround && self.hud.joyDirection == kJoyDirectionNone) {
    newState = kStateStanding;
  } else if (self.onGround && self.hud.joyDirection != kJoyDirectionNone) {
    newState = kStateWalking;
  } else if (self.onWall && self.velocity.y < 0 && self.canWallSlide) {
    newState = kStateWallSliding;
  } else if (self.characterState == kStateDoubleJumping || newState == kStateDoubleJumping) {
    newState = kStateDoubleJumping;
  } else if (self.characterState == kStateJumping || newState == kStateJumping) {
    newState = kStateJumping;
  } else {
    newState = kStateFalling;
  }
  [self changeState:newState];

  CGPoint gravity = CGPointMake(0.0, -450.0);
  CGPoint gravityStep = CGPointMultiplyScalar(gravity, dt);
  self.velocity = CGPointAdd(self.velocity, gravityStep);

  self.velocity = CGPointMake(self.velocity.x * kDamping, self.velocity.y);

  self.velocity = CGPointMake(Clamp(self.velocity.x, -kMaxSpeed, kMaxSpeed), Clamp(self.velocity.y, -kMaxSpeed, kMaxSpeed));

  if (self.characterState == kStateWallSliding) {
    CGFloat fallingSpeed = Clamp(self.velocity.y, kWallSlideSpeed, 0);
    self.velocity = CGPointMake(self.velocity.x, fallingSpeed);
  }

  CGPoint stepVelocity = CGPointMultiplyScalar(self.velocity, dt);
  self.desiredPosition = CGPointAdd(self.position, stepVelocity);
}

- (CGRect)collisionBoundingBox {
  CGRect bounding = CGRectMake(
      self.desiredPosition.x - (kPlayerWidth / 2),
      self.desiredPosition.y - (kPlayerHeight / 2),
      kPlayerWidth, kPlayerHeight);

  return CGRectOffset(bounding, 0, -3);
}

- (void)changeState:(CharacterState)newState {
  if (newState == self.characterState) return;
  self.characterState = newState;

  [self removeAllActions];

  SKAction *action = nil;
  switch (newState) {
    case kStateStanding: {
      [self setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"Player1"]];
      [self setSize:self.texture.size];
      break;
    }
    case kStateFalling: {
      [self setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"Player10"]];
      [self setSize:self.texture.size];
      break;
    }
    case kStateWalking: {
      action = [SKAction repeatActionForever:self.walkingAnim];
      break;
    }
    case kStateWallSliding: {
      action = [SKAction repeatActionForever:self.wallSlideAnim];
      break;
    }
    case kStateJumping: {
      [self runAction:self.playJumpSound];
      action = self.jumpUpAnim;
      break;
    }
    case kStateDoubleJumping: {
      [[SKTAudio sharedInstance] playSoundEffect:@"jump2.wav"];
      [self setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"Player10"]];
      [self setSize:self.texture.size];
      break;
    }
    case kStateDead: {
      [[SKTAudio sharedInstance] playSoundEffect:@"player_die.wav"];
      action = [SKAction sequence:@[
          self.dyingAnim,
          [SKAction waitForDuration:0.5],
          [SKAction performSelector:@selector(endGame) onTarget:self]]];
      break;
    }
    default: {
      [self setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"Player1"]];
      break;
    }
  }

  if (action) {
    [self runAction:action];
  }
}

- (void)loadAnimations {
  self.wallSlideAnim = [self loadAnimationFromPlist:@"wallSlideAnim" forClass:@"Player"];
  self.walkingAnim = [self loadAnimationFromPlist:@"walkingAnim" forClass:@"Player"];
  self.jumpUpAnim = [self loadAnimationFromPlist:@"jumpUpAnim" forClass:@"Player"];
  self.dyingAnim = [self loadAnimationFromPlist:@"dyingAnim" forClass:@"Player"];
}

- (void)bounce {
  [[SKTAudio sharedInstance] playSoundEffect:@"bounce.wav"];
  self.velocity = CGPointMake(self.velocity.x, kJumpForce / 3);
  self.isActive = NO;
  [self performSelector:@selector(coolDownFinished) withObject:nil afterDelay:.5];
}

- (void)tookHit:(PSKCharacter *)character {
  self.life = self.life - 100;
  if (self.life < 0) {
    self.life = 0;
  }

  [self.hud setLife:self.life / 500.0];

  if (self.life <= 0) {
    [self changeState:kStateDead];
  } else {
    self.alpha = 0.5;
    self.isActive = NO;

    if (self.position.x < character.position.x) {
      self.velocity = CGPointMake(-kKnockback / 2, kKnockback);
    } else {
      self.velocity = CGPointMake(kKnockback / 2, kKnockback);
    }

    [self performSelector:@selector(coolDownFinished) withObject:nil afterDelay:kCoolDown];
  }
}

- (void)coolDownFinished {
  self.alpha = 1.0;
  self.isActive = YES;
}

- (void)endGame {
  PSKLevelScene *levelScene = (PSKLevelScene *)self.scene;
  [levelScene loseGame];
}

@end

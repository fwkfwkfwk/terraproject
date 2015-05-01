//
//  PSKHUDNode.m
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "PSKHUDNode.h"
#import "PSKSharedTextureCache.h"

@interface PSKHUDNode ()

@property (nonatomic, strong) SKSpriteNode *lifeBarImage;
@property (nonatomic, strong) SKSpriteNode *leftButton;
@property (nonatomic, strong) SKSpriteNode *rightButton;
@property (nonatomic, strong) SKSpriteNode *jumpButton;

@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, assign) BOOL jumpButtonPressed;
@property (nonatomic, assign) BOOL leftButtonPressed;
@property (nonatomic, assign) BOOL rightButtonPressed;

@end

@implementation PSKHUDNode

- (instancetype)initWithSize:(CGSize)size {
  if ((self = [super init])) {
    self.userInteractionEnabled = YES;

    self.lifeBarImage = [SKSpriteNode spriteNodeWithImageNamed:@"Life_Bar_5_5"];
    self.lifeBarImage.position = CGPointMake(80, size.height - 40);
    [self addChild:self.lifeBarImage];

    self.leftButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftButton"];
    self.leftButton.position = CGPointMake(50, 90);
    [self addChild:self.leftButton];

    self.rightButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightButton"];
    self.rightButton.position = CGPointMake(130, 90);
    [self addChild:self.rightButton];

    self.jumpButton = [SKSpriteNode spriteNodeWithImageNamed:@"jumpButton"];
    self.jumpButton.position = CGPointMake(size.width - 70, 60);
    [self addChild:self.jumpButton];

    self.buttons = @[self.leftButton, self.rightButton, self.jumpButton];
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    CGPoint touchLocation = [touch locationInNode:self];
    for (SKSpriteNode *button in self.buttons) {
      if (CGRectContainsPoint(CGRectInset(button.frame, -25, -50), touchLocation)) {
        if (button == self.jumpButton) {
          [self sendJump:YES];
        } else if (button == self.rightButton) {
          [self sendDirection:kJoyDirectionRight];
        } else if (button == self.leftButton) {
          [self sendDirection:kJoyDirectionLeft];
        }
      }
    }
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    CGPoint touchLocation = [touch locationInNode:self];
    for (SKSpriteNode *button in self.buttons) {
     if (CGRectContainsPoint(CGRectInset(button.frame, -25, -50), touchLocation)) {
        if (button == self.jumpButton) {
          [self sendJump:NO];
        } else {
          [self sendDirection:kJoyDirectionNone];
        }
      }
    }
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    CGPoint touchLocation = [touch locationInNode:self];
    CGPoint previousTouchLocation = [touch previousLocationInNode:self];

    for (SKSpriteNode *button in self.buttons) {
      if (CGRectContainsPoint(button.frame, previousTouchLocation) &&
          !CGRectContainsPoint(button.frame, touchLocation)) {
        if (button == self.jumpButton) {
          [self sendJump:NO];
        } else  {
          [self sendDirection:kJoyDirectionNone];
        }
      }
	}

    for (SKSpriteNode *button in self.buttons) {
      if (!CGRectContainsPoint(button.frame, previousTouchLocation) &&
           CGRectContainsPoint(button.frame, touchLocation)) {
        //We don't get another jump on a slide-on, we want the player to let go of the button for another jump
        if (button == self.rightButton) {
          [self sendDirection:kJoyDirectionRight];
        } else if (button == self.leftButton) {
          [self sendDirection:kJoyDirectionLeft];
        }
      }
    }
  }
}

- (void)sendJump:(BOOL)jumpOn {
  if (jumpOn) {
    self.jumpButtonPressed = YES;
    [self.jumpButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"jumpButtonPressed"]];
  } else {
    self.jumpButtonPressed = NO;
    [self.jumpButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"jumpButton"]];
  }
}

- (void)sendDirection:(JoystickDirection)direction {
  if (direction == kJoyDirectionLeft) {
    self.leftButtonPressed = YES;
    self.rightButtonPressed = NO;
    [self.leftButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"leftButtonPressed"]];
    [self.rightButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"rightButton"]];
  } else if (direction == kJoyDirectionRight) {
    self.rightButtonPressed = YES;
    self.leftButtonPressed = NO;
    [self.rightButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"rightButtonPressed"]];
    [self.leftButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"leftButton"]];
  } else {
    self.rightButtonPressed = NO;
    self.leftButtonPressed = NO;
    [self.rightButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"rightButton"]];
    [self.leftButton setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:@"leftButton"]];
  }
}

#pragma mark - Properties

- (JumpButtonState)jumpState {
  if (self.jumpButtonPressed) {
    return kJumpButtonOn;
  }
  return kJumpButtonOff;
}

- (JoystickDirection)joyDirection {
  if (self.leftButtonPressed) {
    return kJoyDirectionLeft;
  } else if (self.rightButtonPressed) {
    return kJoyDirectionRight;
  }
  return kJoyDirectionNone;
}

- (void)setLife:(CGFloat)life {
  int num = (int)(life * 5);
  NSString *lifeFrame = [NSString stringWithFormat:@"Life_Bar_%d_5", num];
  [self.lifeBarImage setTexture:[[PSKSharedTextureCache sharedCache] textureNamed:lifeFrame]];
  [self.lifeBarImage setSize:self.lifeBarImage.texture.size];
}

@end

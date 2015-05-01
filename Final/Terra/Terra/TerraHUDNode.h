//
//  PSKHUDNode.h
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, JoystickDirection) {
  kJoyDirectionNone,
  kJoyDirectionLeft,
  kJoyDirectionRight
};

typedef NS_ENUM(NSInteger, JumpButtonState) {
  kJumpButtonOn,
  kJumpButtonOff
};

@interface PSKHUDNode : SKNode

@property (nonatomic, assign) JoystickDirection joyDirection;
@property (nonatomic, assign) JumpButtonState jumpState;

- (instancetype)initWithSize:(CGSize)size;
- (void)setLife:(CGFloat)life;

@end

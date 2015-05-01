//
//  PSKGameObject.m
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "PSKGameObject.h"

@implementation PSKGameObject

- (id)initWithImageNamed:(NSString *)name {
  if ((self = [super initWithImageNamed:name])) {
    [self loadAnimations];
  }
  return self;
}

- (void)setFlipX:(BOOL)flipX {
  if (flipX) {
    self.xScale = -fabs(self.xScale);
  } else {
    self.xScale = fabs(self.xScale);
  }
  _flipX = flipX;
}

- (void)setSize:(CGSize)size {
  if (!self.flipX) {
      [super setSize:size];
  } else {
      [super setSize:CGSizeMake(-size.width, size.height)];
  }
}

- (void)loadAnimations {
  //override this method
}

- (SKAction *)loadAnimationFromPlist:(NSString *)animationName forClass:(NSString *)className {

  NSString *path = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
  NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];

  NSDictionary *animationSettings = plistDictionary[animationName];
  float delayPerUnit = [animationSettings[@"delay"] floatValue];

  NSString *animationFrames = animationSettings[@"animationFrames"];
  NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];

  NSMutableArray *frames = [NSMutableArray array];
  for (NSString *frameNumber in animationFrameNumbers) {
    NSString *frameName = [NSString stringWithFormat:@"%@%@",className,frameNumber];
    SKTexture *frame = [[PSKSharedTextureCache sharedCache] textureNamed:frameName];
    [frames addObject:frame];
  }

  return [SKAction animateWithTextures:frames timePerFrame:delayPerUnit resize:YES restore:NO];
}

@end

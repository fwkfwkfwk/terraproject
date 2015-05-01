//
//  PSKGameObject.h
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PSKSharedTextureCache.h"

@interface PSKGameObject : SKSpriteNode

@property (nonatomic, assign) BOOL flipX;

- (SKAction *)loadAnimationFromPlist:(NSString *)animationName 
                            forClass:(NSString *)className;
- (void)loadAnimations;

@end

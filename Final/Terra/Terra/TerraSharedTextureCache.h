//
//  PSKSharedTextureCache.h
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PSKSharedTextureCache : NSObject

+ (instancetype)sharedCache;

- (SKTexture *)textureNamed:(NSString *)name;
- (void)addTexture:(SKTexture *)texture name:(NSString *)textureName;

@end

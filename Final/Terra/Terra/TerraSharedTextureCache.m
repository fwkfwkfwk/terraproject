//
//  PSKSharedTextureCache.m
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "PSKSharedTextureCache.h"

//1
@interface PSKSharedTextureCache ()
@property (strong, nonatomic) NSMutableDictionary *textures;
@end

@implementation PSKSharedTextureCache
//2
+ (instancetype)sharedCache {
  static dispatch_once_t pred;
  static PSKSharedTextureCache *sharedCache;
  dispatch_once(&pred, ^{
    sharedCache = [PSKSharedTextureCache new];
  });
  return sharedCache;
}
//3
- (id)init {
  if ((self = [super init])) {
    self.textures = [NSMutableDictionary dictionary];
  }
  return self;
}
//4
- (SKTexture *)textureNamed:(NSString *)textureName {
  if ([textureName pathExtension]) {
    textureName = [textureName stringByDeletingPathExtension];
  }
  return self.textures[textureName];
}
//5
- (void)addTexture:(SKTexture *)texture name:(NSString *)textureName {
  if ([textureName pathExtension]) {
    textureName = [textureName stringByDeletingPathExtension];
  }
  self.textures[textureName] = texture;
}

@end

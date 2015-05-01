//
//  JSTileMap+TileLocations.m
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "JSTileMap+TileLocations.h"

@implementation JSTileMap (TileLocations)

- (CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
  CGFloat levelHeightInPixels = self.mapSize.height * self.tileSize.height;
  CGPoint origin = CGPointMake(tileCoords.x * self.tileSize.width, levelHeightInPixels - (tileCoords.y + 1) * self.tileSize.height);
  return CGRectMake(origin.x, origin.y, self.tileSize.width, self.tileSize.height);
}

- (BOOL)isWallAtTileCoord:(CGPoint)tileCoord {
  TMXLayer *layer = [self layerNamed:@"walls"];
  NSInteger gid = [layer tileGIDAtTileCoord:tileCoord];
  return (gid != 0);
}

@end

@implementation TMXLayer (TileLocations)

- (NSInteger)tileGIDAtTileCoord:(CGPoint)point {
  return [self.layerInfo tileGidAtCoord:point];
}

@end 

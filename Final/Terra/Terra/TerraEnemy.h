//
//  PSKEnemy.h
//  Terra
//
//  Terra Studio.
//

#import "PSKCharacter.h"
#import "Player.h"
#import "JSTileMap+TileLocations.h"

@interface PSKEnemy : PSKCharacter

@property (nonatomic, weak) Player *player;
@property (nonatomic, weak) JSTileMap *map;
@property (nonatomic, strong) SKAction *playDyingSound;

- (void)removeSelf;

@end

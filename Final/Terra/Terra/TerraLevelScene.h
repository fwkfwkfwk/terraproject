//
//  PSKMyScene.h
//  Terra
//
Terra Studio.
//

#import <SpriteKit/SpriteKit.h>

@protocol SceneDelegate <NSObject>
- (void)dismissScene;
@end

@interface PSKLevelScene : SKScene

@property (nonatomic, weak) id <SceneDelegate> sceneDelegate;

- (id)initWithSize:(CGSize)size level:(NSUInteger)currentLevel;
- (void)loseGame;

@end

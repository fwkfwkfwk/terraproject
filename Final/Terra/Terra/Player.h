//
//  Player.h
//  Terra
//
//  Created by Matthijs on 15-11-13.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "PSKCharacter.h"
#import "PSKHUDNode.h"

@interface Player : PSKCharacter

@property (nonatomic, weak) PSKHUDNode *hud;
@property (nonatomic, assign) BOOL canDoubleJump;
@property (nonatomic, assign) BOOL canWallSlide;

- (void)bounce;

@end

//
//  LevelSelectViewController.m
//  Terra
//
//  Created by Jacob Gundersen on 4/20/12.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "LevelSelectViewController.h"
#import "PSKGameViewController.h"
#import "SKTAudio.h"

@interface LevelSelectViewController ()
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIButton *level1Button;
@property (weak, nonatomic) IBOutlet UIButton *level2Button;
@property (weak, nonatomic) IBOutlet UIButton *level3Button;
@end

@implementation LevelSelectViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  CGFloat screenWidth = self.view.bounds.size.width;
  self.scroller.contentSize = CGSizeMake(screenWidth * 3, self.view.bounds.size.height);

  // Place the first level in the center of the screen
  CGRect r = self.level1Button.frame;
  CGFloat x = (screenWidth - r.size.width) * 0.5;
  r.origin.x = x;
  self.level1Button.frame = r;

  // Set the buttons apart by a screen's width
  r = self.level2Button.frame;
  x += screenWidth;
  r.origin.x = x;
  self.level2Button.frame = r;

  r = self.level3Button.frame;
  x += screenWidth;
  r.origin.x = x;
  self.level3Button.frame = r;

  // Enable pagination
  self.scroller.pagingEnabled = YES;

  // The code below is included for reference. It's a method for making levels unselectable
  // until they have been completed. Set the levels (except the first) to an opacity of 0.5
  // and deselect userInteractionEnabled in the storyboard.
  // Then after the user completes the level, set the levelUnlocked key in the NSUserDefaults
  // to the next level number.

  /*
  NSArray *levelButtons = @[self.level1Button, self.level2Button, self.level3Button];

  NSNumber *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"levelUnlocked"];
  int level;
  if (num == nil) {
    level = 1;
  } else {
    level = [num intValue];
  }

  for (int i = 0; i < level; i++) {
    UIButton *button = levelButtons[i];
    button.userInteractionEnabled = YES;
    button.alpha = 1.0;
  }
  */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  self.pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / self.view.frame.size.width + 0.5);
  //NSLog(@"current page %d", self.pageControl.currentPage);
}

- (IBAction)backToMain:(id)sender {
  [[SKTAudio sharedInstance] playSoundEffect:@"button.wav"];
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toGameView:(id)sender {
  [[SKTAudio sharedInstance] playSoundEffect:@"button.wav"];
  [self performSegueWithIdentifier:@"ToGameView" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ToGameView"]) {
    [[SKTAudio sharedInstance] pauseBackgroundMusic];
    PSKGameViewController *gvc = segue.destinationViewController;
    UIButton *button = (UIButton *)sender;
    NSString *levelText = button.titleLabel.text;
    gvc.currentLevel = [[levelText substringFromIndex:5] intValue];
  }
}

@end

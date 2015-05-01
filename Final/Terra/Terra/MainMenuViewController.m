//
//  MainMenuViewController.m
//  Terra
//
//  Created by Jacob Gundersen on 4/20/12.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "MainMenuViewController.h"
#import "SKTAudio.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Start background music
  [[SKTAudio sharedInstance] playBackgroundMusic:@"mainmenu.mp3"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [[SKTAudio sharedInstance] playSoundEffect:@"button.wav"];
}

@end

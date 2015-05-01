//
//  AboutViewController.m
//  Terra
//
//  Created by Jacob Gundersen on 4/20/12.
//  Copyright (c) 2013 Razeware, LLC. All rights reserved.
//

#import "AboutViewController.h"
#import "SKTAudio.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (IBAction)backToMain:(id)sender {
  [[SKTAudio sharedInstance] playSoundEffect:@"button.wav"];
  [self.navigationController popViewControllerAnimated:YES];
}

@end

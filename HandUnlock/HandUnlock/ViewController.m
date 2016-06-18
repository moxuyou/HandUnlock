//
//  ViewController.m
//  HandUnlock
//
//  Created by moxuyou on 16/6/18.
//  Copyright © 2016年 moxuyou. All rights reserved.
//

#import "ViewController.h"
#import "LXHSuccesVC.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postoSucces) name:@"loginSucces" object:nil];
    
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postoSucces
{
    LXHSuccesVC *vc = [[LXHSuccesVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end

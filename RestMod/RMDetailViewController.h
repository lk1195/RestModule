//
//  RMDetailViewController.h
//  RestMod
//
//  Created by lk1195 on 10/29/14.
//  Copyright (c) 2014 lk1195. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

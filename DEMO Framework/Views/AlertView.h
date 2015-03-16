//
//  AlertView.h
//  DEMO Framework
//
//  Created by tracyshi on 2015-03-16.
//  Copyright (c) 2015 SAP Canada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *alertMessageLabel;
@property (weak, nonatomic) NSString *alertMessage;

@end

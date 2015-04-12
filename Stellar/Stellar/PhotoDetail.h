//
//  PhotoDetail.h
//  Stellar
//
//  Created by Jorge Vivas on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoDetail : NSObject

@property (weak, nonatomic) UIImage* photo;
@property (nonatomic, retain) NSString *title;

@end

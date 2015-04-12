//
//  AstronautDelegate.h
//  Stellar
//
//  Created by Sebastián Ramírez on 4/12/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

@protocol AstronautDelegate <NSObject>

- (BOOL)customCellWasPressed:(NSString *)astronautId;

@end
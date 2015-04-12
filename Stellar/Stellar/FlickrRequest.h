//
//  FlickrRequest.h
//  Stellar
//
//  Created by Jorge Vivas on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol FlickerRequestDelegate <NSObject>
    - (NSMutableArray*)finishDownloadImages;
@end


@interface FlickrRequest : NSObject

@property (nonatomic, strong) NSMutableArray* arrayUrlImages;
@property (nonatomic, weak) id <FlickerRequestDelegate> delegate;
-(void) createRequest;

@end

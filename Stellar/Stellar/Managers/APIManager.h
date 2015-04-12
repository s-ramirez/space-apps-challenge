//
//  APIManager.h
//  Fut5
//
//  Created by Kai on 12/2/15.
//  Copyright (c) 2015 JorgeVivas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Client.h"

@interface APIManager : NSObject


+(APIManager *)sharedManager;

//API Requests
-(void)requestAvailableAreasWithDate:(NSDate *)date AreaTypes:(NSArray *)areaTypes WithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock;

-(void)requestReservationWithDate:(NSDate *)date AreaId:(NSString *)areaId  WithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock;

-(void)requestCalendarWithAreaId:(NSString *)areaId WithSuccessBlock:(void (^)(PFObject *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock;

-(void)requestReservationsForCurrentUserWithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock;

-(void)requestHistoryForCurrentUserWithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock;

-(void)setSharedUser:(Client *)user;

-(Client *)getSharedUser;

@end

//
//  APIManager.m
//  Fut5
//
//  Created by Kai on 12/2/15.
//  Copyright (c) 2015 JorgeVivas. All rights reserved.
//

#import "APIManager.h"

static APIManager *sharedManager = nil;

@interface APIManager()
@property (nonatomic, retain) Client *sharedUser;
@end

@implementation APIManager

+ (APIManager *)sharedManager {
    if (sharedManager == nil) {
        sharedManager = [[APIManager alloc ] init];
    }
    return sharedManager;
}

-(void)setSharedUser:(Client *)user{
    _sharedUser = user;
}

-(Client *)getSharedUser{
    return _sharedUser;
}

-(void)requestAvailableAreasWithDate:(NSDate *)date AreaTypes:(NSArray *)areaTypes WithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock {
    [PFCloud callFunctionInBackground:@"getAvailableAreas"
                       withParameters:@{@"dateRequest": date, @"areaTypes": areaTypes}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        //Successfully retrieved result
                                        successBlock(result);
                                    }
                                    else{
                                        //An error occurred
                                        errorBlock(error);
                                    }
                                }];
}

-(void)requestReservationWithDate:(NSDate *)date AreaId:(NSString *)areaId WithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock{
    [PFCloud callFunctionInBackground:@"requestReservation"
                       withParameters:@{@"appointmentDate": date, @"areaId": areaId, @"userFbId": _sharedUser.idFacebook}
                                block:^(NSArray *result, NSError *error) {
                                    if (!error) {
                                        //Successfully retrieved result
                                        successBlock(result);
                                    }
                                    else{
                                        //An error occurred
                                        errorBlock(error);
                                    }
                                }];
}

-(void)requestCalendarWithAreaId:(NSString *)areaId WithSuccessBlock:(void (^)(PFObject *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock{
    [PFCloud callFunctionInBackground:@"getCalendarForArea"
                       withParameters:@{@"areaId": areaId}
                                block:^(PFObject *result, NSError *error) {
                                    if (!error) {
                                        //Successfully retrieved result
                                        successBlock(result);
                                    }
                                    else{
                                        //An error occurred
                                        errorBlock(error);
                                    }
                                }];
}

-(void)requestReservationsForCurrentUserWithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock{
    [PFCloud callFunctionInBackground:@"getReservationsForClient"
                       withParameters:@{@"userFbId": _sharedUser.idFacebook}
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        //Successfully retrieved result
                                        successBlock(results);
                                    }
                                    else{
                                        //An error occurred
                                        errorBlock(error);
                                    }
                                }];
}

-(void)requestHistoryForCurrentUserWithSuccessBlock:(void (^)(NSArray *result))successBlock FailureBlock:(void(^)(NSError *error))errorBlock{
    [PFCloud callFunctionInBackground:@"getFinishedReservationsForClient"
                       withParameters:@{@"userFbId": _sharedUser.idFacebook}
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        //Successfully retrieved result
                                        successBlock(results);
                                    }
                                    else{
                                        //An error occurred
                                        errorBlock(error);
                                    }
                                }];
}

@end

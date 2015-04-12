//
//  Client.h
//  Fut5
//
//  Created by Jorge Vivas on 11/21/14.
//  Copyright (c) 2014 JorgeVivas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Client : NSObject <NSCoding>

@property (strong,nonatomic)NSString *idFacebook;
@property (strong,nonatomic)NSString *idUser;
@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *email;
@property (strong,nonatomic)NSString *birthday;
@property (strong,nonatomic)NSString *gender;
@property (strong,nonatomic)NSURL *pictureUrl;
@property (strong,nonatomic)NSString *phoneNumber;

// Optionals
@property (strong,nonatomic)NSString *location;

-(id)initClient:(NSString*)idFacebook idUser:(NSString*)idUser name:(NSString*)name email:(NSString*)email birthday:(NSString*)birthday gender:(NSString*)gender pictureUrl:(NSURL*)pictureUrl;

@end

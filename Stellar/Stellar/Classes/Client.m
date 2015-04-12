//
//  Client.m
//  Fut5
//
//  Created by Jorge Vivas on 11/21/14.
//  Copyright (c) 2014 JorgeVivas. All rights reserved.
//

#import "Client.h"

@implementation Client

-(id)initClient:(NSString*)idFacebook idUser:(NSString*)idUser name:(NSString*)name email:(NSString*)email birthday:(NSString*)birthday gender:(NSString*)gender pictureUrl:(NSURL*)pictureUrl{
    
    _idFacebook = idFacebook;
    _idUser = idUser;
    _name = name;
    _email = email;
    _birthday = birthday;
    _gender = gender;
    _pictureUrl = pictureUrl;
    
    return self;
}

#pragma mark - NSCoding support
-(void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:self.idFacebook forKey:@"idFacebook"];
    [encoder encodeObject:self.idUser forKey:@"idUser"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.pictureUrl forKey:@"pictureUrl"];
}

-(id)initWithCoder:(NSCoder*)decoder {
    self.idFacebook = [decoder decodeObjectForKey:@"idFacebook"];
    self.idUser = [decoder decodeObjectForKey:@"idUser"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.email = [decoder decodeObjectForKey:@"email"];
    self.birthday = [decoder decodeObjectForKey:@"birthday"];
    self.gender = [decoder decodeObjectForKey:@"gender"];
    self.pictureUrl = [decoder decodeObjectForKey:@"pictureUrl"];
    return self;
}

@end

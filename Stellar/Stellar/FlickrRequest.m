//
//  FlickrRequest.m
//  Stellar
//
//  Created by Jorge Vivas on 4/11/15.
//  Copyright (c) 2015 Appslab. All rights reserved.
//

#import "FlickrRequest.h"

#define kFlickrAPIKey           @"735c66927fdc9f8f2806804910145951"
#define kFlickrAPIURL           @"https://api.flickr.com/services/rest/"
#define kFlickrResponseFormat   @"json"


@implementation FlickrRequest {
    NSURLRequest* userIDRequest;
    NSURLRequest* imagesRequest;
}

- (void) createRequest {
    _arrayUrlImages = [[NSMutableArray alloc]init];
    _arrayTitles = [[NSMutableArray alloc]init];
    [self getUserID];
}

- (void) getUserID {
    NSString *methodName = @"flickr.people.findByUsername";
    NSString *userName = @"AstroSamantha";
    
    NSString *urlString = [NSString stringWithFormat:@"%@?method=%@&api_key=%@",kFlickrAPIURL,methodName,kFlickrAPIKey];
    urlString = [NSString stringWithFormat:@"%@&username=%@&format=%@&nojsoncallback=1", urlString,userName, kFlickrResponseFormat];
    
    NSURL *url = [NSURL URLWithString:urlString];
    userIDRequest = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:userIDRequest delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error = nil;
    
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (userIDRequest == connection.originalRequest) {
        NSString *userId = [[jsonDic objectForKey:@"user"] objectForKey:@"id"];
        if (userId != nil) {
            [self getPhotos:userId];
        }
    }
}

-(void) getPhotos:(NSString*) userId {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://api.flickr.com/services/rest"
      parameters:@{@"method":@"flickr.people.getPublicPhotos",
                   @"api_key":kFlickrAPIKey,
                   @"user_id":userId,
                   @"format":@"json",
                   @"nojsoncallback":@"1"}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *photos = [[responseObject objectForKey:@"photos"] objectForKey:@"photo"];
         for (NSDictionary *photo in photos) {
             NSString *title = [photo objectForKey:@"title"];
             [_arrayTitles addObject:title];
             NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com", [photo objectForKey:@"farm"]];
             photoURLString = [NSString stringWithFormat:@"%@/%@/%@_%@.jpg", photoURLString, [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
             [_arrayUrlImages addObject:photoURLString];
         }
             
             [self.delegate finishDownloadImages];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error.localizedDescription);
     }];
}

@end

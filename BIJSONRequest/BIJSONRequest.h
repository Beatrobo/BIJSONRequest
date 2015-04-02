#import "BIHTTPRequest.h"


typedef void (^BIJSONRequestCallback)(NSHTTPURLResponse* httpUrlResponse, id json, NSError* connectionError, NSError* jsonError);


@interface BIJSONRequest : BIHTTPRequest

- (void)sendJSONRequestWithCallback:(BIJSONRequestCallback)callback;

@end

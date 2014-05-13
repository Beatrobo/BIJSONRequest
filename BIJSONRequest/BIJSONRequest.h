#import <Foundation/Foundation.h>


typedef void (^BIJSONRequestCallback)(NSHTTPURLResponse* httpUrlResponse, id json, NSError* connectionError, NSError* jsonError);

typedef NS_ENUM(NSUInteger, BIHTTPRequestMethod) {
    BIHTTPRequestMethodGET    = 0,
    BIHTTPRequestMethodPOST   = 1,
    BIHTTPRequestMethodPUT    = 2,
    BIHTTPRequestMethodDELETE = 3,
};


@interface BIJSONRequest : NSObject

@property (nonatomic, readonly) NSString*           urlString;
@property (nonatomic, readonly) BIHTTPRequestMethod method;
@property (nonatomic, readonly) NSDictionary*       parameters;
- (instancetype)initWithURLString:(NSString*)urlString method:(BIHTTPRequestMethod)method parameters:(NSDictionary*)parameters;

@property (nonatomic, readonly) NSMutableURLRequest* urlRequest;

@property (nonatomic, readwrite) BOOL feedbackNetworkActivityIndicator; // Default is YES. flag for networkActivityIndicator (only iOS)

- (void)sendJSONRequestWithCallback:(BIJSONRequestCallback)callback;

+ (NSString*)HTTPMethodStringForRequestMethod:(BIHTTPRequestMethod)method;

@end

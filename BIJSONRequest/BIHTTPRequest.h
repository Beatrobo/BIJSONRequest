#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, BIHTTPRequestMethod) {
    BIHTTPRequestMethodGET    = 0,
    BIHTTPRequestMethodPOST   = 1,
    BIHTTPRequestMethodPUT    = 2,
    BIHTTPRequestMethodDELETE = 3,
};


typedef void (^BIHTTPRequestCallback)(NSHTTPURLResponse* httpUrlResponse, NSData* body, NSError* connectionError);


@interface BIHTTPRequest : NSObject

@property (nonatomic, copy, readonly) NSURL*              URL;
@property (nonatomic, readonly)       BIHTTPRequestMethod method;
@property (nonatomic, copy, readonly) NSDictionary*       query;
@property (nonatomic, copy, readonly) NSDictionary*       form;
@property (nonatomic, copy, readonly) NSURLRequest*       URLRequest;
- (instancetype)initWithURLString:(NSString*)URLString method:(BIHTTPRequestMethod)method query:(NSDictionary*)query form:(NSDictionary*)form;

@property (nonatomic, readwrite) BOOL feedbackNetworkActivityIndicator; // Default is YES. flag for networkActivityIndicator (only iOS)

- (void)sendHTTPRequestWithCallback:(BIHTTPRequestCallback)callback;

+ (NSString*)HTTPMethodStringForRequestMethod:(BIHTTPRequestMethod)method;

@end

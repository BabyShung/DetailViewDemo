//
//  UIImageView+M13AsynchronousImageView.h
//  M13AsynchronousImageView
//
//  Created by Brandon McQuilkin on 4/24/14.
//  Copyright (c) 2014 Brandon McQuilkin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    M13AsynchronousImageLoaderImageLoadedLocationNone,
    M13AsynchronousImageLoaderImageLoadedLocationCache,
    M13AsynchronousImageLoaderImageLoadedLocationLocalFile,
    M13AsynchronousImageLoaderImageLoadedLocationExternalFile
} M13AsynchronousImageLoaderImageLoadedLocation;

/**
 The completion block for loading an image.
 
 @param success Wether or not the load succeded.
 @param url     The URL of the image.
 @param target  The designated target for loading the image if a target exists. (Usually a UIImageView.)
 */
typedef void (^M13AsynchronousImageLoaderCompletionBlock)(BOOL success, M13AsynchronousImageLoaderImageLoadedLocation location, UIImage *image, NSURL *url, id target);


/*************************************
 
 ImageLoader Class
 
 *************************************/

@interface M13AsynchronousImageLoader : NSObject

/**@name Control Methods*/
/**
 Returns the default asynchronous image loader. The default loader is named "Default". This is the method most people will use to get the image loader.
 
 @return The default asynchronous image loader.
 */
+ (M13AsynchronousImageLoader *)defaultLoader;
/**
 Returns an asynchronous image loader with the given name. If no loader exists with that name, one will be created.
 
 @param name The name of the asynchronous image loader to retreive.
 
 @return The asynchronous image loader with the given name.
 */
+ (M13AsynchronousImageLoader *)loaderWithName:(NSString *)name;
/**
 Clears, and removes from memory the asynchronous image loader with the given name.
 
 @param name The name of the asynchronous image loader to cleanup.
 */
+ (void)cleanupLoaderWithName:(NSString *)name;
/**
 The cache all asynchronous image loaders will use, unless set otherwise.
 
 @return The default image Cache.
 */
+ (NSCache *)defaultImageCache;



- (void)cancelLoadingImageAtURL:(NSURL *)url;
/**
 Cancel loading the images set to be loaded for the given target.
 
 @param target The target to cancel loading the images for.
 */
- (void)cancelLoadingImagesForTarget:(id)target;
/**
 Cancels loading the image at the given URL, for the given target.
 
 @param url        The URL of the image to cancel.
 @param target     The target to cancel the loading of the image for.
 */
- (void)cancelLoadingImageAtURL:(NSURL *)url target:(id)target;




//The cache the image loader will use to cache the images.
@property (nonatomic, strong) NSCache *imageCache;

//The maximum number of images to load concurrently.
@property (nonatomic, assign) NSUInteger maximumNumberOfConcurrentLoads;

//The length of time to try and load an image before stopping.
@property (nonatomic, assign) NSTimeInterval loadingTimeout;

@end



/*************************************
 
 UIImageView in Here
 
 *************************************/

@interface UIImageView (M13AsynchronousImageView)

- (void)loadImageFromURLAtAmazonAsync:(NSURL *)url completion:(M13AsynchronousImageLoaderCompletionBlock)completion;

//Cancels loading all the images set to load for the image view.
- (void)cancelLoadingAllImages;

//Cancels loading the image at the given URL set to load for the image view.
- (void)cancelLoadingImageAtURL:(NSURL *)url;

@end

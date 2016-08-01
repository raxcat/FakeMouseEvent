//
//  FakeMouse.h
//  Pods
//
//  Created by brianliu on 2016/8/1.
//
//

#import <Foundation/Foundation.h>

@interface FakeMouse : NSObject

// Method to post mouse move event use input point
+(void)postRelativeMouseMove:(NSPoint)delta;
// Method to post mouse drag event use input point
+(void)postRelativeMouseDrag:(NSPoint)delta;

+(void) postDownOnCurrentPoint;
+(void) postMouseUpOnCurrentPoint;

// Method to post mouse down event use input point
// IOKit Coordinate System
+(void)postMouseDown:(NSPoint)currentPoint;
// Method to post mouse up event use input point
// IOKit Coordinate System
+(void)postMouseUp:(NSPoint)currentPoint;
// Method to post mouse drag event use input point
// IOKit Coordinate System
+(void)postMouseDrag:(NSPoint)currentPoint;


+(io_connect_t)serviceConnection;

@end

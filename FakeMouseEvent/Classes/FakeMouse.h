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
+(void)postRelativeLeftMouseDrag:(NSPoint)delta;

//Generate a left mouse down event.
+(void) postLeftMouseDownOnCurrentPoint;

//Generate a left mouse up event.
+(void) postLeftMouseUpOnCurrentPoint;

//Generate a right mouse down event.
+(void) postRightMouseDownOnCurrentPoint;

//Generate a right mouse up event.
+(void) postRightMouseUpOnCurrentPoint;

// Method to post mouse down event use input point
// IOKit Coordinate System(Zero Point ↖︎)
+(void)postLeftMouseDown:(NSPoint)currentPoint;

// Method to post mouse up event use input point
// IOKit Coordinate System(Zero Point ↖︎)
+(void)postLeftMouseUp:(NSPoint)currentPoint;

// Method to post mouse drag event use input point
// IOKit Coordinate System(Zero Point ↖︎)
+(void)postLeftMouseDrag:(NSPoint)currentPoint;

// Method to post mouse drag event use input point
// IOKit Coordinate System(Zero Point ↖︎)
+(void)postMouseWheelScroll:(NSPoint)delta;

@end

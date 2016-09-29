//
//  FakeMouse.m
//  Pods
//
//  Created by raxcat on 2016/8/1.
//
//

#import "FakeMouse.h"
@import IOKit;

static io_connect_t _serviceConnection = MACH_PORT_NULL;

/**
 Point in CoreGraphics Coordinate System(Zero point ↙︎).
 */
static NSPoint currentPoint(){
    NSPoint mouseLoc;
    mouseLoc = [NSEvent mouseLocation]; //get current mouse position
//    NSLog(@"Mouse location(Zero Point ↙︎): %f %f", mouseLoc.x, mouseLoc.y);
    return mouseLoc;
}

/**
 Point in IOKit Coordinate System(Zero point ↖︎).
 */
static NSPoint currentPointFlipped(){
    NSPoint point = [NSEvent mouseLocation];
    point = NSMakePoint(point.x, NSHeight([NSScreen mainScreen].frame) - point.y);
//    NSLog(@"Mouse location(Zero Point ↖︎): %f %f", point.x, point.y);
    return point;
}

@implementation FakeMouse

+ (io_connect_t)serviceConnection
{
    kern_return_t kr;
    mach_port_t masterPort, service, iter;
    if (_serviceConnection == MACH_PORT_NULL) {
        // get master post
        kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
        if (kr == KERN_SUCCESS && masterPort) {
            // get matching service
            kr = IOServiceGetMatchingServices(masterPort, IOServiceMatching(kIOHIDSystemClass), &iter);
            if (kr == KERN_SUCCESS) {
                service = IOIteratorNext(iter);
                // get service connection for later use
                kr = IOServiceOpen(service, mach_task_self(), kIOHIDParamConnectType, &_serviceConnection);
                IOObjectRelease(service);
                IOObjectRelease(iter);
                NSLog(@"%d", _serviceConnection);
            }
        }
        if (masterPort) {
            IOObjectRelease(masterPort);
        }
        if (kr != KERN_SUCCESS) {
            _serviceConnection = MACH_PORT_NULL;
        }
    }
    return _serviceConnection;
}

// Method to post mouse move event use input point
+ (void)postRelativeMouseMove:(NSPoint)delta
{
    NSPoint current = currentPointFlipped();
    IOGPoint locPoint;
    locPoint.x = (SInt16)(current.x);
    locPoint.y = (SInt16)(current.y);
    
    // create mouse move event for input point
    NXEvent mouseEvent = {NX_MOUSEMOVED, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouseMove.dx = (SInt32)delta.x;
    mouseEvent.data.mouseMove.dy = (SInt32)delta.y;
    mouseEvent.data.mouseMove.subx = 0;
    mouseEvent.data.mouseMove.suby = 0;
    mouseEvent.data.mouseMove.subType = NX_SUBTYPE_DEFAULT;
    // post mouse move event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_MOUSEMOVED, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetRelativeCursorPosition);
    }
}

// Method to post mouse drag event use input point
+ (void)postRelativeLeftMouseDrag:(NSPoint)delta
{
    NSPoint current = currentPointFlipped();
    current.x += delta.x;
    current.y += delta.y;
    [self postLeftMouseDrag:current];
    
    //    IOGPoint locPoint;
    //    locPoint.x = (SInt16)(current.x);
    //    locPoint.y = (SInt16)(current.y);
    //    // create mouse drag event for input point
    //    NXEvent mouseEvent = {NX_LMOUSEDRAGGED, {0, 0}, 0, -1, 0};
    //    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    //    mouseEvent.data.mouse.subx = delta.x;
    //    mouseEvent.data.mouse.suby = delta.y;
    //    mouseEvent.data.mouse.eventNum = 1;
    //    mouseEvent.data.mouse.click = 1;
    //    mouseEvent.data.mouse.pressure = 128;
    //    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    //    // post mouse drag event
    //    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    //    if (serviceConnection != MACH_PORT_NULL) {
    //        kern_return_t kr;
    //        kr = IOHIDPostEvent(serviceConnection, NX_LMOUSEDRAGGED, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetRelativeCursorPosition);
    //#ifdef __DEBUG__
    //        NSLog(@"Mouse Drag %ld", kr);
    //#endif
    //    }
}

+(void) postLeftMouseDownOnCurrentPoint{
    NSPoint current = currentPointFlipped();
    IOGPoint locPoint;
    locPoint.x = (SInt16)(current.x);
    locPoint.y = (SInt16)(current.y);
    // create mouse down event for input point
    NXEvent mouseEvent = {NX_LMOUSEDOWN, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouse.subx = 0;
    mouseEvent.data.mouse.suby = 0;
    mouseEvent.data.mouse.eventNum = 1;
    mouseEvent.data.mouse.click = 1;
    mouseEvent.data.mouse.pressure = 128;
    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    // post mouse down event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_LMOUSEDOWN, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetCursorPosition);
    }
}

+(void) postLeftMouseUpOnCurrentPoint{
    NSPoint current = currentPointFlipped();
    IOGPoint locPoint;
    locPoint.x = (SInt16)(current.x);
    locPoint.y = (SInt16)(current.y);
    // create mouse up event for input point
    NXEvent mouseEvent = {NX_LMOUSEUP, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouse.subx = 0;
    mouseEvent.data.mouse.suby = 0;
    mouseEvent.data.mouse.eventNum = 1;
    mouseEvent.data.mouse.click = 0;
    mouseEvent.data.mouse.pressure = 128;
    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    // post mouse up event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_LMOUSEUP, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetCursorPosition);
    }
}

+(void) postRightMouseDownOnCurrentPoint{
    NSPoint current = currentPointFlipped();
    IOGPoint locPoint;
    locPoint.x = (SInt16)(current.x);
    locPoint.y = (SInt16)(current.y);
    // create mouse down event for input point
    NXEvent mouseEvent = {NX_RMOUSEDOWN, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouse.subx = 0;
    mouseEvent.data.mouse.suby = 0;
    mouseEvent.data.mouse.eventNum = 1;
    mouseEvent.data.mouse.click = 1;
    mouseEvent.data.mouse.pressure = 128;
    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    // post mouse down event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_RMOUSEDOWN, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetCursorPosition);
    }
}
+(void) postRightMouseUpOnCurrentPoint{
    NSPoint current = currentPointFlipped();
    IOGPoint locPoint;
    locPoint.x = (SInt16)(current.x);
    locPoint.y = (SInt16)(current.y);
    // create mouse up event for input point
    NXEvent mouseEvent = {NX_RMOUSEUP, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouse.subx = 0;
    mouseEvent.data.mouse.suby = 0;
    mouseEvent.data.mouse.eventNum = 1;
    mouseEvent.data.mouse.click = 0;
    mouseEvent.data.mouse.pressure = 128;
    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    // post mouse up event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_RMOUSEUP, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetCursorPosition);
    }
}


// Method to post mouse down event use input point
// IOKit Coordinate System
+(void)postLeftMouseDown:(NSPoint)currentPoint
{
    IOGPoint locPoint;
    locPoint.x = currentPoint.x;
    locPoint.y = currentPoint.y;
    // create mouse down event for input point
    NXEvent mouseEvent = {NX_LMOUSEDOWN, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouse.subx = 0;
    mouseEvent.data.mouse.suby = 0;
    mouseEvent.data.mouse.eventNum = 1;
    mouseEvent.data.mouse.click = 1;
    //    mouseEvent.data.mouse.pressure = 128;
    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    // post mouse down event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_LMOUSEDOWN, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetCursorPosition);
    }
}

// Method to post mouse up event use input point
// IOKit Coordinate System
+(void)postLeftMouseUp:(NSPoint)currentPoint
{
    IOGPoint locPoint;
    locPoint.x = currentPoint.x;
    locPoint.y = currentPoint.y;
    // create mouse up event for input point
    NXEvent mouseEvent = {NX_LMOUSEUP, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouse.subx = 0;
    mouseEvent.data.mouse.suby = 0;
    mouseEvent.data.mouse.eventNum = 1;
    mouseEvent.data.mouse.click = 0;
    mouseEvent.data.mouse.pressure = 128;
    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    // post mouse up event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_LMOUSEUP, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetCursorPosition);
    }
}

// Method to post mouse drag event use input point
// IOKit Coordinate System
+(void)postLeftMouseDrag:(NSPoint)currentPoint
{
    IOGPoint locPoint;
    locPoint.x = currentPoint.x;
    locPoint.y = currentPoint.y;
    // create mouse drag event for input point
    NXEvent mouseEvent = {NX_LMOUSEDRAGGED, {0, 0}, 0, -1, 0};
    memset(&(mouseEvent.data), 0 , sizeof(mouseEvent.data));
    mouseEvent.data.mouse.subx = 0;
    mouseEvent.data.mouse.suby = 0;
    mouseEvent.data.mouse.eventNum = 1;
    mouseEvent.data.mouse.click = 1;
    mouseEvent.data.mouse.pressure = 128;
    mouseEvent.data.mouse.subType = NX_SUBTYPE_DEFAULT;
    // post mouse drag event
    io_connect_t serviceConnection = [FakeMouse serviceConnection];
    if (serviceConnection != MACH_PORT_NULL) {
        kern_return_t kr;
        kr = IOHIDPostEvent(serviceConnection, NX_LMOUSEDRAGGED, locPoint, &mouseEvent.data, kNXEventDataVersion, 0, kIOHIDSetCursorPosition);
    }
}

+(void)postMouseWheelScroll:(NSPoint)delta
{
    //credit: http://stackoverflow.com/questions/6126226/how-to-create-an-nsevent-of-type-nsscrollwheel
    
    CGWheelCount wheelCount = 1; // 1 for Y-only, 2 for Y-X, 3 for Y-X-Z
    //    int32_t xScroll = 0; // Negative for right
    int32_t yScroll = delta.y; // Negative for down
    CGEventRef cgEvent = CGEventCreateScrollWheelEvent(NULL, kCGScrollEventUnitLine, wheelCount, yScroll);
    
    // You can post the CGEvent to the event stream to have it automatically sent to the window under the cursor
    CGEventPost(kCGHIDEventTap, cgEvent);
}


@end

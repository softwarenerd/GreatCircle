//
//  The MIT License (MIT)
//
//  Copyright (c) 2016 Softwarenerd.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  CLLocation+GreatCircleExtensions.h
//  GreatCircle
//
//  Created by Brian Lambert on 6/5/16.
//  Copyright © 2016 Softwarenerd.
//

/*!
 *  @header
 *  This work was adapted from: https://github.com/chrisveness/geodesy
 *
 *  @abstract
 *  Geodesy functions for working with points and paths (distances, bearings, destinations, etc)
 *  on a spherical-model earth.
 */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* Adapted from:                                                                                  */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* Latitude/longitude spherical geodesy tools                         (c) Chris Veness 2002-2016  */
/*                                                                                   MIT Licence  */
/* www.movable-type.co.uk/scripts/latlong.html                                                    */
/* www.movable-type.co.uk/scripts/geodesy/docs/module-latlon-spherical.html                       */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

@import Foundation;
@import CoreLocation;

/*!
 *  @category
 *  CLLocation (GreatCircleExtensions)
 */
@interface CLLocation (GreatCircleExtensions)

/*!
 *  @brief
 *  Returns a location representing the point of intersection of two paths, each specified by a location and bearing.
 *
 *  @param location1 The first location.
 *  @param bearing1 The first bearing.
 *  @param location2 The second location.
 *  @param bearing2 The second bearing.
 *
 *  @return A location representing the point of intersection of two paths, if there is an intersection; otherwise, nil.
 */
+ (nullable CLLocation *)intersectionOfLocation:(nonnull CLLocation *)location1
                                     andBearing:(CLLocationDirection)bearing1
                                   withLocation:(nonnull CLLocation *)location2
                                     andBearing:(CLLocationDirection)bearing2;

/*!
 *  @brief
 *  Compares this location to the other location for equality.
 *
 *  @param otherLocation The other location to compare to this location.
 *
 *  @return YES if this location and the other location are equal; otherwise, NO.
 */
- (BOOL)isEqualToOtherLocation:(nonnull CLLocation *)otherLocation;

/*!
 *  @brief
 *  Returns the distance (in meters) between this location and the other location.
 *
 *  @param otherLocation The other location.
 *
 *  @return The distance (in meters) between this location and the other location.
 */
- (CLLocationDistance)distanceToOtherLocation:(nonnull CLLocation *)otherLocation;

/*!
 *  @brief
 *  Returns the initial bearing (in degrees) between this location and the other location.
 *
 *  @param otherLocation The other location.
 *
 *  @return The initial bearing (in degrees) between this location and the other location.
 */
- (CLLocationDirection)initialBearingToOtherLocation:(nonnull CLLocation *)otherLocation;

/*!
 *  @brief
 *  Returns the final bearing (in degrees) between this location and the other location.
 *
 *  @discussion
 *  The final bearing will differ from the initial bearing by varying degrees according to distance and latitude.
 *
 *  @param otherLocation The other location.
 *
 *  @return The final bearing (in degrees) between this location and the other location.
 */
- (CLLocationDirection)finalBearingToOtherLocation:(nonnull CLLocation *)otherLocation;

/*!
 *  @brief
 *  Returns a location representing the midpoint between this location and the other location.
 *
 *  @param otherLocation The other location.
 *
 *  @return A location representing the midpoint between this location and the other location.
 */
- (nonnull CLLocation *)midpointToOtherLocation:(nonnull CLLocation *)otherLocation;

/*!
 *  @brief
 *  Returns a location representing the point that lies at the specified bearing and distance from this location.
 *
 *  @param bearing The bearing, in degrees.
 *  @param distance The distance, in meters.
 *
 *  @return A location representing the point that lies at the specified bearing and distance from this location.
 */
- (nonnull CLLocation *)locationWithBearing:(CLLocationDirection)bearing
                                   distance:(CLLocationDistance)distance;

/*!
 *  @brief
 *  Returns the cross track distance of this location relative to the specified start location and end location.
 *
 *  @param startLocation The start location.
 *  @param endLocation The end location.
 *
 *  @return The cross track distance of this location relative to the specified start location and end location.
 */
- (CLLocationDistance)crossTrackDistanceToStartLocation:(nonnull CLLocation *)startLocation
                                            endLocation:(nonnull CLLocation *)endLocation;

// Max latitude.

/*!
 *  @brief
 *  Returns a location representing the cross track point of this location relative to the specified start location and end location.
 *
 *  @param startLocation The start location.
 *  @param endLocation The end location.
 *
 *  @return A location representing the cross track point of this location relative to the specified start location and end location.
 */
- (nonnull CLLocation *)crossTrackLocationToStartLocation:(nonnull CLLocation *)startLocation
                                              endLocation:(nonnull CLLocation *)endLocation;

@end

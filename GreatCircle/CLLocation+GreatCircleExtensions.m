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
//  CLLocation+GreatCircleExtensions.m
//  GreatCircle
//
//  Created by Brian Lambert on 6/5/16.
//  Copyright © 2016 Softwarenerd.
//

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* Adapted from:                                                                                  */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */
/* Latitude/longitude spherical geodesy tools                         (c) Chris Veness 2002-2016  */
/*                                                                                   MIT Licence  */
/* www.movable-type.co.uk/scripts/latlong.html                                                    */
/* www.movable-type.co.uk/scripts/geodesy/docs/module-latlon-spherical.html                       */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  */

#import "CLLocation+GreatCircleExtensions.h"

// Radius of the earth in meters.
const double kEarthRadiusInMeters = 6371000.0;

// Converts degrees to radians.
static inline double ConvertDegreesToRadians(double degrees)
{
    return degrees * M_PI / 180.0;
}

// Converts radians to degrees.
static inline double ConvertRadiansToDegrees(double radians)
{
    return radians * 180.0 / M_PI;
}

// Compares two doubles to the specified number of decimal places.
static inline BOOL CompareToDecimalPlaces(double value1, double value2, int decimalPlaces)
{
    NSInteger multiplier = pow(10, decimalPlaces);
    return round(value1 * multiplier) == round(value2 * multiplier);
}

// CLLocation (GreatCircleExtensions) implementation.
@implementation CLLocation (GreatCircleExtensions)

/**
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
                                     andBearing:(CLLocationDirection)bearing2
{
    // see http://williams.best.vwh.net/avform.htm#Intersection
    double φ1 = ConvertDegreesToRadians([location1 coordinate].latitude);
    double λ1 = ConvertDegreesToRadians([location1 coordinate].longitude);
    double φ2 = ConvertDegreesToRadians([location2 coordinate].latitude);
    double λ2 = ConvertDegreesToRadians([location2 coordinate].longitude);
    double θ13 = ConvertDegreesToRadians(bearing1);
    double θ23 = ConvertDegreesToRadians(bearing2);
    double Δφ = φ2 - φ1;
    double Δλ = λ2-λ1;
    
    double δ12 = 2.0 * asin(sqrt(sin(Δφ / 2.0) * sin(Δφ / 2.0) + cos(φ1) * cos(φ2) * sin(Δλ / 2.0) * sin(Δλ / 2.0)));
    if (δ12 == 0)
    {
        return nil;
    }
    
    // initial/final bearings between points
    double θ1 = acos((sin(φ2) - sin(φ1) * cos(δ12)) / (sin(δ12) * cos(φ1)));
    if (isnan(θ1))
    {
        // Protect against rounding.
        θ1 = 0.0;
    }
    
    double θ2 = acos((sin(φ1) - sin(φ2) * cos(δ12)) / (sin(δ12) * cos(φ2)));
    
    double θ12 = sin(λ2-λ1) > 0.0 ? θ1 : 2.0 * M_PI - θ1;
    double θ21 = sin(λ2-λ1) > 0.0 ? 2.0 * M_PI - θ2 : θ2;
    
    double α1 = fmod(θ13 - θ12 + M_PI, (2.0 * M_PI) - M_PI); // angle 2-1-3
    double α2 = fmod(θ21 - θ23 + M_PI, (2.0 * M_PI) - M_PI); // angle 1-2-3
    
    // Infinite intersections.
    if (sin(α1) == 0.0 && sin(α2) == 0.0)
    {
        return nil;
    }
    
    // Ambiguous intersection.
    if (sin(α1) * sin(α2) < 0.0)
    {
        return nil;
    }
    
    //α1 = abs(α1);
    //α2 = abs(α2);
    // ... Ed Williams takes abs of α1/α2, but seems to break calculation?
    
    double α3 = acos(-cos(α1) * cos(α2) + sin(α1) * sin(α2) * cos(δ12));
    double δ13 = atan2(sin(δ12) * sin(α1) * sin(α2), cos(α2) + cos(α1) * cos(α3));
    double φ3 = asin(sin(φ1) * cos(δ13) + cos(φ1) * sin(δ13) * cos(θ13));
    double Δλ13 = atan2(sin(θ13) * sin(δ13) * cos(φ1), cos(δ13) - sin(φ1) * sin(φ3));
    double λ3 = λ1 + Δλ13;
    
    return [[CLLocation alloc] initWithLatitude:ConvertRadiansToDegrees(φ3)
                                      longitude:fmod(ConvertRadiansToDegrees(λ3) + 540.0, 360.0) - 180.0];
}

/**
 *  @brief
 *  Compares this location to the other location for equality.
 *
 *  @param otherLocation The other location to compare to this location.
 *
 *  @return YES if this location and the other location are equal; otherwise, NO.
 */
- (BOOL)isEqualToOtherLocation:(nonnull CLLocation *)otherLocation
{
    return self == otherLocation || ([self coordinate].latitude == [otherLocation coordinate].latitude && [self coordinate].longitude == [otherLocation coordinate].longitude);
}

/**
 *  @brief
 *  Returns the distance (in meters) between this location and the other location.
 *
 *  @param otherLocation The other location.
 *
 *  @return The distance (in meters) between this location and the other location.
 */
- (CLLocationDistance)distanceToOtherLocation:(nonnull CLLocation *)otherLocation
{
    // If the the two locations are the same, return 0.0; otherwise, calculate the distance between them.
    if ([self isEqualToOtherLocation:otherLocation])
    {
        return 0.0;
    }
    else
    {
        double φ1 = ConvertDegreesToRadians([self coordinate].latitude);
        double λ1 = ConvertDegreesToRadians([self coordinate].longitude);
        double φ2 = ConvertDegreesToRadians([otherLocation coordinate].latitude);
        double λ2 = ConvertDegreesToRadians([otherLocation coordinate].longitude);
        double Δφ = φ2 - φ1;
        double Δλ = λ2 - λ1;
        double a = sin(Δφ / 2.0) * sin(Δφ / 2.0) + cos(φ1) * cos(φ2) * sin(Δλ / 2.0) * sin(Δλ / 2.0);
        double c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a));
        double d = kEarthRadiusInMeters * c;
        return d;
    }
}

/**
 *  @brief
 *  Returns the initial bearing (in degrees) between this location and the other location.
 *
 *  @param otherLocation The other location.
 *
 *  @return The initial bearing (in degrees) between this location and the other location.
 */
- (CLLocationDirection)initialBearingToOtherLocation:(nonnull CLLocation *)otherLocation
{
    // If the locations are the same, return 0.0; otherwise, calculate the initial bearing.
    if ([self isEqualToOtherLocation:otherLocation])
    {
        return 0.0;
    }
    else
    {
        double φ1 = ConvertDegreesToRadians([self coordinate].latitude);
        double φ2 = ConvertDegreesToRadians([otherLocation coordinate].latitude);
        double Δλ = ConvertDegreesToRadians([otherLocation coordinate].longitude - [self coordinate].longitude);
        
        // see http://mathforum.org/library/drmath/view/55417.html
        double y = sin(Δλ) * cos(φ2);
        double x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ);
        double θ = atan2(y, x);
        return fmod(ConvertRadiansToDegrees(θ) + 360.0, 360.0);
    };
}

/**
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
- (CLLocationDirection)finalBearingToOtherLocation:(nonnull CLLocation *)otherLocation
{
    // If the locations are the same, return 0.0; otherwise, calculate the final bearing.
    if ([self isEqualToOtherLocation:otherLocation])
    {
        return 0.0;
    }
    else
    {
        return fmod([otherLocation initialBearingToOtherLocation:self] + 180.0, 360.0);
    }
}

/**
 *  @brief
 *  Returns a location representing the midpoint between this location and the other location.
 *
 *  @param otherLocation The other location.
 *
 *  @return A location representing the midpoint between this location and the other location.
 */
- (nonnull CLLocation *)midpointToOtherLocation:(nonnull CLLocation *)otherLocation
{
    // If the locations are the same, return self; otherwise, return a location representing the midpoint.
    if ([self isEqualToOtherLocation:otherLocation])
    {
        return self;
    }
    else
    {
        // φm = atan2( sinφ1 + sinφ2, √( (cosφ1 + cosφ2⋅cosΔλ) ⋅ (cosφ1 + cosφ2⋅cosΔλ) ) + cos²φ2⋅sin²Δλ )
        // λm = λ1 + atan2(cosφ2⋅sinΔλ, cosφ1 + cosφ2⋅cosΔλ)
        // see http://mathforum.org/library/drmath/view/51822.html for derivation
        
        double φ1 = ConvertDegreesToRadians([self coordinate].latitude);
        double λ1 = ConvertDegreesToRadians([self coordinate].longitude);
        
        double φ2 = ConvertDegreesToRadians([otherLocation coordinate].latitude);
        double Δλ = ConvertDegreesToRadians([otherLocation coordinate].longitude - [self coordinate].longitude);
        
        double Bx = cos(φ2) * cos(Δλ);
        double By = cos(φ2) * sin(Δλ);
        
        double x = sqrt((cos(φ1) + Bx) * (cos(φ1) + Bx) + By * By);
        double y = sin(φ1) + sin(φ2);
        double φ3 = atan2(y, x);
        
        double λ3 = λ1 + atan2(By, cos(φ1) + Bx);
        
        return [[CLLocation alloc] initWithLatitude:ConvertRadiansToDegrees(φ3)
                                          longitude:fmod(ConvertRadiansToDegrees(λ3) + 540.0, 360.0) - 180.0]; // normalise to −180°..+180°
    }
}

/**
 *  @brief
 *  Returns a location representing the point that lies at the specified bearing and distance from this location.
 *
 *  @param bearing The bearing, in degrees.
 *  @param distance The distance, in meters.
 *
 *  @return A location representing the point that lies at the specified bearing and distance from this location.
 */
- (nonnull CLLocation *)locationWithBearing:(CLLocationDirection)bearing
                                   distance:(CLLocationDistance)distance
{
    // If the distance is 0.0, return self; otherwise, return a location at the specified bearing and distance.
    if (distance == 0.0)
    {
        return self;
    }
    else
    {
        // φ2 = asin( sinφ1⋅cosδ + cosφ1⋅sinδ⋅cosθ )
        // λ2 = λ1 + atan2( sinθ⋅sinδ⋅cosφ1, cosδ − sinφ1⋅sinφ2 )
        // see http://williams.best.vwh.net/avform.htm#LL
        
        double δ = distance / kEarthRadiusInMeters; // angular distance in radians
        double θ = ConvertDegreesToRadians(bearing);
        
        double φ1 = ConvertDegreesToRadians([self coordinate].latitude);
        double λ1 = ConvertDegreesToRadians([self coordinate].longitude);
        
        double φ2 = asin(sin(φ1)*cos(δ) + cos(φ1)*sin(δ)*cos(θ));
        double x = cos(δ) - sin(φ1) * sin(φ2);
        double y = sin(θ) * sin(δ) * cos(φ1);
        double λ2 = λ1 + atan2(y, x);
        
        return [[CLLocation alloc] initWithLatitude:ConvertRadiansToDegrees(φ2)
                                          longitude:fmod(ConvertRadiansToDegrees(λ2) + 540.0, 360.0) - 180.0];
    }
}

/**
 *  @brief
 *  Returns the cross track distance of this location relative to the specified start location and end location.
 *
 *  @param startLocation The start location.
 *  @param endLocation The end location.
 *
 *  @return The the midpoint location between this location and another location.
 */
- (CLLocationDistance)crossTrackDistanceToStartLocation:(nonnull CLLocation *)startLocation
                                            endLocation:(nonnull CLLocation *)endLocation
{
    if ([self isEqualToOtherLocation:startLocation] || [self isEqualToOtherLocation:endLocation])
    {
        return 0.0;
    }
    else
    {
        double δ13 = [startLocation distanceToOtherLocation:self] / kEarthRadiusInMeters;
        double θ13 = ConvertDegreesToRadians([startLocation initialBearingToOtherLocation:self]);
        double θ12 = ConvertDegreesToRadians([startLocation initialBearingToOtherLocation:endLocation]);
        
        double dxt = asin(sin(δ13) * sin(θ13 - θ12)) * kEarthRadiusInMeters;
        
        return dxt;
    }
}

/**
 *  @brief
 *  Returns a location representing the cross track point of this location relative to the specified start location and end location.
 *
 *  @param startLocation The start location.
 *  @param endLocation The end location.
 *
 *  @return A location representing the cross track point of this location relative to the specified start location and end location.
 */
- (nonnull CLLocation *)crossTrackLocationToStartLocation:(nonnull CLLocation *)startLocation
                                              endLocation:(nonnull CLLocation *)endLocation
{
    if ([self isEqualToOtherLocation:startLocation] || [self isEqualToOtherLocation:endLocation])
    {
        return self;
    }
    else
    {
        // Calculate the cross-track distance.
        CLLocationDistance crossTrackDistance = [self crossTrackDistanceToStartLocation:startLocation
                                                                            endLocation:endLocation];
        
        // If the cross track distance is effectively 0.0, then return self as it's a location on the track.
        if (CompareToDecimalPlaces(fabs(crossTrackDistance), 0.0, 3))
        {
            return self;
        }
        else
        {
            return [self locationWithBearing:fmod([startLocation initialBearingToOtherLocation:endLocation] + (crossTrackDistance < 0.0 ? 90.0 : 270.0) + 360.0, 360.0)
                                    distance:fabs(crossTrackDistance)];
        }
    }
}

@end
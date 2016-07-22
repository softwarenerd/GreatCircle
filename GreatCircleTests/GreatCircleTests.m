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
//  GreatCircleTests.m
//  GreatCircleTests
//
//  Created by Brian Lambert on 6/5/16.
//  Copyright © 2016 Softwarenerd.
//

@import XCTest;
@import CoreLocation;
#import "CLLocation+GreatCircleExtensions.h"

// Testing accuracy.
const double kAccuracyGood      = 0.01;
const double kAccuracyBetter    = 0.001;
const double kAccuracyBest      = 0.000000001;

// Distance between the Eiffel Tower and Versailles.
const CLLocationDistance kDistanceEiffelTowerToVersailles       = 14084.280704919687;

// The initial and final bearings between the Eiffel Tower and Versailles.
const CLLocationDistance kInitialBearingEiffelTowerToVersailles = 245.13460296861962;
const CLLocationDistance kFinalBearingEiffelTowerToVersailles   = 245.00325395138532;

// The initial and final bearings between Versailles and the Eiffel Tower.
const CLLocationDistance kInitialBearingVersaillesToEiffelTower = 65.003253951385318;
const CLLocationDistance kFinalBearingVersaillesToEiffelTower   = 65.134602968619618;

// GreatCircleTests interface.
@interface GreatCircleTests : XCTestCase
@end

// GreatCircleTests implementation.
@implementation GreatCircleTests
{
@private
    // Indian Pond location.
    CLLocation * _locationIndianPond;
    
    // Eiffel Tower location.
    CLLocation * _locationEiffelTower;
    
    // Versailles location.
    CLLocation * _locationVersailles;
}

// Returns a new instance of Indian Pond, in Piermond, NH. My old Boy Scout Camp.
+ (nonnull CLLocation *)newInstanceOfIndianPond
{
    return [[CLLocation alloc] initWithLatitude:43.930912 longitude:-72.053811];
}

// Setup.
- (void)setUp
{
    // Call the base class's method.
    [super setUp];
    
    // Setup locations.
    _locationIndianPond     = [GreatCircleTests newInstanceOfIndianPond];
    _locationEiffelTower    = [[CLLocation alloc] initWithLatitude:48.858158 longitude:2.294825];
    _locationVersailles     = [[CLLocation alloc] initWithLatitude:48.804766 longitude:2.120339];
}

// Teardown.
- (void)tearDown
{
    // Call the base class's method.
    [super tearDown];
}

// Tests initial bearing for two locations that are the same.
- (void)testInitialBearingSameLocations
{
    // Test. This tests the detection of the same object being passed in as the source and other location.
    CLLocationDirection bearing = [_locationIndianPond initialBearingToOtherLocation:_locationIndianPond];
    
    // Asset.
    XCTAssertEqual(bearing, 0.0);
}

// Tests initial bearing for two locations that are the equal.
- (void)testInitialBearingIdenticalLocations
{
    // Test. This tests the detection of equal objects being passed in as the source and other location.
    CLLocationDirection bearing = [[GreatCircleTests newInstanceOfIndianPond] initialBearingToOtherLocation:_locationIndianPond];
    
    // Asset.
    XCTAssertEqual(bearing, 0.0);
}

// Tests final bearing for two locations that are the same.
- (void)testFinalBearingSameLocations
{
    // Test. This tests the detection of the same object being passed in as the source and other location.
    CLLocationDirection bearing = [_locationIndianPond finalBearingToOtherLocation:_locationIndianPond];
    
    // Asset.
    XCTAssertEqual(bearing, 0.0);
}

// Tests final bearing for two locations that are equal.
- (void)testFinalBearingEqualLocations
{
    // Test. This tests the detection of equal objects being passed in as the source and other location.
    CLLocationDirection bearing = [[GreatCircleTests newInstanceOfIndianPond] finalBearingToOtherLocation:_locationIndianPond];
    
    // Asset.
    XCTAssertEqual(bearing, 0.0);
}

// Tests distance for two locations that are the same.
- (void)testDistanceSameLocations
{
    // Test. This tests the detection of the same object being passed in as the source and other location.
    CLLocationDistance distance = [_locationIndianPond distanceToOtherLocation:_locationIndianPond];
    
    // Asset.
    XCTAssertEqual(distance, 0.0);
}

// Tests distance for two locations that are equal.
- (void)testDistanceEqualLocations
{
    // Test. This tests the detection of equal objects being passed in as the source and other location.
    CLLocationDistance distance = [[GreatCircleTests newInstanceOfIndianPond] distanceToOtherLocation:_locationIndianPond];
    
    // Asset.
    XCTAssertEqual(distance, 0.0);
}

// Tests distance between Eiffel Tower and Versailles.
- (void)testDistanceEiffelTowerToVersailles
{
    // Test.
    CLLocationDistance distance = [_locationEiffelTower distanceToOtherLocation:_locationVersailles];
    
    // Asset.
    XCTAssertEqual(distance, kDistanceEiffelTowerToVersailles);
}

// Tests distance between Versailles and Eiffel Tower.
- (void)testDistanceVersaillesToEiffelTower
{
    // Test.
    CLLocationDistance distance = [_locationVersailles distanceToOtherLocation:_locationEiffelTower];
    
    // Asset.
    XCTAssertEqual(distance, kDistanceEiffelTowerToVersailles);
}

// Tests bearing between Eiffel Tower and Versailles.
- (void)testInitialBearingEiffelTowerToVersailles
{
    // Test.
    CLLocationDirection bearing = [_locationEiffelTower initialBearingToOtherLocation:_locationVersailles];
    
    // Asset.
    XCTAssertEqual(bearing, kInitialBearingEiffelTowerToVersailles);
}

// Tests initial bearing between Versailles and Eiffel Tower.
- (void)testInitialBearingVersaillesToEiffelTower
{
    // Test.
    CLLocationDirection bearing = [_locationVersailles initialBearingToOtherLocation:_locationEiffelTower];
    
    // Asset.
    XCTAssertEqual(bearing, kInitialBearingVersaillesToEiffelTower);
}

// Tests final bearing between Eiffel Tower and Versailles.
- (void)testFinalBearingEiffelTowerToVersailles
{
    // Test.
    CLLocationDirection bearing = [_locationEiffelTower finalBearingToOtherLocation:_locationVersailles];
    
    // Asset.
    XCTAssertEqual(bearing, kFinalBearingEiffelTowerToVersailles);
}


// Tests final bearing between Versailles and Eiffel Tower.
- (void)testFinalBearingVersaillesToEiffelTower
{
    // Test.
    CLLocationDirection bearing = [_locationVersailles finalBearingToOtherLocation:_locationEiffelTower];
    
    // Asset.
    XCTAssertEqual(bearing, kFinalBearingVersaillesToEiffelTower);
}

// Tests generating a location for Versailles based on bearing and distance.
- (void)testGenerateLocationVersailles
{
    // Test.
    CLLocation * locationVersailles = [_locationEiffelTower locationWithBearing:kInitialBearingEiffelTowerToVersailles
                                                                       distance:kDistanceEiffelTowerToVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy([_locationVersailles coordinate].latitude, [locationVersailles coordinate].latitude, kAccuracyBest);
    XCTAssertEqualWithAccuracy([_locationVersailles coordinate].longitude, [locationVersailles coordinate].longitude, kAccuracyBest);
}

// Tests generating a location for Eiffel Tower based on bearing and distance.
- (void)testGenerateLocationEiffelTower
{
    // Test.
    CLLocation * locationEiffelTower = [_locationVersailles locationWithBearing:kInitialBearingVersaillesToEiffelTower
                                                                       distance:kDistanceEiffelTowerToVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy([_locationEiffelTower coordinate].latitude, [locationEiffelTower coordinate].latitude, kAccuracyBest);
    XCTAssertEqualWithAccuracy([_locationEiffelTower coordinate].longitude, [locationEiffelTower coordinate].longitude, kAccuracyBest);
}

// Tests the midpoint between the Eiffel Tower and Versailles.
- (void)testMidpointEiffelTowerToVersailles
{
    // Test.
    CLLocation * midpointA = [_locationEiffelTower midpointToOtherLocation:_locationVersailles];
    
    
    // Assert.
    CLLocation * midpointB = [_locationEiffelTower locationWithBearing:kInitialBearingEiffelTowerToVersailles
                                                              distance:kDistanceEiffelTowerToVersailles / 2.0];
    CLLocationDistance distanceA = [_locationEiffelTower distanceToOtherLocation:midpointA];
    CLLocationDistance distanceB = [_locationVersailles distanceToOtherLocation:midpointB];
    XCTAssertEqualWithAccuracy(distanceA, kDistanceEiffelTowerToVersailles / 2.0, kAccuracyBest);
    XCTAssertEqualWithAccuracy(distanceB, kDistanceEiffelTowerToVersailles / 2.0, kAccuracyBest);
    XCTAssertEqualWithAccuracy([midpointA coordinate].latitude, [midpointB coordinate].latitude, kAccuracyBest);
    XCTAssertEqualWithAccuracy([midpointA coordinate].longitude, [midpointB coordinate].longitude, kAccuracyBest);
}

// Tests the midpoint between Versailles and the Eiffel Tower.
- (void)testMidpointVersaillesToEiffelTower
{
    // Test.
    CLLocation * midpointA = [_locationVersailles midpointToOtherLocation:_locationEiffelTower];
    
    // Assert.
    CLLocation * midpointB = [_locationVersailles locationWithBearing:kInitialBearingVersaillesToEiffelTower
                                                             distance:kDistanceEiffelTowerToVersailles / 2.0];
    CLLocationDistance distanceA = [_locationVersailles distanceToOtherLocation:midpointA];
    CLLocationDistance distanceB = [_locationVersailles distanceToOtherLocation:midpointB];
    XCTAssertEqualWithAccuracy(distanceA, kDistanceEiffelTowerToVersailles / 2.0, kAccuracyBest);
    XCTAssertEqualWithAccuracy(distanceB, kDistanceEiffelTowerToVersailles / 2.0, kAccuracyBest);
    XCTAssertEqualWithAccuracy([midpointA coordinate].latitude, [midpointB coordinate].latitude, kAccuracyBest);
    XCTAssertEqualWithAccuracy([midpointA coordinate].longitude, [midpointB coordinate].longitude, kAccuracyBest);
}

// Test intersection.
- (void)testIntersection
{
    // Setup.
    CLLocation * locationSaintGermain = [[CLLocation alloc] initWithLatitude:48.897728 longitude:2.094977];
    CLLocation * locationOrly = [[CLLocation alloc] initWithLatitude:48.747114 longitude:2.400526];
    
    // Test.
    CLLocation * location = [CLLocation intersectionOfLocation:locationSaintGermain
                                                    andBearing:[locationSaintGermain initialBearingToOtherLocation:locationOrly]
                                                  withLocation:_locationEiffelTower
                                                    andBearing:kInitialBearingEiffelTowerToVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy([location coordinate].latitude, 48.83569094988361, kAccuracyBest);
    XCTAssertEqualWithAccuracy([location coordinate].longitude, 2.2212520313073583, kAccuracyBest);
}


// Cross-track distance test of a point 90° and 200 meters away.
- (void)testCrossTrackDistance90Degrees200Meters
{
    // Setup.
    CLLocation * midpoint = [_locationEiffelTower midpointToOtherLocation:_locationVersailles];
    CLLocationDirection bearing = [_locationEiffelTower initialBearingToOtherLocation:_locationVersailles];
    CLLocationDirection testBearing = fmod(bearing + 90.0, 360.0);
    CLLocation * testLocation = [midpoint locationWithBearing:testBearing distance:200.0];
    
    // Test.
    CLLocationDistance distance = [testLocation crossTrackDistanceToStartLocation:_locationEiffelTower
                                                                      endLocation:_locationVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy(distance, 200.0, kAccuracyBetter);
}

// Cross-track distance test of a point 270° and 200 meters away.
- (void)testCrossTrackDistance270Degrees200Meters
{
    // Setup.
    CLLocation * midpoint = [_locationEiffelTower midpointToOtherLocation:_locationVersailles];
    CLLocationDirection bearing = [_locationEiffelTower initialBearingToOtherLocation:_locationVersailles];
    CLLocationDirection testBearing = fmod(bearing + 270.0, 360.0);
    CLLocation * testLocation = [midpoint locationWithBearing:testBearing distance:200.0];
    
    // Test.
    CLLocationDistance distance = [testLocation crossTrackDistanceToStartLocation:_locationEiffelTower
                                                                      endLocation:_locationVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy(distance, -200.0, kAccuracyBetter);
}

// Cross-track distance that should be very close to 0.
- (void)testCrossTrackDistanceThatShouldBeVeryCloseToZero
{
    // Setup.
    CLLocation * midpoint = [_locationEiffelTower midpointToOtherLocation:_locationVersailles];
    
    // Test.
    CLLocationDistance distance = fabs([midpoint crossTrackDistanceToStartLocation:_locationEiffelTower
                                                                       endLocation:_locationVersailles]);
    
    // Assert.
    XCTAssertEqualWithAccuracy(distance, 0.0, kAccuracyBest);
}

// Cross-track point for a point on the line.
- (void)testCrossTrackPointThatShouldBeOnTheLine
{
    // Setup.
    CLLocation * midpoint = [_locationEiffelTower midpointToOtherLocation:_locationVersailles];
    
    // Test.
    CLLocation * crossTrackLocation = [midpoint crossTrackLocationToStartLocation:_locationEiffelTower
                                                                      endLocation:_locationVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy([midpoint distanceFromLocation:crossTrackLocation], 0.0, kAccuracyBest);
}

// Cross-track point for a point on the line.
- (void)testCrossTrackPointA
{
    // Setup.
    CLLocation * midpoint = [_locationEiffelTower midpointToOtherLocation:_locationVersailles];
    CLLocationDirection bearing = [_locationEiffelTower initialBearingToOtherLocation:_locationVersailles];
    CLLocationDirection testBearing = fmod(bearing + 90.0, 360.0);
    CLLocation * testLocation = [midpoint locationWithBearing:testBearing distance:200.0];
    
    // Test.
    CLLocation * crossTrackLocation = [testLocation crossTrackLocationToStartLocation:_locationEiffelTower
                                                                          endLocation:_locationVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy([midpoint distanceFromLocation:crossTrackLocation], 0.0, kAccuracyGood);
}

// Cross-track point for a point on the line.
- (void)testCrossTrackPointB
{
    // Setup.
    CLLocation * midpoint = [_locationEiffelTower midpointToOtherLocation:_locationVersailles];
    CLLocationDirection bearing = [_locationEiffelTower initialBearingToOtherLocation:_locationVersailles];
    CLLocationDirection testBearing = fmod(bearing + 270.0, 360.0);
    CLLocation * testLocation = [midpoint locationWithBearing:testBearing distance:200.0];
    
    // Test.
    CLLocation * crossTrackLocation = [testLocation crossTrackLocationToStartLocation:_locationEiffelTower
                                                                          endLocation:_locationVersailles];
    
    // Assert.
    XCTAssertEqualWithAccuracy([midpoint distanceFromLocation:crossTrackLocation], 0.0, kAccuracyGood);
}

@end

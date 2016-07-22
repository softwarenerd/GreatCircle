//
//  Node.js Test program to generate values used to test GreatCircle from geodesy.
//  Created by Brian Lambert on 7/20/16.
//  Copyright © 2016 Softwarenerd.
// 

var LatLon = require('geodesy').LatLonSpherical;

// Create locations we use in GreatCircle unit tests.
var locationEiffelTower = new LatLon(48.858158, 2.294825);
var locationVersailles = new LatLon(48.804766, 2.120339);
var locationSaintGermain = new LatLon(48.897728, 2.094977)
var locationOrly = new LatLon(48.747114, 2.400526)

var distance, bearing, midpoint;

// Distance Eiffel Tower to Versailles.
distance = locationEiffelTower.distanceTo(locationVersailles);
console.log("Distance EiffelTower To Versailles ", distance);

// Bearing Eiffel Tower to Versailles.
bearing = locationEiffelTower.bearingTo(locationVersailles);
console.log("Initial Bearing EiffelTower To Versailles ", bearing);

// Final bearing Eiffel Tower to Versailles.
bearing = locationEiffelTower.finalBearingTo(locationVersailles);
console.log("Final Bearing Eiffel Tower To Versailles ", bearing);

// Bearing Versailles to Eiffel Tower.
bearing = locationVersailles.bearingTo(locationEiffelTower);
console.log("Initial Bearing Versailles To Eiffel Tower ", bearing);

// Final bearing Versailles to Eiffel Tower.
bearing = locationVersailles.finalBearingTo(locationEiffelTower);
console.log("Final Bearing Versailles To Eiffel Tower ", bearing);

// Cross track distance test.
midpoint = locationEiffelTower.midpointTo(locationVersailles);
var testBearing = (locationEiffelTower.bearingTo(locationVersailles) + 90.0) % 360.0;
var testLocation = midpoint.destinationPoint(200.0, testBearing);
distance = testLocation.crossTrackDistanceTo(locationEiffelTower, locationVersailles);
console.log("Cross track distance ", distance);

// Intersection test.
var intersection = LatLon.intersection(locationSaintGermain, locationSaintGermain.bearingTo(locationOrly), locationEiffelTower, locationEiffelTower.bearingTo(locationVersailles))
console.log(intersection)



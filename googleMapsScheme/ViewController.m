//
//  ViewController.m
//  googleMapsScheme
//
//  Created by Virendra on 7/14/15.


#import "ViewController.h"
#import "OpenInGoogleMapsController.h"
#import "MapRequestModel.h"

@interface ViewController ()

@property(nonatomic, strong) MapRequestModel *model;

@end

static NSString * const kOpenInMapsSampleURLScheme = @"googleMapsScheme://";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.model = [[MapRequestModel alloc] init];
    // Add some default values
//    [self pickLocationController:nil
//               pickedQueryString:@"1600 Amphitheatre Parkway, Mountain View, CA 94043"
//                        forGroup:kLocationGroupStart];
//    [self typeOfMapChanged:self.pickMapTypeSC];
    
    // And let's set our callback URL right away!
    [OpenInGoogleMapsController sharedInstance].callbackURL =
    [NSURL URLWithString:kOpenInMapsSampleURLScheme];
    
//    NSString *myURLScheme = @"googleMapsScheme://";
//    NSURL *myCallbackURL = [NSURL URLWithString:myURLScheme];
//    [OpenInGoogleMapsController sharedInstance].callbackURL = myCallbackURL;
    
    
    NSLog(@"%@",[NSURL URLWithString:kOpenInMapsSampleURLScheme]);
    
    
    [OpenInGoogleMapsController sharedInstance].fallbackStrategy =
    kGoogleMapsFallbackChromeThenAppleMaps;
    
    
    if (![[OpenInGoogleMapsController sharedInstance] isGoogleMapsInstalled]) {
        NSLog(@"Google Maps not installed, but using our fallback strategy");
    }
    
   // [self openDirectionsInGoogleMaps];
    
    //[self openMapInGoogleMaps];
    
    
   // GoogleMapDefinition *definition = [[GoogleMapDefinition alloc] init];
   // definition.queryString = @"123 Main Street, Anytown, CA";
   // definition.viewOptions = kGoogleMapsViewOptionSatellite | kGoogleMapsViewOptionTraffic;
   // [[OpenInGoogleMapsController sharedInstance] openMap:definition];
    
    
    GoogleDirectionsDefinition *definition = [[GoogleDirectionsDefinition alloc] init];
    definition.startingPoint = [GoogleDirectionsWaypoint
                                waypointWithQuery:@"La Taqueria, 2889 Mission St San Francisco, CA 94110"];
    definition.destinationPoint = [GoogleDirectionsWaypoint
                                   waypointWithQuery:@"Delicious Mexican Eatery, 3314 Fort Blvd, El Paso, TX 79930"];
    definition.travelMode = kGoogleMapsTravelModeDriving;
    [[OpenInGoogleMapsController sharedInstance] openDirections:definition];
    
    /*
    GoogleDirectionsDefinition *definition = [[GoogleDirectionsDefinition alloc] init];
    definition.startingPoint = [GoogleDirectionsWaypoint
                                waypointWithLocation:CLLocationCoordinate2DMake(51.487242,-0.124402)];
    definition.destinationPoint = [GoogleDirectionsWaypoint
                                   waypointWithQuery:@"221B Baker Street, London"];
    definition.travelMode = kGoogleMapsTravelModeBiking;
    [[OpenInGoogleMapsController sharedInstance] openDirections:definition];*/
}


- (void)openDirectionsInGoogleMaps {
    GoogleDirectionsDefinition *directionsDefinition = [[GoogleDirectionsDefinition alloc] init];
    if (self.model.startCurrentLocation) {
        directionsDefinition.startingPoint = nil;
    } else {
        GoogleDirectionsWaypoint *startingPoint = [[GoogleDirectionsWaypoint alloc] init];
        startingPoint.queryString = self.model.startQueryString;
        startingPoint.location = self.model.startLocation;
        directionsDefinition.startingPoint = startingPoint;
    }
    if (self.model.destinationCurrentLocation) {
        directionsDefinition.destinationPoint = nil;
    } else {
        GoogleDirectionsWaypoint *destination = [[GoogleDirectionsWaypoint alloc] init];
        destination.queryString = self.model.destinationQueryString;
        destination.location = self.model.desstinationLocation;
        directionsDefinition.destinationPoint = destination;
    }
    directionsDefinition.travelMode = [self travelModeAsGoogleMapsEnum:self.model.travelMode];
    [[OpenInGoogleMapsController sharedInstance] openDirections:directionsDefinition];
}
//
//- (void)openMapInGoogleMaps {
//    GoogleMapDefinition *mapDefinition = [[GoogleMapDefinition alloc] init];
//    mapDefinition.queryString = self.model.startQueryString;
//    mapDefinition.center = self.model.startLocation;
//    mapDefinition.viewOptions |= (self.satelliteSwitch.isOn) ? kGoogleMapsViewOptionSatellite : 0;
//    mapDefinition.viewOptions |= (self.trafficSwitch.isOn) ? kGoogleMapsViewOptionTraffic : 0;
//    mapDefinition.viewOptions |= (self.transitSwitch.isOn) ? kGoogleMapsViewOptionTransit : 0;
//    if (mapDefinition.queryString && CLLocationCoordinate2DIsValid(mapDefinition.center)) {
//        // Sets some reasonable bounds for the "Pizza near Times Square" types of maps
//        mapDefinition.zoomLevel = 15.0f;
//    }
//    [[OpenInGoogleMapsController sharedInstance] openMap:mapDefinition];
//    
//}

// Convert our app's "travel mode" to the official Google Enum
- (GoogleMapsTravelMode)travelModeAsGoogleMapsEnum:(TravelMode)appTravelMode {
    switch (appTravelMode) {
        case kTravelModeBicycling:
            return kGoogleMapsTravelModeBiking;
        case kTravelModeDriving:
            return kGoogleMapsTravelModeDriving;
        case kTravelModePublicTransit:
            return kGoogleMapsTravelModeTransit;
        case kTravelModeWalking:
            return kGoogleMapsTravelModeWalking;
        case kTravelModeNotSpecified:
            return 0;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  HCAppDelegate.m
//  HelloCBL
//
//  Created by Amy Kurtzman on 11/17/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "HCAppDelegate.h"
#import "CouchbaseLite/CouchbaseLite.h"
#import "CouchbaseLite/CBLDocument.h"


@implementation HCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    // Run the method that creates a database, and then creates, stores, and retrieves a document
    BOOL result = [self sayHello];
    NSLog (@"This Hello Couchbase Lite run %@!", (result ? @"was a total success" : @"was a dismal failure"));
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// creates a database, and then creates, stores, and retrieves a document
- (BOOL) sayHello {
    

    // holds error error messages from unsuccessful calls
    NSError *error;
    
    // create a shared instance of CBLManager
    CBLManager *manager = [CBLManager sharedInstance];
    if (!manager) {
        NSLog (@"Cannot create shared instance of CBLManager");
        return NO;
    }
    
    // create a name for the database and make sure the name is legal
    NSString *dbname = @"my-new-database";
    if (![CBLManager isValidDatabaseName: dbname]) {
        NSLog (@"Bad database name");
        return NO;
    }
    
    // create a new database
    CBLDatabase *database = [manager createDatabaseNamed: dbname error: &error];
    if (!database) {
        NSLog (@"Cannot create database. Error message: %@", error.localizedDescription);
        return NO;
    }
    
    // create an object that contains data for the new document
    NSDictionary *myDictionary =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"Hello Couchbase Lite!", @"message",
            [[NSDate date] description], @"timestamp",
            nil];
    
    // display the data for the new document
    NSLog(@"This is the data for the document: %@", myDictionary);
    
    // create an empty document
    CBLDocument* doc = [database untitledDocument];
    
    // write the document to the database
    CBLRevision *newRevision = [doc putProperties: myDictionary error: &error];
    if (!newRevision) {
        NSLog (@"Cannot write document to database. Error message: %@", error.localizedDescription);
    }
    
    // save the ID of the new document
    NSString *docID = doc.documentID;
    
    // retrieve the document from the database
    CBLDocument *retrievedDoc = [database documentWithID: docID];
    
    // display the retrieved document
    NSLog(@"The retrieved document contains: %@", retrievedDoc.properties);
    
    return YES;

}

@end

//
//  AGDrop.h
//  DropCloud
//
//  Created by Arvid Gerstmann on 30/08/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AGDrop : NSManagedObject

@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *shareURL;
@property (nonatomic, retain) NSDate *createdDate;

@end

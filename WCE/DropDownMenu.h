//
//  DropDownMenu.h
//  WCE
//
//  Created by Sushruth Chandrasekar on 3/1/13.
//  Copyright (c) 2013  Brian Beckerle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownMenu : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *dataArray;
}

@property (nonatomic, retain) NSArray *dataArray;


@end
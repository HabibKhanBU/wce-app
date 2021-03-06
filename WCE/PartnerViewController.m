//
//  PartnerViewController.m
//  WCE
//
//  Created by  Brian Beckerle on 4/24/13.
//

#import "PartnerViewController.h"
#import "DataAccess.h"
#import "Partner.h"

@interface PartnerViewController ()

@end

@implementation PartnerViewController
@synthesize partnerTableView, partners, sharedUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    sharedUser = [User sharedUser];
    
    DataAccess *db = [[DataAccess alloc] init];
    
    Location *curLocation = [Location sharedLocation];
    
    partners = [[NSMutableArray alloc] init];
    
    partners = [db getPartnersForLocationName:[curLocation name]];
}

    
-(void)viewWillAppear:(BOOL)animated{
    //update our array and tableView
    DataAccess *db = [[DataAccess alloc] init];
    
    Location *curLocation = [Location sharedLocation];
    
    partners = [db getPartnersForLocationName:[curLocation name]];
    
    [partnerTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**TableView Methods**/
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    /**set the region name to that chosen in the table**/
    int idx = indexPath.row;
    Partner *selectedPartner;
    
    if (idx >= [partners count]){ //[[sharedUser savedPartners] count]){
        [self performSegueWithIdentifier:@"pushAddPartner" sender:self];
    }else if  ([partnerTableView isEditing]){
        selectedPartner = [partners objectAtIndex:idx];
        [sharedUser setIsEditingPartner:YES];
        [sharedUser setEditingPartner:selectedPartner];
        [self performSegueWithIdentifier:@"pushAddPartner" sender:self];
    }else{
        selectedPartner = [partners objectAtIndex:idx];
        
        [sharedUser setSharedPartner:selectedPartner];
        
        NSLog(@"%@", selectedPartner);
        
        [self performSegueWithIdentifier:@"pushPartnerForms" sender:self];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    NSLog(@"#of saved partners: %d", [partners count]);
	return [partners count] + 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//initialize a cell
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartnerCellID"];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PartnerCell"];
	}
	//get the relevant partner from the array
    NSString *name;
    if (indexPath.row == [partners count]){
        name = @"Add New Partner";
    }else {
        Partner *curPartner = [partners objectAtIndex:indexPath.row]; 
        name =  curPartner.name;
	}
	cell.textLabel.text = name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}


/**Editing Methods**/

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [partners count]) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DataAccess *db = [[DataAccess alloc] init];
        
        [db deletePartner:[partners objectAtIndex:indexPath.row]];
        [partners removeObjectAtIndex:indexPath.row];
         
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(IBAction)enterEditingMode:(id)sender{
    if([partnerTableView isEditing]){
        NSLog(@"Exited editing mode");
        [partnerTableView setEditing:NO animated:YES];
    }else {
        NSLog(@"Entered editing mode");
        [partnerTableView setEditing:YES animated:YES];
        [partnerTableView setAllowsSelectionDuringEditing:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"pushAddPartner"] && [sharedUser isEditingPartner]){
        [[[segue destinationViewController] navigationItem] setTitle:@"Editing Partner"];
    }else{
        [[[segue destinationViewController] navigationItem] setTitle:[[sharedUser sharedPartner] name]];
        NSLog(@"shared  partner: %@", [sharedUser sharedPartner]);
    }
}

@end

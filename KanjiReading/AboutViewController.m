//
//  AboutViewController.m
//  KanjiReading
//
//  Created by Osamu Noguchi on 8/11/13.
//  Copyright (c) 2013 Osamu Noguchi. All rights reserved.
//

#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ThirdPartyNoticesViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize tableView;

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
	
    [self.navigationItem setTitle:NSLocalizedString(@"ABOUT", @"")];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CLOSE", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBAction

- (void)cancelButtonPressed {
    [self performSegueWithIdentifier:@"MasterViewFromAboutView" sender:self];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    }
    
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80.f;
        }
    }
    
    return 40.f;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return  @"";
}

- (UITableViewCell*)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.imageView.image = [UIImage imageNamed:@"icon.png"];
            cell.imageView.layer.cornerRadius = 10.f;
            cell.imageView.clipsToBounds = YES;
            
            UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 200, 15)];
            [appNameLabel setText:NSLocalizedString(@"KANJIREADING", @"")];
            [appNameLabel setTextColor:[UIColor blackColor]];
            [appNameLabel setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:appNameLabel];
            
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            UILabel *appVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 200, 15)];
            [appVersionLabel setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"VERSION", @""), version]];
            [appVersionLabel setFont:[UIFont systemFontOfSize:10.f]];
            [appVersionLabel setTextColor:[UIColor blackColor]];
            [appVersionLabel setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:appVersionLabel];
            
            UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 52, 200, 15)];
            [authorLabel setText:[NSString stringWithFormat:@"%@: Osamu Noguchi", NSLocalizedString(@"AUTHOR", @"")]];
            [authorLabel setFont:[UIFont systemFontOfSize:10.f]];
            [authorLabel setTextColor:[UIColor blackColor]];
            [authorLabel setBackgroundColor:[UIColor clearColor]];
            [cell addSubview:authorLabel];
        } else if (indexPath.row == 1) {
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setText:NSLocalizedString(@"SOURCE_CODE_REPOSITORY", @"")];
        }else {
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setText:NSLocalizedString(@"MORE_APPS", @"")];
        }
    } else if (indexPath.section == 1) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:NSLocalizedString(@"THIRD_PARTY_NOTICES", @"")];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
    } else if (indexPath.section == 2) {
        cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:NSLocalizedString(@"RATE_THIS_APP", @"")];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //[SharedAppDelegate.tracker sendEventWithCategory:@"uiAction" withAction:@"buttonPress" withLabel:@"sourceCodeRepository" withValue:nil];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Atrac613/KanjiReading-iOS"]];
        } else if (indexPath.row == 2) {
            //[SharedAppDelegate.tracker sendEventWithCategory:@"uiAction" withAction:@"buttonPress" withLabel:@"moreApps" withValue:nil];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/osamunoguchi"]];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //[SharedAppDelegate.tracker sendEventWithCategory:@"uiAction" withAction:@"buttonPress" withLabel:@"thirdPartyNotices" withValue:nil];
            
            ThirdPartyNoticesViewController *thirdPartyNoticesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdPartyNoticesViewController"];
            [self presentViewController:thirdPartyNoticesViewController animated:YES completion:nil];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //[SharedAppDelegate.tracker sendEventWithCategory:@"uiAction" withAction:@"buttonPress" withLabel:@"rateThisApp" withValue:nil];
            
            UITableViewCell *cell = [tv cellForRowAtIndexPath:indexPath];
            
            if (cell.textLabel.text.length > 0) {
                [cell.textLabel setText:@""];
                
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [indicator setFrame:CGRectMake(0, 0, 30, 30)];
                [indicator setCenter:CGPointMake(cell.contentView.frame.size.width/2, cell.contentView.frame.size.height/2)];
                
                [indicator startAnimating];
                [cell.contentView addSubview:indicator];
            }
            
            [self presentAppStoreForID:[NSNumber numberWithInt:kAppId] withDelegate:self withURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", kAppId]]];
        }
    }
}

#pragma mark SKStoreProductViewController

// Thanks: http://stackoverflow.com/questions/12475568/appstore-as-modal-view-in-ios6

- (void)presentAppStoreForID:(NSNumber *)appStoreID withDelegate:(id<SKStoreProductViewControllerDelegate>)delegate withURL:(NSURL *)appStoreURL
{
    if(NSClassFromString(@"SKStoreProductViewController")) { // Checks for iOS 6 feature.
        
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init];
        storeController.delegate = delegate; // productViewControllerDidFinish
        
        // Example app_store_id (e.g. for Words With Friends)
        // [NSNumber numberWithInt:322852954];
        
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : appStoreID };
        
        
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                [self presentViewController:storeController animated:YES completion:nil];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Sorry" message:@"There was a problem displaying the app." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
            }
        }];
        
        
    } else { // Before iOS 6, we can only open the URL
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [tableView reloadData];
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end

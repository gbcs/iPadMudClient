//
//  HelpViewController.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/12/13.
//
//

#import "HelpViewController.h"

@interface HelpViewController () {
    
 
    __weak IBOutlet UIWebView *helpView;
}

@end

@implementation HelpViewController

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
    
    NSDictionary *sectionList = @{
                                  [NSNumber numberWithInt:kHelpSectionMain] : @"main",
                                  [NSNumber numberWithInt:kHelpSectionAddCharacter ] : @"character",
                                  [NSNumber numberWithInt:kHelpSectionAlias ] : @"alias",
                                  [NSNumber numberWithInt:kHelpSectionMacro ] : @"macro",
                                  [NSNumber numberWithInt:kHelpSectionTrigger ] : @"trigger",
                                  [NSNumber numberWithInt:kHelpSectionSpeedwalking ] : @"speedwalking",
                                  [NSNumber numberWithInt:kHelpSectionSettings ] : @"settings",
                                  [NSNumber numberWithInt:kHelpSectionVariable ] : @"variable"
                                  
                                   };
    NSString *urlStr = [NSString stringWithFormat:@"http://example.com/help/%@.html", [sectionList objectForKey:[NSNumber numberWithInt:self.section]]];
    
    
    if (self.section == kHelpSectionMain) {
        urlStr = @"http://example.com/help/";
    }
   
    [helpView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userDidTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end

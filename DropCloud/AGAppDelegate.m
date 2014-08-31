//
//  AGAppDelegate.m
//  DropCloud
//
//  Created by Arvid Gerstmann on 17/05/14.
//  Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGAppDelegate.h"
#import "AGStatusItemView.h"
#import "AGCloudCommunication.h"
#import "AGCredentials.h"
#import "NSAttributedString+Hyperlink.h"
#import "AGLoadingStatusItemView.h"
#import "AGPreferences.h"
#import "CoreDataManager.h"
#import "AGDrop.h"
#import "NSManagedObject+ActiveRecord.h"

@interface AGAppDelegate ()

#pragma mark General Properties
@property (nonatomic, strong) AGCloudCommunication *cloud;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) AGLoadingStatusItemView *statusItemView;
@property (nonatomic, strong) NSMutableArray *recentDrops;


#pragma mark Main Window
@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *noRecentDrops;
@property (weak) IBOutlet NSMenuItem *settingsMenuItem;
@property (weak) IBOutlet NSMenuItem *aboutMenuItem;
@property (weak) IBOutlet NSMenuItem *quitMenuItem;

@property (weak) IBOutlet NSTextField *serverSettingsLabel;
@property (weak) IBOutlet NSTextField *serverUrlTextfield;
@property (weak) IBOutlet NSTextField *serverPathTextfield;
@property (weak) IBOutlet NSButton *selfSignedCertsCheckbox;

@property (weak) IBOutlet NSTextField *userSettingsLabel;
@property (weak) IBOutlet NSTextField *usernameTextfield;
@property (weak) IBOutlet NSSecureTextField *passwordTextfield;

@property (weak) IBOutlet NSButton *saveButton;


#pragma mark About Window
@property (unsafe_unretained) IBOutlet NSWindow *aboutWindow;
@property (weak) IBOutlet NSTextField *developedByLabel;
@property (weak) IBOutlet NSTextField *aboutTextfield;
@property (weak) IBOutlet NSButton *updatesButton;


#pragma mark Actions
- (IBAction)settingsAction:(id)sender;
- (IBAction)aboutAction:(id)sender;
- (IBAction)quitAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end

@implementation AGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Init.
}

- (void)awakeFromNib {
    [self commonInit];
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
    self.statusItemView = [[AGLoadingStatusItemView alloc] initWithStatusItem:self.statusItem];
    self.statusItemView.menu = self.statusMenu;
    self.statusItemView.image = [NSImage imageNamed:@"menubar_icon"];
    self.statusItemView.highlightImage = [NSImage imageNamed:@"menubar_icon_inverse"];
    [self.statusItemView addObserver:@selector(fileDropped:) withTarget:self forEvent:AGStatusItemEventFileDropped];
    self.statusItem.view = self.statusItemView;

    self.cloud = [AGCloudCommunication sharedManager];
    self.cloud.baseUrl = [AGPreferences sharedInstance].baseURL;
    self.cloud.remoteDirectoryPath = [AGPreferences sharedInstance].remoteDirectoryPath;

    self.serverUrlTextfield.stringValue = self.cloud.baseUrl ?: @"";
    self.serverPathTextfield.stringValue = self.cloud.remoteDirectoryPath ?: @"";

    [self.aboutTextfield setAllowsEditingTextAttributes:YES];
    [self.aboutTextfield setSelectable:YES];

    NSURL *url = [NSURL URLWithString:@"https://github.com/leandros/owndrop"];
    NSFont *font = [NSFont fontWithName:@"HelveticaNeue-Light" size:13];
    NSDictionary *attr = @{
            NSFontAttributeName : font
    };
    NSMutableAttributedString *aboutString = [[NSMutableAttributedString alloc]
            initWithString:NSLocalizedString(@"abouttext", nil) attributes:attr];
    [aboutString appendAttributedString:[NSAttributedString hyperlinkFromString:@"https://GitHub.com/Leandros/ownDrop" withURL:url attributes:attr]];
    [aboutString appendAttributedString:[[NSAttributedString alloc] initWithString:@")" attributes:attr]];
    self.aboutTextfield.attributedStringValue = aboutString;

    NSFont *boldFont = [NSFont fontWithName:@"HelveticaNeue-Bold" size:13];
    NSDictionary *boldAttr = @{
            NSFontAttributeName : boldFont
    };
    self.developedByLabel.attributedStringValue = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"developedby", nil) attributes:boldAttr];
    [self.updatesButton setTitle:NSLocalizedString(@"checkforupdates", nil)];

    if (self.recentDrops.count) {
        [self.statusMenu removeItem:self.noRecentDrops];
    }

    NSInteger count = self.recentDrops.count;
    NSInteger index = count;
    for (AGDrop *drop in self.recentDrops) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:drop.fileName.lastPathComponent action:@selector(recentDropSelected:) keyEquivalent:@""];
        [item setEnabled:YES];
        [self.statusMenu insertItem:item atIndex:count - index];
        index--;
    }

    self.settingsMenuItem.title = NSLocalizedString(@"settings", nil);
    self.aboutMenuItem.title = NSLocalizedString(@"about", nil);
    self.quitMenuItem.title = NSLocalizedString(@"quit", nil);

    self.serverSettingsLabel.stringValue = NSLocalizedString(@"serversettings", nil);
    [self.serverUrlTextfield.cell setPlaceholderString:NSLocalizedString(@"serverurl", nil)];
    [self.serverPathTextfield.cell setPlaceholderString:NSLocalizedString(@"serverpath", nil)];

    self.userSettingsLabel.stringValue = NSLocalizedString(@"usersettings", nil);
    [self.usernameTextfield.cell setPlaceholderString:NSLocalizedString(@"username", nil)];
    if ([AGCredentials credentials].userName.length) {
        self.usernameTextfield.stringValue = [AGCredentials credentials].userName ?: @"";
    }
    [self.passwordTextfield.cell setPlaceholderString:NSLocalizedString(@"password", nil)];
    // Shows the Keychain unlock dialog.
    if ([AGCredentials credentials].password.length) {
        self.passwordTextfield.stringValue = [AGCredentials credentials].password ?: @"";
    } else {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = NSLocalizedString(@"enterpassword", nil);

        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }

    self.selfSignedCertsCheckbox.title = NSLocalizedString(@"allowselfsignedcerts", nil);
    self.selfSignedCertsCheckbox.state = [AGPreferences sharedInstance].allowSelfSignedSSLCerts ? NSOnState : NSOffState;
}

- (void)commonInit {
    [CoreDataManager sharedManager].modelName = @"Model";

    NSArray *drops = [AGDrop allWithOrder:[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]];

    NSUInteger length = drops.count < 5 ? drops.count : 5;
    self.recentDrops = [[drops subarrayWithRange:NSMakeRange(0, length)] mutableCopy];
}


#pragma mark -
#pragma mark Menu Actions -

- (IBAction)settingsAction:(id)sender {
    [self.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)aboutAction:(id)sender {
    [self.aboutWindow makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)quitAction:(id)sender {
    [NSApp terminate:self];
}

- (IBAction)saveAction:(id)sender {
    [AGPreferences sharedInstance].baseURL = self.serverUrlTextfield.stringValue;
    [AGPreferences sharedInstance].remoteDirectoryPath = self.serverPathTextfield.stringValue;
    if (self.usernameTextfield.stringValue.length && self.passwordTextfield.stringValue.length) {
        [[AGCredentials credentials] setName:self.usernameTextfield.stringValue password:self.passwordTextfield.stringValue];
    }

    if (self.selfSignedCertsCheckbox.state == NSOnState) {
        [AGPreferences sharedInstance].allowSelfSignedSSLCerts = YES;
    } else if (self.selfSignedCertsCheckbox.state == NSOffState) {
        [AGPreferences sharedInstance].allowSelfSignedSSLCerts = NO;
    }

    // Update cloud.
    self.cloud.baseUrl = [AGPreferences sharedInstance].baseURL;
    self.cloud.remoteDirectoryPath = [AGPreferences sharedInstance].remoteDirectoryPath;
    self.cloud.allowSelfSignedCerts = [AGPreferences sharedInstance].allowSelfSignedSSLCerts;

    [self.window close];
}

- (void)recentDropSelected:(NSMenuItem *)item {
    NSUInteger index = (NSUInteger) [self.statusMenu indexOfItem:item];
    AGDrop *drop = self.recentDrops[index];
    [self showDropNotification:drop uploaded:NO];
}


#pragma mark -
#pragma mark File Upload -

- (void)fileDropped:(id <NSDraggingInfo>)sender {
    NSArray *fileNames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    NSString *fileName = fileNames[0];

    [self.cloud uploadFile:fileName progress:^(float percentCompleted) {
        [self.statusItemView setLoading:YES];
        [self.statusItemView setProgress:percentCompleted];
    }           completion:^(NSString *remoteFilePath, NSError *uploadError) {
        [self.statusItemView setLoading:NO];
        if (!uploadError) {
            [self.cloud shareFile:remoteFilePath completion:^(NSString *url, NSError *shareError) {
                if (!shareError) {
                    AGDrop *newDrop = [AGDrop create];
                    newDrop.createdDate = [NSDate date];
                    newDrop.fileName = fileName;
                    newDrop.shareURL = url;
                    [newDrop save];

                    [self.recentDrops addObject:newDrop];
                    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:newDrop.fileName.lastPathComponent action:@selector(recentDropSelected:) keyEquivalent:@""];
                    [item setEnabled:YES];
                    [self.statusMenu insertItem:item atIndex:0];
                    if (self.recentDrops.count > 5) {
                        [self.statusMenu removeItemAtIndex:5];
                    }

                    [self showDropNotification:newDrop uploaded:YES];
                } else {
                    NSLog(@"Share Error: %@", shareError);

                    NSUserNotification *notification = [[NSUserNotification alloc] init];
                    notification.title = NSLocalizedString(@"errorsharing", nil);
                    notification.informativeText = shareError.localizedDescription;

                    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
                }
            }];
        } else {
            NSLog(@"Upload Error: %@", uploadError);

            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = NSLocalizedString(@"erroruploading", nil);
            notification.informativeText = uploadError.localizedDescription;

            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }
    }];
}

- (void)showDropNotification:(AGDrop *)drop uploaded:(BOOL)uploaded {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard setString:drop.shareURL forType:NSStringPboardType];

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    if (uploaded) {
        notification.title = [NSString stringWithFormat:NSLocalizedString(@"uploadcomplete", nil), drop.fileName.lastPathComponent];
    } else {
        notification.title = drop.fileName.lastPathComponent;
    }
    notification.informativeText = NSLocalizedString(@"urlcopied", nil);

    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}
@end

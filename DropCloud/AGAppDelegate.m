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

@interface AGAppDelegate ()

@property (nonatomic, strong) AGCloudCommunication *cloud;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) AGStatusItemView *statusItemView;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *settingsMenuItem;
@property (weak) IBOutlet NSMenuItem *aboutMenuItem;
@property (weak) IBOutlet NSMenuItem *quitMenuItem;

@property (weak) IBOutlet NSTextField *serverSettingsLabel;
@property (weak) IBOutlet NSTextField *serverUrlTextfield;
@property (weak) IBOutlet NSTextField *serverPathTextfield;

@property (weak) IBOutlet NSTextField *userSettingsLabel;
@property (weak) IBOutlet NSTextField *usernameTextfield;
@property (weak) IBOutlet NSTextField *passwordTextfield;

@property (weak) IBOutlet NSButton *saveButton;

- (IBAction)settingsAction:(id)sender;
- (IBAction)aboutAction:(id)sender;
- (IBAction)quitAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end

@implementation AGAppDelegate

NSString *const kPrefServerUrl = @"kPrefServerUrl";
NSString *const kPrefServerPath = @"kPrefServerPath";

+ (void)initialize {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
            kPrefServerUrl: @"",
            kPrefServerPath: @"",
            @"CredentialsStorage" : @""
    }];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Init.
}

- (void)awakeFromNib {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
    self.statusItemView = [[AGStatusItemView alloc] initWithStatusItem:self.statusItem];
    self.statusItemView.menu = self.statusMenu;
    self.statusItemView.image = [NSImage imageNamed:@"4"];
    self.statusItemView.highlightImage = [NSImage imageNamed:@"4"];
    [self.statusItemView addObserver:@selector(fileDropped:) withTarget:self forEvent:AGStatusItemEventFileDropped];
    self.statusItem.view = self.statusItemView;

    self.cloud = [AGCloudCommunication sharedManager];
    self.cloud.baseUrl = [[NSUserDefaults standardUserDefaults] stringForKey:kPrefServerUrl];
    self.cloud.remoteDirectoryPath = [[NSUserDefaults standardUserDefaults] stringForKey:kPrefServerPath];

    self.serverUrlTextfield.stringValue = self.cloud.baseUrl;
    self.serverPathTextfield.stringValue = self.cloud.remoteDirectoryPath;
}


#pragma mark -
#pragma mark Menu Actions -

- (IBAction)settingsAction:(id)sender {
    [self.window makeKeyAndOrderFront:self];
}

- (IBAction)aboutAction:(id)sender {
}

- (IBAction)quitAction:(id)sender {
    [NSApp terminate:self];
}

- (IBAction)saveAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:self.serverUrlTextfield.stringValue forKey:kPrefServerUrl];
    [[NSUserDefaults standardUserDefaults] setObject:self.serverPathTextfield.stringValue forKey:kPrefServerPath];
    if (self.usernameTextfield.stringValue.length > 0 && self.passwordTextfield.stringValue.length > 0) {
        [[AGCredentials credentials] setName:self.usernameTextfield.stringValue password:self.passwordTextfield.stringValue];
    }

    [self.window close];
}


#pragma mark -
#pragma mark File Upload -

- (void)fileDropped:(id <NSDraggingInfo>)sender {
    NSArray *fileNames = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    NSString *fileName = fileNames[0];

    [self.cloud uploadFile:fileName progress:^(float percentCompleted) {
    }           completion:^(NSString *remoteFilePath, NSError *uploadError) {
        if (!uploadError) {
            [self.cloud shareFile:remoteFilePath completion:^(NSString *url, NSError *shareError) {
                if (!shareError) {
                    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
                    [pasteboard clearContents];
                    [pasteboard setString:url forType:NSStringPboardType];

                    NSUserNotification *notification = [[NSUserNotification alloc] init];
                    notification.title = NSLocalizedString(@"uploadcomplete", nil);
                    notification.informativeText = NSLocalizedString(@"urlcopied", nil);

                    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
                }
            }];
        }
    }];
}
@end

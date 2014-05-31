//
// Created by Arvid Gerstmann on 18/05/14.
// Copyright (c) 2014 Arvid Gerstmann. All rights reserved.
//

#import "AGCredentials.h"
#import "NSData+Base64.h"

#pragma mark - Keychain -
OSStatus storePasswordKeychain(void *user, void *password, UInt32 passwordLength);
OSStatus changePasswordKeychain(void *password, SecKeychainItemRef itemRef);
OSStatus getPasswordKeychain(void *user, void **passwordData, UInt32 *passwordLength, SecKeychainItemRef *itemRef);

@interface AGCredentials ()
@end

@implementation AGCredentials
NSString *const kDefaultsUsername = @"kDefaultsUsername";

static AGCredentials *sharedInstance = nil;

+ (instancetype)credentials {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}


#pragma mark -
#pragma mark Mutator -

- (void)setName:(NSString *)name password:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kDefaultsUsername];

    void *passwordData = NULL;
    UInt32 passwordLength = 0;
    SecKeychainItemRef itemRef;
    OSStatus status = getPasswordKeychain((void *) name.UTF8String, &passwordData, &passwordLength, &itemRef);

    if (status == noErr) {
        SecKeychainItemFreeContent(NULL, passwordData);
        changePasswordKeychain((void *) password.UTF8String, itemRef);

    } else if (status == errSecItemNotFound) {
        storePasswordKeychain((void *) name.UTF8String, (void *) password.UTF8String, (UInt32) password.length);
    }

    if (itemRef) {
        CFRelease(itemRef);
    }
}


#pragma mark -
#pragma mark Accessor -

- (NSString *)userName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsUsername];
}

- (NSString *)password {
    if (self.userName.length <= 0) {
        return nil;
    }

    void *passwordData;
    UInt32 passwordLength = 0;
    SecKeychainItemRef itemRef;
    OSStatus status = getPasswordKeychain((void *) self.userName.UTF8String, &passwordData, &passwordLength, &itemRef);

    NSString *password = nil;
    if (status == noErr) {
        password = [NSString stringWithUTF8String:passwordData];
        SecKeychainItemFreeContent(NULL, passwordData);
    }

    if (itemRef) {
        CFRelease(itemRef);
    }
    return password;
}

- (NSString *)credentials {
    return [self createCredentialsForUser:self.userName password:self.password];
}


#pragma mark -
#pragma mark Private Methods -

- (NSString *)createCredentialsForUser:(NSString *)name password:(NSString *)password {
    if (!name || !password) {
        return nil;
    }

    NSString *authStr = [NSString stringWithFormat:@"%@:%@", name, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];

    return authValue;
}


#pragma mark -
#pragma mark Keychain -

OSStatus storePasswordKeychain(void *user, void *password, UInt32 passwordLength) {
    OSStatus status;
    status = SecKeychainAddGenericPassword(
            NULL,
            7,
            "ownDrop",
            (UInt32) strlen(user),
            user,
            passwordLength,
            password,
            NULL
    );
    return (status);
}


OSStatus getPasswordKeychain(void *user, void **passwordData, UInt32 *passwordLength, SecKeychainItemRef *itemRef) {
    OSStatus status;
    status = SecKeychainFindGenericPassword(
            NULL,
            7,
            "ownDrop",
            (UInt32) strlen(user),
            user,
            passwordLength,
            passwordData,
            itemRef
    );
    return (status);
}

OSStatus changePasswordKeychain(void *password, SecKeychainItemRef itemRef) {
    OSStatus status;
    status = SecKeychainItemModifyAttributesAndData(
            itemRef,
            NULL,
            (UInt32) strlen(password),
            password
    );
    return (status);
}

@end
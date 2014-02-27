JPToggle
========

JPToggle allows you to easily toggle features on/off in your app depending on context.yea not this 

To start, first create a manager or use the shared manager.
```
JPToggleManager *toggleManager = [JPToggleManager new];
JPToggleManager *toggleManager = [JPToggleManager sharedManager];
```
I suggest using the sharedManager!

Next, set context.  These are unique keys for your app, and the order of these keys matter!  The first context has highest priority, the last has least.
```
#ifdef DEBUG
  [[JPToggleManager sharedManager] addContext:@"DEBUG"];
#endif

  [[JPToggleManager sharedManager] addContext:@"RELEASE"];
```
This build of the app has everything from DEBUG and RELEASE (your team can decide when to remove toggles for features altogether, but toggling around RELEASE/DEBUG allows for easy rollout and rollback of features)

You can add more than one context at a time using an array
```
[[JPToggleManager sharedManager] addContexts:@[@"BETATESTER", @"PROVERSION"];
```

To set toggles on or off is as simple as this:
```
[[JPToggleManager sharedManager] setToggle:YES forFeature:@"NewFeature" inContext:@"DEBUG"];
[[JPToggleManager sharedManager] setToggle:YES forFeature:@"ReleasedFeature" inContext:@"RELEASE"];
```

Then use your toggles! Keep in mind, it uses the contexts you have set.  Continuing this example, "NewFeature" will only show if this is a DEBUG build.
```
if ([[JPToggleManager sharedManager] toggleForFeature:@"NewFeature"]) {
  // Code that launches or shows UnreleasedFeature
}
```

Want to be notified of changes?  This library supports Notification Center!
```
[[JPToggleManager sharedManager].notificationCenter addObserver:self selector:@selector(feature1Changed:) name:@"Feature1" object:nil];

- (void)feature1Changed:(NSNotification *)notification {
  BOOL toggle = [notification.object boolValue];
  // Call code that depends on this toggle
}
```

There are more improvements to come!  Look forward to A/B/(C, ...?) testing support and other improvements!

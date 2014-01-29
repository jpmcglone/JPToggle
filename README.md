JPToggle
========

JPToggle allows you to easily toggle features in your app.  
JPToggle supports multiple contexts.

To initalize contexts, first create a manager or use the shared manager.

```
JPToggleManager *toggleManager = [JPToggleManager new];
JPToggleManager *toggleManager = [JPToggleManager sharedManager];
```
I suggest using the sharedManager.

Next, set the supported contexts.  These are unique keys for your app.  The order of these keys matters.  The first context has highest priority, the last has least.
```
[JPToggleManager sharedManager].contexts = [NSMutableArray new];

#ifdef DEBUG
  [[JPToggleManager sharedManager] addContext:@"DEBUG"];
#endif
  [[JPToggleManager sharedManager] addContext:@"RELEASE"];
```

To set toggles on or off is as simple as
```
[[JPToggleManager sharedManager] setToggle:YES forFeature:@"UnReleasedFeature" inContext:@"DEBUG"];
[[JPToggleManager sharedManager] setToggle:YES forFeature:@"ReleasedFeature" inContext:@"RELEASE"];
```

Then use your toggles! Keep in mind, it uses the contexts you have set.  In this example, "UnReleasedFeature" will only show if this is a DEBUG build.
```
if ([[JPToggleManager sharedManager] toggleForFeature:@"UnReleasedFeature"]) {
  // Code that launches or shows UnreleasedFeature
}
```

Coming Soon!
- Notifications

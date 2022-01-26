# flutter_dynamic_icon

A flutter plugin for dynamically changing app icon in mobile platform. Supports **iOS and Android** (IOS with version > `10.3`).
## Known issues

* Each android version will have different behavior, with Android 8 it may take a few seconds before we notice the change
* Note: Using this feature on some android versions will cause your app to crash (it will crash the first time you change the icon, next time it won't), you can read more about this issue [here](https://github.com/tastelessjolt/flutter_dynamic_icon/pull/10#issuecomment-959260628)
## Usage
1. Add the latest version of the plugin to your `pubpsec.yaml` under dependencies section
2. Run `flutter pub get`
3. Update `android/src/main/AndroidManifest.xml` as follows:
    ```xml
    <application ...>

        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize"
            android:enabled="true">

            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"
                />

            <meta-data
                android:name="io.flutter.embedding.android.SplashScreenDrawable"
                android:resource="@drawable/launch_background"
                />

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- The activity-alias are your alternatives icons and name of your app, the default one must be enabled (and the others disabled) and the name must be ".DEFAULT". All the names of your activity-alias' name must begin with a dot. -->

        <!-- FOR NOW USE "icon_1" AS ALTERNATIVE ICON NAME -->

        <activity-alias
            android:label="Your app"
            android:icon="@mipmap/ic_launcher_1"
            android:name=".icon_1"
            android:enabled="false"
            android:targetActivity=".MainActivity">

            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme"
                />

            <meta-data
                android:name="io.flutter.embedding.android.SplashScreenDrawable"
                android:resource="@drawable/launch_background"
                />

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

        </activity-alias>
    </application>
    ```
4. You can have multiple app icon, in your app you can now use:
    * The name you pass in the method must be in the `AndroidManifest.xml` and for each icon, you must declare an activity-alias in `AndroidManifest.xml` like above
    * Declare an list of string (your available app icons)
	* Dont forget to add `MainActivity` to your list
    ```dart
    List<String> list = ["icon_1", "icon_2", "icon_n", "MainActivity"]
    DynamicIconFlutter.setIcon(icon: 'icon_1', listAvailableIcon: list);
    ```


### iOS Integration

#### Index
* `2x` - `120px x 120px`  
* `3x` - `180px x 180px`

To integrate your plugin into the iOS part of your app, follow these steps

1. First let us put a few images for app icons, they are 
    * `teamfortress@2x.png`, `teamfortress@3x.png` 
    * `photos@2x.png`, `photos@3x.png`, 
    * `chills@2x.png`, `chills@3x.png`,
2. These icons shouldn't be kept in `Assets.xcassets` folder, but outside

3. Next, we need to setup the `Info.plist`
    1. Add `Icon files (iOS 5)` to the Information Property List
    2. Add `CFBundleAlternateIcons` as a dictionary, it is used for alternative icons
    3. Set 3 dictionaries under `CFBundleAlternateIcons`, they are correspond to `teamfortress`, `photos`, and `chills`
    4. For each dictionary, two properties — `UIPrerenderedIcon` and `CFBundleIconFiles` need to be configured


Note that if you need it work for iPads, You need to add these icon declarations in `CFBundleIcons~ipad` as well. [See here](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/TP40009249-SW14) for more details.

Here is my `Info.plist` after adding Alternate Icons
#### Screenshot

![info.plist](https://raw.githubusercontent.com/tastelessjolt/flutter_dynamic_icon/master/imgs/info-plist.png)

#### Raw
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIcons</key>
	<dict>
		<key>CFBundleAlternateIcons</key>
		<dict>
			<key>chills</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>chills</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
			<key>photos</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>photos</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
			<key>teamfortress</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>teamfortress</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
		</dict>
		<key>CFBundlePrimaryIcon</key>
		<dict>
			<key>CFBundleIconFiles</key>
			<array>
				<string>chills</string>
			</array>
			<key>UIPrerenderedIcon</key>
			<false/>
		</dict>
	</dict>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>flutter_dynamic_icon_example</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
</dict>
</plist>

```

Now, you can call `DynamicIconFlutter.setAlternateIconName` with the `CFBundleAlternateIcons` key as the argument to set that icon.

### Dart/Flutter Integration

From your Dart code, you need to import the plugin and use it's static methods:

```dart 
import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';

try {
  if (await DynamicIconFlutter.supportsAlternateIcons) {
    await DynamicIconFlutter.setAlternateIconName("photos");
    print("App icon change successful");
    return;
  }
} on PlatformException catch (e) {
    if (await DynamicIconFlutter.supportsAlternateIcons) {
        await DynamicIconFlutter.setAlternateIconName(null);
        print("Change app icon back to default");
        return;
  } else {
      print("Failed to change app icon");
  }
}

```
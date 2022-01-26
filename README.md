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

        <!-- FOR NOW USE "ALT" AS ALTERNATIVE ICON NAME, FOLLOW https://github.com/GioPan04/flutter_icon_switcher/issues/1 FOR MORE INFO -->

        <activity-alias
            android:label="Blue"
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
    ```dart
    List<String> list = ["icon_1", "icon_2", "icon_n"]
    DynamicIconFlutter.setIcon(icon: 'icon_1', listAvailableIcon: list);
    ```



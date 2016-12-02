# JetSetRadio.live for iOS

iOS client for JetSetRadio.live. Integrates with the remote control, allowing
a user to control playback from the lockscreen or control centre.

* Supports all radio stations. Track lists are downloaded by the client.
* Global radio shuffle (select Classic GGs).
* Chat room support, including ID'd user handles.

Does not support the DJ request system (yet -- not sure if it is a good fit as it may result in battery drain).

## Installation

### Download the .ipa

See the releases page.

### XCode sideloading

Requires a machine running MacOS. XCode is available for free via the Mac App
Store.

1. `git clone` this repository to somewhere on your desktop.
2. Open the project in XCode.
3. Set the build destination to your iOS device.
4. Run (click the Play button or press Cmd-R) and the app will install to your device and launch.

If you want to build an .ipa without a developer license on newer versions of Xcode, you will need to modify some Xcode config files to enable building an .ipa without code signing:

1. `cd /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/`
2. `chown -R you:admin .` (Xcode will refuse to edit files if the containing directory is not owned by the user).
3. Open SDKSettings.plist in Xcode.
4. Change `DefaultProperties.ENTITLEMENTS_REQUIRED` to `NO`
5. Change `DefaultProperties.CODE_SIGNING_REQUIRED` to `NO`
6. Change `DefaultProperties.AD_HOC_CODE_SIGNING_ALLOWED` to `YES`
7. Give back root ownership again with `chown -R root:wheel .`

To build the .ipa:

1. Product -> Archive within Xcode.
2. Right-click the archive in the Organizer to find where it is.
3. `xcodebuild -exportArchive -exportFormat ipa -archivePath "name of archive.xcarchive" -exportPath ~/something.ipa`

### Cydia

No package is available yet. Looking for someone familiar with Cydia's repository system.

## Contributing

Please submit a pull request. If it's not a bug/performance fix, please open an issue first so we can discuss the changes and decide if it's worth adding.

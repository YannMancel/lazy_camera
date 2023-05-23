[![badge_flutter]][link_flutter_release]

# lazy_camera
**Goal**: A Flutter project to manage the camera in lazy way.

## Requirements
* Computer (Windows, Mac or Linux)
* Android Studio or Visual Studio Code

## Setup the project in Android studio
1. Download the project code, preferably using `git clone git@github.com:YannMancel/lazy_camera.git`.
2. In Android Studio, select *File* | *Open...*
3. Select the project

## Dependencies
* Flutter Version Management
    * [fvm][dependencies_fvm]
* Linter
    * [flutter_lints][dependencies_flutter_lints]
* State Managers
  * [flutter_hooks][dependencies_flutter_hooks]
  * [hooks_riverpod][dependencies_hooks_riverpod]
* Data Class Generator
  * [build_runner][dependencies_build_runner]
  * [freezed][dependencies_freezed]
  * [freezed_annotation][dependencies_freezed_annotation]
* Camera
  * [camera][dependencies_camera]

## Troubleshooting

### No device available during the compilation and execution steps
* If none of device is present (*Available Virtual Devices* or *Connected Devices*),
    * Either select `Create a new virtual device`
    * or connect and select your phone or tablet

## Useful
* [Download Android Studio][useful_android_studio]
* [Create a new virtual device][useful_virtual_device]
* [Enable developer options and debugging][useful_developer_options]

[badge_flutter]: https://img.shields.io/badge/flutter-v3.10.1-blue?logo=flutter
[link_flutter_release]: https://docs.flutter.dev/development/tools/sdk/releases
[dependencies_fvm]: https://fvm.app/
[dependencies_flutter_lints]: https://pub.dev/packages/flutter_lints
[dependencies_flutter_hooks]: https://pub.dev/packages/flutter_hooks
[dependencies_hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[dependencies_build_runner]: https://pub.dev/packages/build_runner
[dependencies_freezed]: https://pub.dev/packages/freezed
[dependencies_freezed_annotation]: https://pub.dev/packages/freezed_annotation
[dependencies_camera]: https://pub.dev/packages/camera
[useful_android_studio]: https://developer.android.com/studio
[useful_virtual_device]: https://developer.android.com/studio/run/managing-avds.html
[useful_developer_options]: https://developer.android.com/studio/debug/dev-options.html#enable

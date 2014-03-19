#!/bin/sh
cd ~/Documents/MudClient
xcodebuild -workspace MudClient.xcworkspace -scheme mudclient -sdk iphoneos5.0 -configuration adhoc clean build OBJROOT=build/Obj.root SYMROOT=build/Sym.root

xcrun -sdk iphoneos PackageApplication "build/Sym.root/Release-iphoneos/MudClientIpad4.app" -o "/tmp/MudClientIpad4.ipa" --sign "iPhone Distribution: Gary Barnett" --embed "build/Sym.root/Release-iphoneos/MudClientIpad4.app/embedded.mobileprovision" || failed codesign

cp /tmp/MudClientIpad4.ipa build

zip build/MudClientIpad4.app.dSYM.zip build/Sym.root/Release-iphoneos/MudClientIpad4.app.dSYM

curl http://testflightapp.com/api/builds.json -F file=@build/MudClientIpad4.ipa  -F api_token='efabf84d43fe789b43677fa68965675b_MjEyMDUxMjAxMS0xMS0wOSAyMzowMzoxMi4xMjA0NjI' -F team_token='c9e4227fad8c84e2161049d4bd6247a8_NDAwMjQyMDExLTExLTA5IDIzOjA3OjQxLjcyMTc4Mw' -F notes='This build was uploaded via the upload API' -F notify=True -F distribution_lists='Client, QA'


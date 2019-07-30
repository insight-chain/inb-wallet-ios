GRKOpenSSLFramework
=======
OpenSSL CocoaPod which vends pre-built frameworks for iOS and OSX.

### Notice

This is a wrapper which builds off of work done by others. The original comes from 
[https://github.com/krzyzanowskim/OpenSSL](https://github.com/krzyzanowskim/OpenSSL) and 
includes work done by [@jcavar](https://github.com/jcavar/OpenSSL) to build proper
frameworks. I have repackaged that work as a CocoaPod such that OpenSSL can be used by
macOS and iOS projects requiring frameworks.

Please see the Reference section below for more details.

### Architecture

This will build the framework to support the following architectures and platforms:

* iOS Simulator
	* i386
	* x86_64

* iOS SDK
	* armv7
	* armv7s
	* arm64

* macOS SDK
	* x86_64 

Please note that as of OpenSSL version `1.0.2.p` this build uses Xcode 10+ which made the i386 (32 bit) architecture unavailable, so the i386 architecture is not built for macOS. macOS 10.6.8 or above can run 64-bit, so not building the i386 (32 bit) architecture has minor impact.

### Installing

Simply add `GRKOpenSSLFramework` to your podfile:

	pod 'GRKOpenSSLFramework'

### Building

While the repository does contain the pre-built frameworks, if you want to re-build them:

#### iOS
1. Open in Xcode: OpenSSL/OpenSSL-iOS/OpenSSL-iOS.xcodeproj
2. Clean Build Folder (Option-Shift-Command-K)
3. Ensure "Generic iOS Device" is the selected build target.
4. Build
5. Use the `./_master_build.sh valid ios` command to validate the built framework.
6. Result is located: OpenSSL/OpenSSL-iOS/bin/openssl.framework

#### macOS
1. Open in Xcode: OpenSSL/OpenSSL-macOS/OpenSSL-macOS.xcodeproj
2. Clean Build Folder (Option-Shift-Command-K)
3. Build
4. Build again. This seems to be needed for the build to produce all the needed artifacts.
5. Use the `./_master_build.sh valid macos` command to validate the built framework.
6. Result is located: OpenSSL/OpenSSL-macOS/bin/openssl.framework

### Updating OpenSSL Version

The build scripts and projects are all tailored for the 1.0 series of OpenSSL, so if you're attempting to use a different series you might run into some issues.

1. Download the source tarball from [https://www.openssl.org/source/](https://www.openssl.org/source/)
2. Download the PGP sig as well, and validate the tarball's signature.
3. Place the downloaded file in this directory.
4. Update the `OPENSSL_VERSION` value in the `_master_build.sh`
5. Clean, using the `./_master_build.sh clean` command.
6. Build, using the `./_master_build.sh build` command.
7. Follow the steps outlined in "Building" (above).

### Reference
[https://github.com/krzyzanowskim/OpenSSL/issues/9](https://github.com/krzyzanowskim/OpenSSL/issues/9)  
[https://github.com/krzyzanowskim/OpenSSL/pull/27](https://github.com/krzyzanowskim/OpenSSL/pull/27)  
[https://github.com/jcavar/OpenSSL](https://github.com/jcavar/OpenSSL)  
[https://pewpewthespells.com/blog/convert_static_to_dynamic.html](https://pewpewthespells.com/blog/convert_static_to_dynamic.html)  

### Licence
This work is licensed under the OpenSSL (OpenSSL/SSLeay) License.
Please see the included [LICENSE.txt](https://github.com/levigroker/OpenSSL/blob/master/LICENSE.txt) for complete details.

### About
A professional iOS engineer by day, my name is Levi Brown. Authoring a blog
[grokin.gs](http://grokin.gs), I am reachable via:

Twitter [@levigroker](https://twitter.com/levigroker)  
Email [levigroker@gmail.com](mailto:levigroker@gmail.com)  

Your constructive comments and feedback are always welcome.

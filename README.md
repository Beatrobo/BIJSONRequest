BIJSONRequest
=================

### Dependency
* `dp_exec_block_on_main_thread`
* `BILogManager`
* `BIReachability`

### Require Framework
* None  

# CocoaPods

### How to pass `pod lib lint`
```sh
pod lib lint --allow-warnings --sources='git@github.com:Beatrobo/CocoaPods-Specs.git,https://github.com/CocoaPods/Specs'
```

### How to push private pods
```sh
pod repo push --allow-warnings beatrobo *.podspec
```

# Description

BI is "Beatrobo Inc" prefix.

NSURLConnection + NSOperationQueue の JSON 取得 & パーサー。Blocks ベース。

Beatrobo で使ってたものを Beatplug に移植して更に PlugAir に移植したものを、更に抽象化して抽出したやつ。

Pod::Spec.new do |s|
  s.name                  = "BIJSONRequest"
  s.version               = "0.3"
  s.summary               = "NSURLConnection + NSOperationQueue の JSON 取得 & パーサー。Blocks ベース。"
  s.author                = { "Yusuke SUGAMIYA" => "yusuke.dnpp@gmail.com" }
  s.homepage              = "https://github.com/Beatrobo/BIJSONRequest"
  s.source                = { :git => "git@github.com:Beatrobo/BIJSONRequest.git", :tag => "0.3" }
  s.source_files          = 'BIJSONRequest/**/*.{h,m}'
  s.ios.source_files      = 'BIJSONRequest/**/*.{h,m}'
  s.osx.source_files      = 'BIJSONRequest/**/*.{h,m}'
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc          = true

  s.dependency 'BILogManager'
  s.dependency 'BIReachability'

  s.license = {
   :type => "Beatrobo Inc Library",
   :text => ""
  }
end

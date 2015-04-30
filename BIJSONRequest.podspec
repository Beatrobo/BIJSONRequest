Pod::Spec.new do |s|
  s.name                  = 'BIJSONRequest'
  s.version               = '2.0'
  s.summary               = 'NSURLConnection + NSOperationQueue + NSJSONSerialization + Block Based Callback'
  s.author                = { 'Yusuke SUGAMIYA' => 'yusuke.dnpp@gmail.com' }
  s.homepage              = 'https://github.com/Beatrobo/BIJSONRequest'
  s.source                = { :git => 'https://github.com/Beatrobo/BIJSONRequest.git', :tag => "#{s.version}" }
  source_files            = 'BIJSONRequest/**/*.{h,m}'
  s.source_files          = source_files
  s.ios.source_files      = source_files
  s.osx.source_files      = source_files
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.requires_arc          = true

  s.dependency 'dp_exec_block_on_main_thread'
  s.dependency 'BIReachability'

  s.license = {
   :type => 'MIT',
   :text => <<-LICENSE
   Copyright (c) 2015 Beatrobo, Inc

   Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
   LICENSE
  }
end

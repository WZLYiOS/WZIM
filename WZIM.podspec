#
# Be sure to run `pod lib lint WZIM.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WZIM'
  s.version          = '1.0.2'
  s.summary          = 'IM组件框架'


  s.description      = <<-DESC
  我主IM依赖库
                       DESC

  s.homepage         = 'https://github.com/WZLYiOS/WZIM'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qiuqixiang' => '739140860@qq.com' }
  s.source           = { :git => 'https://github.com/WZLYiOS/WZIM.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.static_framework = true
  s.swift_version         = '5.0'
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig = {
      'VALID_ARCHS' => 'armv7 armv7s arm64 x86_64'
  }
  
  s.default_subspec = "Core"
  

  # 全部
  s.subspec "Core" do |ss|
    ss.source_files  = "WZIM/Classes/TIM/*", "WZIM/Classes/EM/*", "WZIM/Classes/UI/*", "WZIM/Classes/Procotol/*"
    ss.dependency 'TXIMSDK_iOS', '~> 4.9.1'
    ss.dependency 'HyphenateLite', '~> 3.7.0'
    ss.dependency 'SnapKit', '~> 5.0.1'
  end
  
  # 协议框架
  s.subspec "Procotol" do |ss|
    ss.source_files = "WZIM/Classes/Procotol/*"
  end
  
  # 基础cell和代理事件
  s.subspec "UI" do |ss|
    ss.source_files = "WZIM/Classes/UI/*", "WZIM/Classes/Procotol/*"
    ss.dependency 'SnapKit', '~> 5.0.1'
  end
  
  # 腾讯SDk
  s.subspec "TIM" do |ss|
    ss.source_files = "WZIM/Classes/TIM/*", "WZIM/Classes/Procotol/*"
    ss.dependency 'TXIMSDK_iOS', '~> 4.9.1'
  end
  
  # 环信SDK
  s.subspec "EM" do |ss|
    ss.source_files = "WZIM/Classes/EM/*", "WZIM/Classes/Procotol/*"
    ss.dependency 'HyphenateLite', '~> 3.7.0'
  end
  

end

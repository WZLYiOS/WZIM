#
# Be sure to run `pod lib lint WZIM.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WZIM'
  s.version          = '2.3.6'
  s.summary          = 'IM组件框架。'


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
    
  # 协议框架
  s.subspec "Procotol" do |ss|
    ss.source_files = "WZIM/Classes/Procotol/*"
    ss.dependency 'CleanJSON', '~> 1.0.6'
  end
  
  # 工具
  s.subspec "Tool" do |ss|
    ss.source_files = "WZIM/Classes/Tool/*"
    ss.dependency 'WZNamespaceWrappable', '~> 1.0.0'
  end
  
  # 输入框
  s.subspec "ToolBbar" do |ss|
    ss.source_files = "WZIM/Classes/ToolBbar/*"
    ss.resources    = 'WZIM/**/ToolBbar.bundle'
    ss.dependency 'WZIM/Tool'
    ss.dependency 'SnapKit', '~> 5.0.1'
    ss.dependency 'WZLame', '~> 4.0.0'
  end
  
  # 基础cell和代理事件
  s.subspec "UI" do |ss|
    ss.source_files = "WZIM/Classes/UI/**/*"
    ss.dependency 'WZIM/Procotol'
    ss.dependency 'WZIM/ToolBbar'
    ss.dependency 'Kingfisher', '~> 5.15.0'
    ss.resources = 'WZIM/**/Cell.bundle'
    ss.dependency 'UITableView+FDTemplateLayoutCell',  '~> 1.6' #动态计算cell高度
  end
  
  # 腾讯SDk
  s.subspec "TIM" do |ss|
    ss.source_files = "WZIM/Classes/TIM/*"
    ss.dependency 'WZIM/UI'
    ss.dependency 'TXIMSDK_iOS', '~> 5.0.12'
  end
  
  # 环信SDK
  s.subspec "EM" do |ss|
    ss.source_files = "WZIM/Classes/EM/*"
    ss.dependency 'WZIM/UI'
    ss.dependency 'HyphenateLite', '3.7.1'
  end
  
end

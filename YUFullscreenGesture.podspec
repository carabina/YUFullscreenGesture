Pod::Spec.new do |s|
  s.name     = 'YUFullscreenGesture'
  s.version  = '1.2'
  s.summary  = 'An pop gesture.'
  s.description  = "YUFullscreenGesture is iPad and iPhone compatible. Supports landscape and portrait orientations and can be used inside UINavigationController."
  s.homepage = 'https://github.com/yuzhidu/YUFullscreenGesture'
  s.authors  = { '马裕博' => '1632212092@qq.com' }
  s.platform              = :ios, '7.0'
  s.requires_arc = true
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.source   = { :git => 'https://github.com/yuzhidu/YUFullscreenGesture.git', :tag => s.version.to_s }
  s.source_files          = 'YUFullscreenGesture/*.{h,m}'
end

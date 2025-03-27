Pod::Spec.new do |s|
  s.name         = "YJRouter"
  s.version      = "1.1.1"
  s.summary      = "app new page router"
  s.description  = "可以通过url的形式打开新页面,简化打开新的ViewController的代码，可以在配置文件中注册url和对应的ViewController类，同时支持打电话，发邮件等系统级url"
  s.homepage     = "https://github.com/easonchen0123/YJRouter"
  s.license      = "MIT"
  s.author       = "ChenYijun"
  s.source       = { :git => "https://github.com/easonchen0123/YJRouter.git", :tag => "v" + s.version.to_s }
  s.requires_arc = true
  s.source_files = "YJRouter/*.{h,m}"
  s.ios.deployment_target = "12.0"
end

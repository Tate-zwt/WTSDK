Pod::Spec.new do |spec|
    spec.name         = 'WTSDK'
    spec.version      = '1.1.0'
    spec.summary      = '开发项目积累的一些category、tools、自定义控件（OC版本）'
    spec.homepage     = 'https://github.com/Tate-zwt/WTSDK.git'
    spec.license      = 'MIT'
    spec.authors      = { "Tate" => "weitingzhang.tate@gmail.com" }
    spec.platform     = :ios, '9.0'
    spec.source       = {:git => 'https://github.com/Tate-zwt/WTSDK.git', :tag => spec.version}
    spec.requires_arc = true
    spec.frameworks = 'UIKit', 'Foundation', 'CoreFoundation','CoreText', 'QuartzCore', 'Accelerate', 'MobileCoreServices'
    
    # 资源文件引用
    # spec.resources             = "WTSDK/source.bundle"
    # spec.resources             = "WTSDK/images/*.png"
    
    # 引用所有文件不分模块（文件夹）
    spec.source_files = 'WTSDK/**/*.{h,m}'

end
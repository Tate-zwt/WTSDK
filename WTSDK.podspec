Pod::Spec.new do |spec|
    spec.name         = 'WTSDK'
    spec.version      = '1.0.0'
    spec.summary      = '开发项目积累的一些category、tools、自定义控件（OC版本）'
    spec.homepage     = 'https://github.com/Tate-zwt/WTSDK.git'
    spec.license      = 'MIT'
    spec.authors      = { "Tate" => "weitingzhang.tate@gmail.com" }
    spec.platform     = :ios, '9.0'
    spec.source       = {:git => 'https://github.com/Tate-zwt/WTSDK.git', :tag => spec.version}
    spec.source_files = 'WTSDK/**/*.{h,m}'
    # spec.resource     = 'MJRefresh/MJRefresh.bundle'
    spec.requires_arc = true
end
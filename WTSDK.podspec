Pod::Spec.new do |spec|
    spec.name         = 'WTSDK'
    spec.version      = '1.0.5'
    spec.summary      = '开发项目积累的一些category、tools、自定义控件（OC版本）'
    spec.homepage     = 'https://github.com/Tate-zwt/WTSDK.git'
    spec.license      = 'MIT'
    spec.authors      = { "Tate" => "weitingzhang.tate@gmail.com" }
    spec.platform     = :ios, '9.0'
    spec.source       = {:git => 'https://github.com/Tate-zwt/WTSDK.git', :tag => spec.version}
    spec.requires_arc = true
    spec.frameworks = 'UIKit', 'Foundation', 'CoreFoundation','CoreText', 'QuartzCore', 'Accelerate', 'MobileCoreServices'
    
    # spec.source_files = 'WTSDK/**/*.{h,m}'
    #可以看到通过subspec可以区分出不同的模块,而且模块间也能依赖
    spec.subspec 'Category' do |c|
         c.source_files = 'WTSDK/Category/*.{h,m}', 
    end

    #可以看到通过subspec可以区分出不同的模块,而且模块间也能依赖
    spec.subspec 'Tool' do |t|
         t.source_files = 'WTSDK/Tool/*.{h,m}', 
    end

    #可以看到通过subspec可以区分出不同的模块,而且模块间也能依赖
    spec.subspec 'View' do |v|
         v.source_files = 'WTSDK/View/*.{h,m}', 
    end

end
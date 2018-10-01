Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "SwipeCell"
s.summary = "Swipe cell support like in a UITableView."
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Dennis Mueller" => "d3mueller@me.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/d3mueller/SwipeCell"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/d3mueller/SwipeCell.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'SnapKit'
s.dependency 'SwifterSwift'
s.dependency 'UIImageColors'

# 8
s.source_files = "SwipeCell/**/*.{swift}"

# 10
s.swift_version = "4.2"

end

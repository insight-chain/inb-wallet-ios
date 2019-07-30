Pod::Spec.new do |s|
  s.name          = "CoreBitcoin"
  s.version       = "0.1"
  s.summary       = "Blockchain Library for imToken"
  
  s.description   = <<-DESC
  Token Core Library powering imToken iOS app.
  DESC
  
  s.homepage      = "https://token.im"
  s.license       = {
    type: "Apache License, Version 2.0",
    file: "LICENSE"
  }
  s.author        = { "James Chen" => "james@ashchan.com" }
  s.platform      = :ios, "9.0"
  s.source        = { :git => "https://github.com/oleganza/CoreBitcoin.git", :tag => "#{s.version}" }
  s.source_files  = "CoreBitcoin/**/*.{h,m,swift}"
  s.swift_version = "4.0"
end

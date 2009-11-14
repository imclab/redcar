
$:.push(File.join(File.dirname(__FILE__), "..", "freebase2", "lib"))
require 'freebase/freebase'

require 'ruby_extensions'

module Redcar
  VERSION         = '0.3.0dev'
  VERSION_MAJOR   = 0
  VERSION_MINOR   = 0
  VERSION_RELEASE = 1
  
  ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

  $FR_CODEBASE          = File.expand_path(File.join(File.dirname(__FILE__)) + "/../")
  $FR_PROJECT           = nil
  $FREEBASE_APPLICATION = "Redcar"
  
  include FreeBASE::DataBusHelper
  
  def self.start
    FreeBASE::Core.startup("properties.yaml", "config/default.yaml")
  end
  
  def self.load
    FreeBASE::Core.load_plugins("properties.yaml","config/default.yaml")
  end
  
  def self.require
    FreeBASE::Core.require("properties.yaml","config/default.yaml")
  end
  
  def self.pump
    bus["/system/ui/messagepump"].call()
  end
end

if ARGV.include?("-v")
  puts "Redcar #{Redcar::VERSION}"
  exit
end
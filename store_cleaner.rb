require 'fileutils'
dir_path = 'store'
FileUtils.rm_rf Dir.glob("#{dir_path}/*") unless dir_path.nil?

require_relative 'services/we_work_remotely'
require_relative 'services/remote_ok'

require 'nokogiri'
require 'open-uri'
require 'csv'

Services::WeWorkRemotely.new(job_type: :devops).collect_jobs
# Services::RemoteOk.new.collect_jobs

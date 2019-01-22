require_relative 'base'

module Services
  class RemoteOk < Base

    HOST = 'https://remoteok.io'.freeze
    PROGRAMMING = '/remote-dev-jobs'
    JOB_ITEM_SELECTOR = 'tr.job'.freeze
    STORE_DIR = 'store/remote_ok'

  end
end

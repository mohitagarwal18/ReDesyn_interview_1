require 'sse'
require 'file_utils'
class LogsController < ApplicationController
  include ActionController::Live

  def log_file
    response.headers['Content-Type'] = 'text/event-stream'
  
    # hack due to new version of rack not supporting sse and sending all response at once: https://github.com/rack/rack/issues/1619#issuecomment-848460528
    response.headers['Last-Modified'] = Time.now.httpdate
  
    sse = Log::SSE.new(response.stream)
  
    log_file_path = Rails.root.join('log/development.log').to_s
  
    file = FileUtils::LogFile.new
  
    # watch development.log file for changes
    Filewatcher.new([log_file_path]).watch do |_file_path, event_type|
  
      file_lines = file.added_lines(log_file_path)
  
      sse.write(file_lines)
    end
  ensure
    sse.close
  end

end

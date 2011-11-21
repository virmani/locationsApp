require 'rubygems'
require 'rack'

class StatusCodeLogger
  def initialize(app, path)
    #@@logger = Logger.new(STDOUT)
    @app = app
    @path = path
  end
  
  def call(env)
    incomingPath = env['PATH_INFO'];
    
    status, headers, response = @app.call(env)
    
    if ((@path.to_s != '') && (incomingPath.starts_with? @path))
      log_status(status)
    end

    [status, headers, response]
  end
  
  def log_status(status)
    statistic = Statistic.where("status_code = ?", status.to_s.chr).first
    
    if(!statistic.nil?)    
      intStatusCode = status
      
      newCount = statistic.count + 1;
      newAverage = ((statistic.average * statistic.count) + intStatusCode)/newCount
      newVariance = ((statistic.variance * statistic.count) + ((intStatusCode - newAverage)**2))/newCount
      
      updated = statistic.update_attributes(:count => newCount, :average => newAverage, :variance => newVariance)
    end
  end
end

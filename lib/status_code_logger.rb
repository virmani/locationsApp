require 'rubygems'
require 'rack'

class StatusCodeLogger
  def initialize(app, *paths)
    @app = app
    
    # the variable length argument, paths, contains the list of paths for which this middleware
    # is supposed to calculate the average and variance.
    @paths = paths
  end
  
  def call(env)
    # Fetch the path requested by the user and store it in a local variable.
    incomingPath = env['PATH_INFO'];
    
    # call the application 
    status, headers, response = @app.call(env)
    
    # capture the response status code and use it to update the averages and variances if and only if
    # the path that was requested is in the list with which this middleware was initialized
    if (!@paths.empty? && 
        !(@paths.select { |acceptedPath|  incomingPath.starts_with? acceptedPath}).empty?)
      log_status(status)
    end

    [status, headers, response]
  end
  
  def log_status(status)
    
    # Grab the statistics row from the statistics table in the DB. We never insert any new rows, so, this 
    # should always return only one row (the one inserted as the seed data)
    statistic = Statistic.where("status_code = ?", status.to_s.chr).first
    
    if(!statistic.nil?)    
      newCount = statistic.count + 1;
      
      # Calculate the old sum by multiplying with the old total. Then, add the new status and calculate
      # the new average by dividing by the new total.
      newAverage = ((statistic.average * statistic.count) + status)/newCount
      
      # Use similar logic (as above) to calculate the new variance.
      newVariance = ((statistic.variance * statistic.count) + ((status - newAverage)**2))/newCount
      
      # Update this statistic row in the table with the new count (total requests), average, and variance
      updated = statistic.update_attributes(:count => newCount, :average => newAverage, :variance => newVariance)
    end
  end
end

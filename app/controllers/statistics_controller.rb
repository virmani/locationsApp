class StatisticsController < ApplicationController
  # GET /statistics
  # GET /statistics.json
  def index
    @statistics = Statistic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statistics }
    end
  end
end

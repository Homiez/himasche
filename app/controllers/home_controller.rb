class HomeController < ApplicationController

  def index
    #@users = User.all
    @dates = [] 
    0.upto(6) { |i|
      users = User.all.where(:hima_day => Date.today + i.days)	
      @dates.push({:day => Date.today + i.days, :users => users})
    }
  end
end

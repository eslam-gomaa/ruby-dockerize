class CounterJob < ApplicationJob
  queue_as :default
  
  def perform(*args)
    21 + 21
  end
  #def perform(*args)
    # Do something later
  #end
end

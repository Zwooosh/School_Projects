class View < ActiveRecord::Base
  attr_accessible :time_viewed, :user_id, :video_id
  belongs_to :user 
  belongs_to :video 
  
end

class Link < ActiveRecord::Base
  
  validates_presence_of :title
  
  belongs_to :document
  
end

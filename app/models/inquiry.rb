class Inquiry < ActiveRecord::Base
  include Protectable
  
  validates :customer_id, :presence=>true
  validates :title, :presence=>true
  validates :question, :presence=>true
end

class ThingTag < ActiveRecord::Base
  include Protectable
  validates :name, :presence=>true

  has_many :things

end

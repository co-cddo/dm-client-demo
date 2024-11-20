class Record < ApplicationRecord
  validates :name, presence: true
end

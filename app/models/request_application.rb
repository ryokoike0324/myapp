class RequestApplication < ApplicationRecord
  belongs_to :contractor
  belongs_to :request
end

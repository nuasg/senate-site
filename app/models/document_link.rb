class DocumentLink < ApplicationRecord
  belongs_to :document
  belongs_to :meeting
end

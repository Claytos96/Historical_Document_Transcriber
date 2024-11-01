require 'rest-client'

class Document < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  has_paper_trail
  has_one_attached :preview_image






end

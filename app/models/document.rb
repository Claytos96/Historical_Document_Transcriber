require 'rest-client'

class Document < ApplicationRecord
  belongs_to :user
  has_many_attached :files
  has_paper_trail
  has_one_attached :preview_image






end

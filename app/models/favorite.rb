# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :article
  belongs_to :user
end

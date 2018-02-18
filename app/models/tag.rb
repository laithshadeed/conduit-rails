# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :article
end

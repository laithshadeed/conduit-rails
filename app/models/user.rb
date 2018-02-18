# frozen_string_literal: true

class User < ApplicationRecord
  has_many :followers, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
end

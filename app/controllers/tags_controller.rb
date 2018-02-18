# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    tags = %w[
      reactjs
      elm
    ]

    render json: { "tags": tags }, status: 200
  end
end

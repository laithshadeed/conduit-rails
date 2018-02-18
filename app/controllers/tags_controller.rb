# frozen_string_literal: true

# TODO: Implement tags table

class TagsController < ApplicationController
  def index
    tags = %w[
      reactjs
      elm
    ]

    render json: { "tags": tags }, status: 200
  end
end

# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    tags = Tag.select("count(*) as c, id, name").group(:name).order("c desc").limit(10)
    render json: { "tags": tags.map(&:name) }, status: 200
  end
end

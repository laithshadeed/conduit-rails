# frozen_string_literal: true

# TODO: Use Rails way of Authentication

class ApplicationController < ActionController::API
  before_action :valid_user?

  KEY = "SECRET"

  private

  def format_article(a)
    article = {}
    article[:title] = a.title
    article[:slug] = a.slug
    article[:body] = a.body
    article[:createdAt] = a.created_at
    article[:updatedAt] = a.updated_at
    article[:tagList] = []
    article[:description] = a.description
    article[:author] = {
      username: a.user.username,
      bio: a.user.bio,
      image: a.user.image,
      following: false
    }
    article[:favorited] = a.favorites.to_a.any? { |f| f.user_id == @current_user.id }
    article[:favoritesCount] = a.favorites.length
    article
  end

  def authenticate
    return unauthorized if @current_user.nil?
  end

  def valid_user?
    auth_header = request.headers[:authorization]
    return if auth_header.nil? || auth_header.empty?
    token = auth_header.split(" ")[1]
    return if token.nil? || token.empty?
    payload = decode_token(token)
    return if payload.nil?
    @current_user = User.find_by(id: payload["id"])
  end

  def decode_token(token)
    (header_encoded, payload_encoded, mac_encoded) = token.split(".")
    payload = JSON.parse(Base64.urlsafe_decode64(payload_encoded))
    data = header_encoded + "." + payload_encoded
    my_mac_encoded = Base64.urlsafe_encode64(OpenSSL::HMAC.digest("sha256", KEY, data))
    payload = nil unless mac_encoded == my_mac_encoded
    payload
  end

  def encode_token(user)
    header = {
      alg: "HS256",
      typ: "JWT"
    }

    payload = {
      id: user.id,
      username: user.username
    }

    data = Base64.urlsafe_encode64(header.to_json) + "." + Base64.urlsafe_encode64(payload.to_json)
    mac = Base64.urlsafe_encode64(OpenSSL::HMAC.digest("sha256", KEY, data))
    "#{data}.#{mac}"
  end

  def unauthorized
    render json: error("Unauthorized"), status: :unauthorized
  end

  def not_found
    render json: error("Not Found"), status: :not_found
  end

  def forbidden
    render json: error("Forbidden"), status: :forbidden
  end

  def server_error
    render json: error("Server Error"), status: :internal_server_error
  end

  def error(e)
    { "errors": { "body": [e] } }
  end
end

class SlackApisController < ApplicationController

  skip_before_action :verify_authenticity_token

  def samples
    render json: { message: "Hi" }
    return
  end
end

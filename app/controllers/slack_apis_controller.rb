require 'openssl'

class SlackApisController < ApplicationController

  skip_before_action :verify_authenticity_token

  def samples
    err = validate
    render json: { message: err.presence || "Hi" }
    return
  end

  private

  def validate
    timestamp = request.headers['X-Slack-Request-Timestamp']
    if ( Time.current.to_i - timestamp ) > 5.minutes
      return 'too late'
    end

    sig_basestring = 'v0:' + timestamp.to_s + ':' + request.body.string

    secret = ENV['SLACK_SIGNING_SECRET']

    my_signature = 'v0=' + OpenSSL::HMAC::hexdigest(OpenSSL::Digest::SHA256.new, secret, sig_basestring)
    slack_signature = request.headers['X-Slack-Request-Signature'] || ''
    if my_signature.to_s != slack_signature
      return 'signature missmatch'
    end
  end
end

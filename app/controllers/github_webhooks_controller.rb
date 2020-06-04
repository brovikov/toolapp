class GithubWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  include GithubWebhook::Processor

  def github_pull_request(payload)
    return unless payload["action"].eql?("closed") && payload["pull_request"]["merged"]

    pull_request_number = payload["pull_request"]["number"]
    branch_name = payload["pull_request"]["head"]["ref"]
    Tools::UpdateByWebhook.new(pull_request_number: pull_request_number, branch_name: branch_name).call
  end

  private

  def webhook_secret(payload)
    ENV["GITHUB_WEBHOOK_SECRET"]
  end
end

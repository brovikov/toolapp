module Tools
  class UpdateByWebhook
    extend Dry::Initializer

    option :pull_request_number, reader: :private
    option :branch_name, reader: :private
    option :api_client, reader: :private, default: proc { Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"]) }
    option :fetch_file, reader: :private, default: proc { Github::FetchFile.new(api_client: api_client) }

    def call
      return if files.empty?
      filename = files.first.filename.split("/").last
      json_spec = fetch_file.call(filename)

      return unless json_spec.success?

      tool = Tool.where(name: filename.split(".")[0], language: filename.split(".")[1]).first

      return if tool.blank?

      tool.update(json_spec: json_spec.success)
    end

    private

    def files
      api_client.pull_request_files(ENV["REPO_PATH"], pull_request_number)
    end
  end
end

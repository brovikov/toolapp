module Tools
  module Github
    class CreatePullRequest
      extend Dry::Initializer
      include Dry::Monads[:result, :do]
      include Dry::Monads::Do.for(:call)

      option :api_client, reader: :private
      option :master_file_sha, reader: :private, default: proc { MasterFileSha.new(api_client: api_client) }
      option :create_branch, reader: :private, default: proc { CreateBranch.new(api_client: api_client) }

      def call(tool:, payload:)
        @tool, @payload = tool, payload

        yield create_branch.call(branch_name_path)
        file_sha, path = yield master_file_sha.call(tool)
        yield update_file(file_sha, path)
        yield create_pull_request
        Success()
      end

      private

      def create_pull_request
        api_client.create_pull_request(repo_path, "master", branch_name, message)
        Success()
      rescue
        Failure(["API Error. Unable Create Pull Request"])
        # Notify Rollbar
      end

      def update_file(file_sha, path)
        api_client.update_content(repo_path, path, message, file_sha, payload.to_json, branch: branch_name_path)
        Success()
      rescue
        Failure(["API Error. Unable update file"])
        # Notify Rollbar
      end

      def message
        "Update tool: #{tool.name}, language: #{tool.language}"
      end

      def branch_name_path
        "refs/heads/#{branch_name}"
      end

      def branch_name
        @branch_name ||= SecureRandom.uuid
      end

      def repo_path
        ENV["REPO_PATH"]
      end

      attr_reader :tool, :payload
    end
  end
end

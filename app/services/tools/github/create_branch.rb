module Tools
  module Github
    class CreateBranch
      extend Dry::Initializer
      include Dry::Monads[:result]

      option :api_client, reader: :private

      MASTER = "heads/master"

      def call(branch_name_path)
        Success(api_client.create_ref(repo_path, branch_name_path, master_branch_sha))
      end

      def master_branch_sha
        @master_sha ||= api_client.ref(repo_path, MASTER).object[:sha]
      end

      def repo_path
        ENV["REPO_PATH"]
      end

      attr_reader :tool
    end
  end
end

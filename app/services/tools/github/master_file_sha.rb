module Tools
  module Github
    class MasterFileSha
      extend Dry::Initializer
      include Dry::Monads[:result]

      option :api_client, reader: :private

      def call(tool)
        @tool = tool

        res = api_client.search_code("filename:#{file_name} repo:#{repo_path}")
        return Failure(["Unable find file for update"]) unless res.total_count == 1

        Success([res.items.first[:sha], res.items.first[:path]])
      end

      private

      def file_name
        "#{tool.name}.#{tool.language}*.json"
      end

      def repo_path
        ENV["REPO_PATH"]
      end

      attr_reader :tool
    end
  end
end

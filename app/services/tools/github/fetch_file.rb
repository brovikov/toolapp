module Tools
  module Github
    class FetchFile
      extend Dry::Initializer
      include Dry::Monads[:result]

      option :api_client, reader: :private

      def call(filename)
        @filename = filename

        file = JSON.parse(file_decoded)
        Success(file)
      rescue JSON::ParserError
        Failure("Unable to parse file content")
      end

      private

      def file_decoded
        Base64.decode64(get_file)
      end

      def get_file
        api_client.contents(ENV["REPO_PATH"], path: filename)[:content]
      end

      attr_reader :filename
    end
  end
end

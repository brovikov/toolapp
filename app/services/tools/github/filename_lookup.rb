module Tools
  module Github
    class FilenameLookup
      extend Dry::Initializer
      include Dry::Monads[:result]

      option :api_client, reader: :private

      def call(regex)
        file = files.grep(regex).first
        file.present? ? Success(file) : Failure("File not found")
      end

      private

      def contents
        api_client.contents(ENV["REPO_PATH"])
      end

      def files
        @files ||= contents.select { |i| i.type == "file" }.map { |i| i.name }
      end
    end
  end
end

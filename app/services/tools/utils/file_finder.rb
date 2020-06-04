module Tools
  module Utils
    class FileFinder
      extend Dry::Initializer

      option :api_client, reader: :private

      def call(filename)
        api_client.search_code("#{filename} repo:")
      end
    end
  end
end

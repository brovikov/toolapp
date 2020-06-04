class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :methods, type: :array, default: [], banner: "method method"
  class_option :module, type: :string

  def create_service_file
    @class_name_with_module = class_name
    @module_names = class_name.split("::")
    @class_name_without_modules = @module_names.pop

    service_dir_path = "app/services/"
    generator_dir_path = service_dir_path
    Dir.mkdir(service_dir_path) unless File.exist?(service_dir_path)

    @module_names.each do |name|
      generator_dir_path << (name.underscore + "/")
      Dir.mkdir(generator_dir_path) unless File.exist?(generator_dir_path)
    end

    Dir.mkdir(generator_dir_path) unless File.exist?(generator_dir_path)

    generator_path = generator_dir_path + "#{file_name}.rb"
    template "service.erb", generator_path
  end

  hook_for :test_framework
end

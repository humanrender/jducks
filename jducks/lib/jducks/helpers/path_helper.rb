module JDucks
  module Helpers
    module PathHelper

      def relative_path_for path
        resource_pathname = Pathname.new("./#{JDucks::Core::Conf.instance.docs_dir}/#{path}")
        file_pathname = Pathname.new(file_path)
        resource_pathname.relative_path_from(file_pathname.parent)
      end

    end
  end
end
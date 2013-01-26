module JDucks
  module Helpers
    module CapturingHelper

      def content_for label, &block
        self.send "_content_for=", {} unless _content_for
        unless block_given?
          _content_for[label.to_s]
        else
          old_buffer, @output_buffer = @output_buffer, ''
          res = yield
          @output_buffer = old_buffer
          _content_for[label.to_s] = _content_for[label.to_s] ? _content_for[label.to_s]+res : res
        end
      end
    end
  end
end
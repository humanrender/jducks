module JDucks
  module Helpers
    module CapturingHelper

      def content_for label, &block
        debugger
        self.send "_content_for=", {} unless _content_for
        unless block_given?
          _content_for[label.to_s]
        else
          _content_for[label.to_s] = _content_for[label.to_s] ? _content_for[label.to_s]+block.call : block.call
        end
      end
    end
  end
end
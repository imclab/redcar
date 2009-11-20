
module Redcar
  class EditViewSWT
    class Document
      include Redcar::Observable
      attr_reader :swt_document
      
      def initialize(model, swt_document)
        @model = model
        @swt_document = swt_document
      end
      
      def to_s
        @swt_document.get
      end
      
      def length
        @swt_document.length
      end
      
      def line_count
        @swt_document.get_number_of_lines
      end
      
      def text=(text)
        @swt_document.set(text)
        notify_listeners(:set_text)
      end
    end
  end
end
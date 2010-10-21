module DjhUtil::Extensions::String
  extend ActiveSupport::Concern

  included do
    alias_method_chain(
      :pluralize, :count
    ) unless instance_methods.include? :pluralize_without_count
  end

  module InstanceMethods
    def unindent
        indent = (index /^([ \t]+)/; $1) || ''
        regex = /^#{Regexp::escape( indent )}/
        strip.gsub regex, ''
    end

    def oneline
        strip.gsub( /\n\s+/, ' ' )
    end

    # Annoyingly, the useful version of pluralize in texthelpers isn't in the
    # string core extensions.
    def pluralize_with_count( count=2 )
      count > 1 ? pluralize_without_count : singularize
    end

    def wrap( width, heading_indentation=nil, heading=nil )
      # TODO 2: if indentation is nil, compute indentation
      heading_indentation   ||= 0
      heading               ||= ""
      
      indentation = heading.size + heading_indentation
      indent      = ' ' * indentation
      sbuf        = "#{indent}"
      line_w      = indentation

      original_indentation = nil

      new_line = lambda do
        sbuf << "\n#{indent}"
        line_w  = indentation
      end

      start_of_line = lambda { line_w == indentation }

      split( "\n" ).each do |line|
        if original_indentation.nil?
          line =~ /^(\s*)/
          original_indentation = $1.size
        end

        # If the line has more than the original indentation, it is ‘indented’
        # and to be left unformatted
        if line =~ /^\s{#{original_indentation}}\s/
          sbuf << "\n#{indent}" unless start_of_line.call
          sbuf << line.slice( original_indentation, line.size )
          new_line.call
          next
        # Leave line breaks intact to allow paragraph separataion.
        elsif line.strip.empty?
          sbuf << "\n"
          new_line.call
          next
        end

        leading_space = 
          start_of_line.call  ? '' : ' '
        line.gsub!( %r/^\s{,#{original_indentation}}/, leading_space )
        line.split( /(\s+)/ ).each do |word|
          next if start_of_line.call && word.strip.empty?

          if line_w + word.size <= width
            sbuf << word
            line_w += word.size
          elsif start_of_line.call
            sbuf << word[0...(size - indentation)]
            new_line.call
            word.slice! (size - indentation), word.size
          else
            new_line.call
            redo
          end
        end
      end
     
      sbuf[ 0...heading.size ] = heading

      sbuf.rstrip
    end

    def wrap!( width, heading_indentation=nil, heading=nil )
      self.replace wrap( width, heading_indentation, heading )
    end
  end

end

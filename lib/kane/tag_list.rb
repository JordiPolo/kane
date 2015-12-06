module Kane

  #This class manages a tag, semantic or not.
  class Tag
    include Comparable # Methods < , <= , ==, >, >=
    attr_reader :sem_ver, :original

    # @param tag_str : string with hopefully a semantic tag
    def initialize(tag_str)
      @sem_ver = ::SemVer.parse(clean_tag(tag_str))
      @original = tag_str
    end

    # @return true if this Tag is using semantic versioning
    def semantic?
      !@sem_ver.nil?
    end

    # @returns the string representation of this tag
    def to_s
      @original
    end


    private

    def <=>(other)
      # If both are SemVer, let the object deal with that
      if semantic? && other.semantic?
        self.sem_ver <=> other.sem_ver
      else
        if semantic?  # If only we are semantic, we are bigger
          1
        elsif other.semantic? # If only the other is semantic, that is bigger
          -1
        else
          original <=> other.original # We are comparing strings! Well, good luck with that.
        end
      end
    end

    def clean_tag(tag_string)
      parsed_tag_str = tag_string
      parsed_tag_str = parsed_tag_str[1..-1] if parsed_tag_str.start_with?('v')
      parsed_tag_str
    end
  end


  # This class manages a lists of Tags
  class TagList
    # @param tag_string_or_array : a string with potentially the format 'v0.1' or array of such strings
    def initialize(tag_string_or_array)
      @tags = [*tag_string_or_array].map{|tag| Tag.new(tag)}
    end

    # @return true if all the tags are semantic
    def semantic?
      @tags.all?{|tag| tag.semantic?}
    end

    # Return all the tags in the array greater than a given tag
    def all_greater_than(tag_string)
      other_tag = Tag.new(tag_string)
      greater = @tags.select do |a_tag|
        if a_tag.semantic?
          a_tag > other_tag
        else
          true # include this tag b/c we cannot programmatically compare it with parsed_current_tag; let the user decide
        end
      end
      greater.sort.map(&:to_s)
    end
  end

end
require 'digest/sha1'

module HasDigest
  def self.included(base)
    base.extend(ClassMethods)
  end

  def digest(*values)
    if values.empty?
      Digest::SHA1.hexdigest(random_string)
    elsif values.all?
      Digest::SHA1.hexdigest(values.join('--'))
    else
      nil
    end
  end

  def random_string
    Time.now.to_default_s.split(//).sort_by { Kernel.rand }.join
  end

  module ClassMethods
    def has_digest(attribute, options = {})
      digest_attribute = "digest_#{attribute}".to_sym

      if options[:include]
        before_save digest_attribute

        define_method(digest_attribute) do
          values = case options[:include]
            when String, Symbol
              [self.send(options[:include])]
            else
              options[:include].map { |attribute_name| self.send(attribute_name) }
            end

          self[attribute] = digest(*values)
        end

      else
        before_create digest_attribute

        define_method(digest_attribute) do
          self[attribute] = digest
        end
      end
    end
  end
end
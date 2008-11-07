require 'digest/sha1'

module HasDigest
  def self.included(base)
    base.extend(ClassMethods)
  end

  def digest(*values)
    if values.empty?
      Digest::SHA1.hexdigest(Time.now.to_default_s.split(//).sort_by { Kernel.rand }.join)
    elsif values.all?
      Digest::SHA1.hexdigest(values.join('--'))
    else
      nil
    end
  end

  module ClassMethods
    def has_digest(attribute, options = {})
      digest_attribute = "digest_#{attribute}".to_sym

      if column_names.include?('salt') && !instance_methods.include?('digest_salt')
        before_save :digest_salt

        define_method('digest_salt') do
          self.salt = digest if self.new_record?
        end
      end

      before_save digest_attribute

      define_method(digest_attribute) do
        if options[:depends]
          dependencies = []
          dependencies << :salt if self.class.column_names.include?('salt')
          dependencies << options[:depends]
          dependencies.flatten!

          values = dependencies.map { |dependency| self.send(dependency) }

          synthetic_dependencies = dependencies - attribute_names.map(&:to_sym)
          synthetic_dependencies.map! { |name| self.send(name) }

          self[attribute] = digest(*values) if synthetic_dependencies.all?
        else
          self[attribute] = digest if self.new_record?
        end
      end
    end
  end
end
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
    # +has_digest+ gives the class it is called on a before_save callback that
    # writes a 40-character hexadecimal string into the given attribute. The
    # generated string may depend on other (possibly synthetic) attributes of
    # the model, being automatically regenerated when they change. One key is
    # supported in the +options+ hash:
    # * +depends+: either a single attribute name or a list of attribute
    #   names. If any of these values change, +attribute+ will be re-written.
    #   Setting any (non-synthetic) one of these attributes to +nil+ will
    #   effectively also set +attribute+ to +nil+.
    #
    # === Magic Salting
    # If the model in question has a (non-synthetic) +salt+ attribute, its
    # +salt+ be automatically populated on create and automatically mixed into
    # any digests that depend on other attributes, saving you a little bit of work
    # when dealing with passwords.
    #
    # ===Examples
    #   # token will be generated on create
    #   class Order < ActiveRecord::Base
    #     has_digest :token
    #   end
    #
    #   # encrypted_password will be generated on save whenever @password is not nil
    #   class User < ActiveRecord::Base
    #     has_digest :encrypted_password, :depends => :password
    #     attr_accessor :password
    #   end
    #
    #   # remember_me_token will be generated on save whenever login or remember_me_until have changed.
    #   # User.update_attributes(:remember_me_until => nil) will set remember_me_token to nil.
    #   class User < ActiveRecord::Base
    #     has_digest :remember_me_token, :depends => [:login, :remember_me_until]
    #   end
    #
    #   # api_token will be blank until user.update_attributes(:generate_api_token => true).
    #   class User < ActiveRecord::Base
    #     has_digest :api_token, :depends => :generate_api_token
    #     attr_accessor :generate_api_token
    #   end
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
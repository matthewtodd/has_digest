require 'digest/sha1'

module HasDigest
  def self.included(base)
    base.extend(ClassMethods)
  end

  def digest
    Digest::SHA1.hexdigest(Time.now.to_default_s.split(//).sort_by { Kernel.rand }.join)
  end

  module ClassMethods
    def has_digest(attribute)
      module_eval(<<-EOS, "(__HAS_DIGEST__)", 1)
        def digest_#{attribute}
          self.#{attribute} = digest
        end
      EOS

      before_create "digest_#{attribute}".to_sym
    end
  end
end
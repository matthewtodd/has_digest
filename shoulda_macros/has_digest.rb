module HasDigest
  module Shoulda
    # Asserts that the necessary database columns exist to support
    # <tt>has_digest :name</tt> and that the necessary callback methods have
    # been created.
    def should_have_digest(name, options = {})
      options.assert_valid_keys(:depends)

      context "#{model_class.name} with digest :#{name}" do
        should_have_db_column name, :type => :string, :limit => 40
        should_have_instance_methods "digest_#{name}"

        if options[:depends]
          dependencies = options[:depends]
          dependencies = [dependencies] unless dependencies.respond_to?(:each)

          dependencies.each do |dependency|
            should_have_instance_methods "#{dependency}", "#{dependency}="
          end
        end
      end
    end
  end
end

Test::Unit::TestCase.extend(HasDigest::Shoulda)

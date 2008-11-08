module HasDigest
  module Shoulda
    # Asserts that the necessary database columns exist to support
    # <tt>has_digest :name</tt> and that the necessary callback methods have
    # been created.
    def should_have_digest(name, options = {})
      options.assert_valid_keys(:depends)

      context "#{model_class.name} with has_digest :#{name}" do
        should_have_db_column name, :type => :string, :limit => 40

        should "generate digest for :#{name}" do
          assert_not_nil model_class.has_digest_attributes[name]
        end

        if options[:depends]
          dependencies = options[:depends]
          dependencies = [dependencies] unless dependencies.respond_to?(:each)
          dependencies.unshift(:salt) if model_class.column_names.include?('salt')

          should "generate digest for :#{name} from #{dependencies.to_sentence}" do
            attributes = model_class.has_digest_attributes[name] || {}
            assert_equal dependencies, attributes[:dependencies]
          end
        end
      end
    end
  end
end

Test::Unit::TestCase.extend(HasDigest::Shoulda)

module HasDigest
  module Shoulda
    # Asserts that the necessary database columns exist to support
    # <tt>has_digest :name</tt> and that the necessary callback methods have
    # been created.
    def should_have_digest(name)
      context "Class #{model_class.name} with digest #{name}" do
        should_have_db_column name, :type => :string # TODO :limit => 40
        should_have_instance_methods "digest_#{name}"
      end
    end
  end
end

Test::Unit::TestCase.extend(HasDigest::Shoulda)

require 'test_helper'

class HasDigestTest < Test::Unit::TestCase
  context 'Model with a simple token' do
    setup do
      @klass = model_with_attributes(:token) do
        has_digest :token
      end
    end

    context 'instance' do
      setup do
        @instance = @klass.new
      end

      context 'save' do
        setup do
          @instance.save
        end

        should_change '@instance.token'
      end
    end
  end
end

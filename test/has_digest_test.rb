require 'test_helper'

class HasDigestTest < Test::Unit::TestCase
  context 'Model with a simple token' do
    setup do
      @klass = model_with_attributes(:token) do
        has_digest :token
      end
    end

    context 'instance' do
      setup { @instance = @klass.new }

      context 'save' do
        setup { @instance.save }
        should_change '@instance.token', :to => /^\w{40}$/

        context 'save again' do
          setup { @instance.save }
          should_not_change '@instance.token'
        end
      end
    end

    context 'even when the default date format is short' do
      setup do
        @default = Time::DATE_FORMATS[:default]
        Time::DATE_FORMATS[:default] = '%d %b'
      end

      context 'lots of saved instances' do
        setup { @instances = (1..1000).collect { @klass.create }}

        should 'have unique tokens' do
          assert_unique @instances.map(&:token)
        end
      end

      teardown do
        Time::DATE_FORMATS[:default] = @default
      end
    end
  end
end

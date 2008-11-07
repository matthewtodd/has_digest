require 'test_helper'

class HasDigestTest < Test::Unit::TestCase
  context 'Model with a standalone digest' do
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

  context 'Model with a single-attribute-based digest' do
    setup do
      @klass = model_with_attributes(:encrypted_password) do
        attr_accessor :password
        has_digest :encrypted_password, :include => :password
      end
    end

    context 'saved instance' do
      setup { @instance = @klass.create(:password => 'PASSWORD') }

      should 'have digested attribute' do
        assert_not_nil @instance.encrypted_password
      end

      context 'saved again' do
        setup { @instance.save }
        should_not_change '@instance.encrypted_password'
      end

      context 'updated' do
        setup { @instance.update_attributes(:password => 'NEW PASSWORD') }
        should_change '@instance.encrypted_password'
      end
    end
  end

  context 'Model with a multiple-attribute-based digest' do
    setup do
      @klass = model_with_attributes(:remember_me_token) do
        attr_accessor :login, :remember_me_token_expires_at
        has_digest :remember_me_token, :include => [:login, :remember_me_token_expires_at]
      end
    end

    context 'saved instance' do
      setup { @instance = @klass.create(:login => 'bob', :remember_me_token_expires_at => 2.weeks.from_now) }

      should 'have digested attribute' do
        assert_not_nil @instance.remember_me_token
      end

      context 'update one attribute' do
        setup { @instance.update_attributes(:remember_me_token_expires_at => 3.weeks.from_now) }
        should_change '@instance.remember_me_token'
      end
    end
  end
end

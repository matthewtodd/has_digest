require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'active_record'
require File.join(File.dirname(__FILE__), '..', 'lib', 'has_digest.rb')

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

def model_with_attributes(*attributes, &block)
  ActiveRecord::Base.connection.create_table :models, :force => true do |table|
    attributes.each do |attribute|
      table.string attribute
    end
  end

  ActiveRecord::Base.extend(HasDigest)
  Object.send(:remove_const, "Model") rescue nil
  Object.const_set("Model", Class.new(ActiveRecord::Base))
  Model.class_eval &block
  Model
end
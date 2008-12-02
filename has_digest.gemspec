# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_digest}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Todd"]
  s.date = %q{2008-12-02}
  s.email = %q{matthew.todd@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "shoulda_macros/has_digest.rb"]
  s.files = ["README.rdoc", "MIT-LICENSE", "init.rb", "lib/has_digest.rb", "shoulda_macros/has_digest.rb", "test/has_digest_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc", "--title", "has_digest-0.1.2", "--inline-source", "--line-numbers"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{ActiveRecord macro that helps encrypt passwords and generate api tokens before_save.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

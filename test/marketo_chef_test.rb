# frozen_string_literal: true

require 'test_helper'

class MarketoChefTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::MarketoChef::VERSION
  end

  def test_that_it_does_something_useful
    assert ::MarketoChef.respond_to? :add_lead
  end
end

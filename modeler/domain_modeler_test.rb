require 'test/unit'
require 'csv'
require 'redgreen'
require './domain_modeler'


class DomainModelerTest < Test::Unit::TestCase
  
  attr_reader :modeler
  
  def modeler
    @modeler ||= DomainModeler.new('../models.csv')
  end
  
  def test_identify_models
    assert_equal(["User", "Lesson", "Question", "Vote"].sort, modeler.model_names)
  end
  
  def test_belongs_to
    assert_equal([:question, :user].sort, modeler['Vote'].belongs_to )
  end

  def test_has_many
    assert_equal([:lessons, :votes].sort, modeler[:user].has_many)
  end
  
  
end
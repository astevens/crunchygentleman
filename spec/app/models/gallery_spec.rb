require 'spec_helper'

describe "Gallery Model" do
  let(:gallery) { Gallery.new }
  it 'can be created' do
    gallery.should_not be_nil
  end
end

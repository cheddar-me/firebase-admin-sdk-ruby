# frozen_string_literal: true

require_relative "../../spec_helper"

describe Firebase::Admin do
  it "has a version number" do
    expect(Firebase::Admin::VERSION).not_to be nil
  end
end

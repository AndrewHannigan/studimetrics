require 'spec_helper'

describe ApplicationController do

  describe '#current_user' do
    it 'returns a NullUser if no one is signed in' do
      expect(controller.current_user).to be_kind_of(NullUser)
    end

    it 'returns the standard user otherwise' do
      user = User.new
      sign_in_as user

      expect(controller.current_user).to eq(user)
    end

  end

end

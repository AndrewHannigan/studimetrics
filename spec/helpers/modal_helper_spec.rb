require 'spec_helper'

describe ModalHelper do
  describe '#modal' do
    it 'renders a modal with options' do
      helper.expects(:render)

      helper.modal title: 'wee', body: 'buddy', id: 'yep', class: 'two'

      expect(helper).to have_received(:render).with('application/modal', title: 'wee', body: 'buddy', id: 'yep', klass: 'two')
    end

    it 'renders a block as the body' do
      helper.expects(:render)

      helper.modal do
        'whoohoo!'
      end

      expect(helper).to have_received(:render).with('application/modal', body: 'whoohoo!')
    end
  end
end

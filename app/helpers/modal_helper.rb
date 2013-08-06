module ModalHelper
  def modal(options={}, &block)
    if block_given?
      options[:body] = capture(&block)
    end

    if klass = options.delete(:class)
      options[:klass] = klass
    end

    content_for :modal do
      render 'application/modal', options
    end
  end
end

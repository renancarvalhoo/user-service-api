module TestModelValidations

  def self.included(klass)
    klass.class_eval do
      def self.test_validates_presence_of(*args)
        args.each do |field_name|
          define_method("test_should_require_#{field_name.to_s}") do
            model = self.model_klass.new
            assert_validation(model, field_name, "can't be blank")
          end
        end
      end

      def self.test_validates_uniqueness_of(existing_model, *args)
        args.each do |field_name|
          define_method("test_should_require_#{field_name.to_s}_to_be_unique") do
            params_hash = {}
            params_hash[field_name] = existing_model.send(field_name)
            model = self.model_klass.new(params_hash)
            assert_validation(model, field_name, "has already been taken")
          end
        end
      end

    private
      def assert_validation(model, field_name, error_message)
        refute model.valid?
        refute model.save
        assert_operator model.errors.count, :>, 0
        assert model.errors.messages.include?(field_name)
        assert model.errors.messages[field_name].include?(error_message)
      end

    end
  end

  def model_klass
    self.class.name.underscore.split("_test").first.camelize.constantize
  end
end
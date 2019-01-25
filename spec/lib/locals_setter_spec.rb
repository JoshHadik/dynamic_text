RSpec.describe DynamicText::LocalsSetter do

  class Resource
    attr_reader :attribute, :id

    def initialize(attribute)
      @id = id
      @attribute = attribute
    end
  end

  let(:id) do
    102
  end

  let(:attribute_value) do
    'value_of_attribute'
  end

  let(:resource) do
    Resource.new(attribute_value)
  end

  describe '#get_dynamic_locals' do
    it 'returns a hash with :resource set to the first parameter' do
      output = subject.get_dynamic_locals(resource, :attribute)
      expect(output[:resource]).to eq(resource)
    end

    it 'returns a hash with :attribute set to the second parameter' do
      output = subject.get_dynamic_locals(resource, :attribute)
      expect(output[:attribute]).to eq(:attribute)
    end

    it 'returns a hash with :value set to the result of :attribute being called on :resource' do
      output = subject.get_dynamic_locals(resource, :attribute)
      expect(output[:value]).to eq(resource.attribute).and eq(attribute_value)
    end

    it 'returns a hash with :placeholder defaulted to "Enter #{attribute}..."' do
      output = subject.get_dynamic_locals(resource, :attribute)
      expect(output[:placeholder]).to eq("Enter attribute...")
    end

    it 'returns a hash with :placeholder set to value of the :placeholder keyword argument' do
      placeholder = "I am a placeholder"
      output = subject.get_dynamic_locals(resource, :attribute, placeholder: placeholder)
      expect(output[:placeholder]).to eq(placeholder)
    end

    it 'returns a hash with :resource_type set to the resource class name without capitals' do
      output = subject.get_dynamic_locals(resource, :attribute)
      expect(output[:resource_type]).to eq('resource')
    end

    it 'returns a hash with :dynamic_tag defaulted to format resource_type:resource_id:attribute"' do
      output = subject.get_dynamic_locals(resource, :attribute)
      expect(output[:dynamic_tag]).to eq("resource:#{resource.id}:attribute")
    end
  end

  describe '#get_editable_locals' do
    it 'returns a hash with :resource set to the first parameter' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:resource]).to eq(resource)
    end

    it 'returns a hash with :attribute set to the second parameter' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:attribute]).to eq(:attribute)
    end

    it 'returns a hash with :value set to the result of :attribute being called on :resource' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:value]).to eq(resource.attribute).and eq(attribute_value)
    end

    it 'returns a hash with :placeholder defaulted to "Enter #{attribute}..."' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:placeholder]).to eq("Enter attribute...")
    end

    it 'returns a hash with :placeholder set to value of the :placeholder keyword argument' do
      placeholder = "I am a placeholder"
      output = subject.get_editable_locals(resource, :attribute, placeholder: placeholder)
      expect(output[:placeholder]).to eq(placeholder)
    end

    it 'returns a hash with :resource_type set to the resource class name without capitals' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:resource_type]).to eq('resource')
    end

    it 'returns a hash with :dynamic_tag defaulted to format resource_type:resource_id:attribute"' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:dynamic_tag]).to eq("resource:#{resource.id}:attribute")
    end

    it 'returns a hash with :dynamic_tag defaulted to format resource_type:resource_id:attribute"' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:dynamic_tag]).to eq("resource:#{resource.id}:attribute")
    end

    it 'returns a hash with :url set to convential rails path for resource' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:url]).to eq("/resources/#{resource.id}")
    end

    it 'returns a hash with :js_key defaulted to format resource_type:attribute' do
      output = subject.get_editable_locals(resource, :attribute)
      expect(output[:js_key]).to eq("resource:attribute")
    end
  end
end

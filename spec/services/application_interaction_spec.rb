require 'rails_helper'

describe ApplicationInteraction do
  context 'simple form' do
    let(:test_form_class) do
      Class.new(ApplicationInteraction) do
        interface :model

        model_fields :model, default: nil do
          integer :number
        end

        def execute
          number
        end
      end
    end

    describe '#model_fields' do
      context 'new object' do
        it 'prepopulates fields' do
          model = double('Model', number: 1)
          result = test_form_class.new(model: model)

          expect(result.number).to eq 1
        end
      end

      it 'prepopulates model fields' do
        model = double('Model', number: 1)
        result = test_form_class.run!(model: model)

        expect(result).to eq 1
      end

      it 'sets to nil' do
        model = double('Model', number: 1)
        result = test_form_class.run!(model: model, number: nil)

        expect(result).to be_nil
      end

      it 'sets empty string to nil' do
        model = double('Model', number: 1)
        result = test_form_class.run!(model: model, number: '')

        expect(result).to be_nil
      end
    end

    describe '#given?' do
      it 'is true for given attribute' do
        model = double('Model', number: 1)
        form = test_form_class.new(model: model)

        expect(form.given?(:model)).to be true
      end

      it 'is false for prepopulated fields' do
        model = double('Model', number: 1)
        form = test_form_class.new(model: model)

        expect(form.given?(:number)).to be false
      end
    end

    describe '#any_changed?' do
      it 'is false if value has not changed' do
        model = double('Model', number: 1)
        form = test_form_class.new(model: model, number: 1)

        expect(form.any_changed?(:number)).to be false
      end

      it 'is true when value changed' do
        model = double('Model', number: 1)
        form = test_form_class.new(model: model, number: 2)

        expect(form.any_changed?(:number)).to be true
      end

      it 'is true when value is cleared' do
        model = double('Model', number: 1)
        form = test_form_class.new(model: model, number: nil)

        expect(form.any_changed?(:number)).to be true
      end
    end
  end

  context 'nested models' do
    let(:test_nested_form) do
      Class.new(ApplicationInteraction) do
        interface :model_a
        interface :model_b, default: -> { model_a.b }

        model_fields :model_b, default: nil do
          integer :number
        end

        def execute
          number
        end
      end
    end

    context 'new object' do
      it 'prepopulates values' do
        b = double('B', number: 1)
        a = double('A', b: b)
        result = test_nested_form.new(model_a: a)

        expect(result.number).to eq 1
      end
    end

    it 'prepopulates values' do
      b = double('B', number: 1)
      a = double('A', b: b)
      result = test_nested_form.run!(model_a: a)

      expect(result).to eq 1
    end
  end

  describe 'run_in_transaction!' do
    let(:klass) do
      Class.new(ApplicationInteraction) do
        Composable = Class.new(ApplicationInteraction) do
          interface :x

          def execute
            x.assign_attributes(name: 'bar')
            x.save
            errors.add :base, 'nope'
          end
        end

        interface :x
        run_in_transaction!
        def execute
          compose ::Composable, x: x
        end
      end
    end

    context 'composable interactions' do
      it 'rollbacks when composable failed' do
        obj = double('Model', name: 'foo')
        expect(obj).to receive(:assign_attributes)
        expect(obj).to receive(:save)

        outcome = klass.run(x: obj)

        expect(outcome).to be_invalid
        expect(obj.name).to eq('foo')
      end
    end
  end

  describe 'run callbacks' do
    let(:test_class) do
      Class.new(ApplicationInteraction) do
        interface :x
        boolean :with_presence, default: false
        boolean :with_execute_error, default: false

        validates :x, presence: true, if: :with_presence

        after_run do
          x.after_run_block
        end

        after_run :after_run_method

        after_successful_run do
          x.after_successful_run
        end

        after_failed_run do
          x.after_failed_run
        end

        def execute
          x.execute
          errors.add :base, 'error' if with_execute_error
        end

        def self.name
          'TestClass'
        end

        def after_run_method
          x.after_run_method
        end
      end
    end

    describe '#after_run' do
      it 'is called after execute method' do
        x = spy
        test_class.run!(x: x)

        expect(x).to have_received(:execute).ordered
        expect(x).to have_received(:after_run_block).ordered
      end

      it 'runs on failure' do
        x = spy
        outcome = test_class.run(x: x, with_presence: true)

        expect(outcome).to be_invalid
        expect(x).to_not have_received(:execute)
        expect(x).to have_received(:after_run_block).ordered
      end

      it 'works when used with symbol' do
        x = spy
        test_class.run!(x: x)

        expect(x).to have_received(:execute).ordered
        expect(x).to have_received(:after_run_method).ordered
      end
    end

    describe '#after_successful_run' do
      it 'does not run on failure' do
        x = spy
        outcome = test_class.run(x: x, with_execute_error: true)

        expect(outcome).to be_invalid
        expect(x).to_not have_received(:after_successful_run)
      end

      it 'runs on success' do
        x = spy
        outcome = test_class.run(x: x)

        expect(outcome).to be_valid
        expect(x).to have_received(:after_successful_run)
      end
    end

    describe '#after_failed_run' do
      it 'runs on failure' do
        x = spy
        outcome = test_class.run(x: x, with_execute_error: true)

        expect(outcome).to be_invalid
        expect(x).to have_received(:after_failed_run)
      end

      it 'does not run on success' do
        x = spy
        outcome = test_class.run(x: x)

        expect(outcome).to be_valid
        expect(x).to_not have_received(:after_failed_run)
      end
    end
  end
end

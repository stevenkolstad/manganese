require 'spec_helper'

describe Manganese do
  shared_examples 'default behavior' do
    let(:default_database_name) { 'manganese_test' }

    describe '.default_db' do
      context 'without an active tenant' do
        it 'should match the initial configured db' do
          expect(Manganese.default_db).to be_eql default_database_name
        end
      end

      context 'with an active tenant' do
        let(:company) { create :company }

        before :each do
          company.switch_db
        end

        it 'should match the initial configured db' do
          expect(Manganese.default_db).to be_eql 'manganese_test'
        end
      end
    end

    describe '.current_tenant=' do
      let(:company)         { create :company }
      let(:another_company) { create :company }
      let(:database_name)         { "manganese_test_#{company.id}" }
      let(:another_database_name) { "manganese_test_#{another_company.id}" }

      context 'when assign a first tenant' do
        before :each do
          Manganese.current_tenant = database_name
        end

        it 'should change the current configured' do
          expect(Manganese.current_tenant).to be_eql database_name
        end

        it 'should create data on a different db' do
          create_list :product, 10
          expect(Product.count).to be_eql 10
        end

        context 'when I switch to a secont tenant' do
          before :each do
            Manganese.current_tenant = another_database_name
          end

          it 'should not have produts ' do
            Manganese.current_tenant = another_database_name
            expect(Product.count).to be_eql 0
          end

          it 'should create data only for this tenant' do
            create_list :product, 20
            expect(Product.count).to be_eql 20
          end
        end
      end
    end

    describe '.current_tenant' do
      context 'without active tenants' do
        it 'should be match the initial configured db' do
          expect(Manganese.current_tenant).to be_eql default_database_name
        end
      end

      context 'with an active tenants' do
        it 'should be match the current tenant' do
          Manganese.current_tenant = 'sample_tenant'
          expect(Manganese.current_tenant).to be_eql 'sample_tenant'
        end
      end
    end

    describe '.reset_tenant!' do
      it 'should reset a current configured tenant' do
        Manganese.current_tenant = 'sample_tenant'
        Manganese.reset_tenant!
        expect(Manganese.current_tenant).to be_eql Manganese.default_db
      end
    end
  end

  context 'testing in fake mode', manganese: :fake do
    it_behaves_like 'default behavior'
  end

  context 'testing in live mode', manganese: :live do
    it_behaves_like 'default behavior'
  end
end

require 'spec_helper'

describe Manganese do
  it "expect the truthy" do
    expect(true).to be_truthy
  end

  describe '.default_db' do
    context 'without an active tenant' do
      it 'should match the initial configured db' do
        expect(Manganese.default_db).to be_eql :manganese_test
      end
    end

    context 'with an active tenant' do
      let(:company) { create :company }

      before :each do
        company.switch_db
      end

      it 'should match the initial configured db' do
        expect(Manganese.default_db).to be_eql :manganese_test
      end
    end
  end

  describe '.current_tenant=' do

  end

  # describe '.current_tenant' do
  #   pending 'asd'
  # end
end

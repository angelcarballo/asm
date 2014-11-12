require 'spec_helper'

describe Asm::Shipment do
  let(:valid_options) {
    YAML.load_file(File.expand_path('../../support/valid_shipment_options.yml', __FILE__))
  }
  let(:valid_message) {
    File.read(File.expand_path('../../support/valid_shipment.xml', __FILE__)).lines.map(&:strip).join
  }

  it 'generates a valid template from valid options' do
    collection = Asm::Shipment.new(valid_options)
    expect(collection.send(:message)).to eq(valid_message)
  end

  it 'raises an exception if mandatory options are missing' do
    for key in Asm::Shipment::MANDATORY_KEYS
      invalid_options = valid_options.merge Hash[key, nil]
      expect{ Asm::Shipment.new(invalid_options) }.to raise_error(Asm::InvalidConfig)
    end
  end

  it 'raises an exception if service is invalid' do
    invalid_options = valid_options.merge service: :wrong_service
    expect{ Asm::Shipment.new(invalid_options) }.to raise_error(Asm::InvalidConfig)
  end

  it 'does not require mobile or email for non :euro_standar shipments' do
    options = valid_options
    options[:destination][:emai] = nil
    options[:destination][:mobile] = nil
    expect{ Asm::Shipment.new(options) }.not_to raise_error
  end

  it 'raises an exception if address has no email or mobile on :euro_standar shipments' do
    invalid_options = valid_options.merge service: :euro_standar
    invalid_options[:destination][:email] = nil
    expect{ Asm::Shipment.new(invalid_options) }.to raise_error(Asm::InvalidConfig)

    invalid_options = valid_options.merge service: :euro_standar
    invalid_options[:destination][:mobile] = nil
    expect{ Asm::Shipment.new(invalid_options) }.to raise_error(Asm::InvalidConfig)
  end

end

require 'Asm'
require 'yaml'

describe Asm::Shipment do

  it 'generates a valid template' do
    valid_options = YAML.load_file(File.expand_path('../../support/valid_shipment.xml', __FILE__))
    valid_message = File.read(
      File.expand_path('../../support/valid_shipment.xml', __FILE__)
    ).lines.map(&:strip).join
    debugger

    collection = Asm::Shipment.new(valid_options)

    expect(collection.message).to eq(valid_message)
  end

end

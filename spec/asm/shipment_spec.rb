require 'Asm'

describe Asm::Shipment do

  it 'generates a valid template' do
    valid_message = File.read(File.expand_path('../../valid_message.xml', __FILE__))
    valid_message = valid_message.lines.map(&:strip).join

    collection = Asm::Shipment.new(
      client_uid: '123456789',
      date: Date.parse('12/07/2014'),
      reference_number: '11223344556677889900',
      reimbursement_cents: 1745,
      origin: {
        name: 'Origin Name',
        address: 'Origin Address',
        city: 'Origin City',
        state: 'Origin State',
        country_code: '28',
        zipcode: '28000',
        phone: '915555555',
        mobile: '666666666',
        email: 'origin@example.com',
        observations: 'Origin Observations'
      },
      destination: {
        name: 'Destination Name',
        address: 'Destination Address',
        city: 'Destination City',
        state: 'Destination State',
        country_code: '28',
        zipcode: '28001',
        phone: '914444444',
        mobile: '666777888',
        email: 'destination@example.com',
        observations: 'Destination Observations'
      },
    )

    expect(collection.message).to eq(valid_message)
  end

end

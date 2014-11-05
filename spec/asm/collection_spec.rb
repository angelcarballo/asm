require 'Asm'

describe Asm::Collection do

  it 'generates a valid template' do
    valid_message = File.read(File.expand_path('../../valid_message.xml', __FILE__))

    collection = Asm::Collection.new(
      client_uid: '123456789',
      date: Date.parse('12/07/2014'),
      time_from: '10:00',
      time_to: '14:00',
      reference_number: '11223344556677889900',
      name: 'Nombre',
      address: 'Direccion',
      city: 'Ciudad',
      state: 'Provincia',
      country_code: '28',
      zipcode: '28000',
      phone: '915555555',
      mobile: '666666666',
      email: 'test@example.com'
    )

    expect(collection.message).to eq(valid_message)
  end

end

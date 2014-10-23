require 'Asm'

describe Asm::Collection do

  it 'generates a valid template' do
    valid_template = <<-EOS
<?xml version="1.0" encoding="utf-8"?>
<Servicios uidcliente="123456789">
  <Recogida codrecogida="">
    <Horarios>
      <Fecha dia="12/07/2014">
        <Horario desde="10:00" hasta="14:00" />
      </Fecha>
    </Horarios>
    <RecogerEn>
      <Nombre>Nombre</Nombre>
      <Direccion>Direccion</Direccion>
      <Poblacion>Ciudad</Poblacion>
      <Provincia>Provincia</Provincia>
      <Pais>28</Pais>
      <CP>28000</CP>
      <Telefono>915555555</Telefono>
      <Movil>666666666</Movil>
      <Email>test@example.com</Email>
    </RecogerEn>
    <Referencias>
      <Referencia tipo="C">11223344556677889900</Referencia>
    </Referencias>
  </Recogida>
</Servicios>
    EOS

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

    expect(collection.xml_message).to eq(valid_template)
  end

end

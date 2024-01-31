require 'rails_helper'

RSpec.describe Serialization, type: :class do
  context 'class methods' do
    describe '::sign' do
      it 'sign properly' do
        message = 'message'
        pub_key = '8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D3115'
        priv_key = 'BDD78008B47053B24B418FFB31E9F3EAE6F98A4226D2DF6CE51E6EB0D46DEB52'
        result = Serialization.sign(priv_key, pub_key, message)
        rresult = [result].pack('B*').unpack1('H*')
        expect(rresult.upcase).to eq '52A604AC3DC10BC684F4D3817C431226429346BEDB76222D57FB0BB1790B328A5E5A5D7AC26DA8434D44FA60794CE1CFF73DDFB61F6088B62EC92243DDF07D0C'
      end
    end

    describe '::serialize' do
      it 'create encrypte string with signature_mode == false' do
        pub_key = 'ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D3115'
        txn = 'C1A0397802E552F4742C91EA316DEB05F85D9D47C7D45A0A2FC3B29874C46B2D3D0E1C1779330B3DE2112289ADC9E1373BEA37B67C91FD653149FD349F76DC07'
        data = { 'Account' => AddressEncoder.to_account_id('rEX5oz43exnmJZjjfaVifNy3rqAnuMjFE7'),
                 'Amount' => 5_000_000,
                 'Destination' => AddressEncoder.to_account_id('rDMTLGgdYwuCpP385LayLfmB1aknd5LVa'),
                 'Fee' => 10_000,
                 'LastLedgerSequence' => 44_572_209,
                 'Sequence' => 44_051_664,
                 'SigningPubKey' => pub_key,
                 'TxnSignature' => txn,
                 'TransactionType' => 'Payment' }
        serialize = Serialization.serialize(data, false)
        x = [serialize].pack('B*').unpack1('H*')
        result = '1200002402A02CD0201B02A81E316140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D31157440C1A0397802E552F4742C91EA316DEB05F85D9D47C7D45A0A2FC3B29874C46B2D3D0E1C1779330B3DE2112289ADC9E1373BEA37B67C91FD653149FD349F76DC0781149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489'

        expect(x.upcase).to eq result
      end
      it 'create encrypte string with signature_mode == true' do
        pub_key = 'ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D3115'
        txn = 'C1A0397802E552F4742C91EA316DEB05F85D9D47C7D45A0A2FC3B29874C46B2D3D0E1C1779330B3DE2112289ADC9E1373BEA37B67C91FD653149FD349F76DC07'
        data = { 'Account' => AddressEncoder.to_account_id('rEX5oz43exnmJZjjfaVifNy3rqAnuMjFE7'),
                 'Amount' => 5_000_000,
                 'Destination' => AddressEncoder.to_account_id('rDMTLGgdYwuCpP385LayLfmB1aknd5LVa'),
                 'Fee' => 10_000,
                 'LastLedgerSequence' => 44_572_209,
                 'Sequence' => 44_051_664,
                 'SigningPubKey' => pub_key,
                 'TxnSignature' => txn,
                 'TransactionType' => 'Payment' }
        serialize = Serialization.serialize(data, true)
        result = '1200002402A02CD0201B02A81E316140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D311581149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489'
        x = [serialize].pack('B*').unpack1('H*')

        expect(x.upcase).to eq result
      end
    end
  end
end

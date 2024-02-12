require 'rails_helper'

RSpec.describe Serialization, type: :class do
  context 'class methods' do
    describe '::sign' do
      it 'sign properly' do
        message = 'message'
        pub_key = '8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D3115'
        priv_key = 'BDD78008B47053B24B418FFB31E9F3EAE6F98A4226D2DF6CE51E6EB0D46DEB52'
        result = Serialization.sign(priv_key, message)
        expect(result.upcase).to eq "52A604AC3DC10BC684F4D3817C431226429346BEDB76222D57FB0BB1790B328A5E5A5D7AC26DA8434D44FA60794CE1CFF73DDFB61F6088B62EC92243DDF07D0C"
      end
    end

    describe "integration test" do
      it "serialize all 3 steps properly" do
        pub_key = 'ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D3115'
        data = { 'Account' => AddressEncoder.to_account_id('rEX5oz43exnmJZjjfaVifNy3rqAnuMjFE7'),
                 'Amount' => 5_000_000,
                 'Destination' => AddressEncoder.to_account_id('rDMTLGgdYwuCpP385LayLfmB1aknd5LVa'),
                 'Fee' => 10_000,
                 'LastLedgerSequence' => 45_041_308,
                 'Sequence' => 44_051_683,
                 'SigningPubKey' => pub_key,
                 'TransactionType' => 'Payment' }

        # 1.prepate signature
        expected_result =
          "1200002402A02CE3201B02AF469C6140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D311581149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"

        prep_signature = Serialization.serialize(data, true)
        result = [prep_signature].pack('B*').unpack1('H*').upcase
        expect(result).to eq expected_result

        # 2.sign
        priv_key = "BDD78008B47053B24B418FFB31E9F3EAE6F98A4226D2DF6CE51E6EB0D46DEB52"
        expected_result =
          "9FDFCB90A9CD98E8E24C5368E085E47795C6C8D7E58E43CAB333BC7DD73B4888981CC1C36D2E4E34FC2289D8AA199B9EBA78DE7CC686AB87855E488EF040640A"

        single_sign_code_bytes = ['53545800'].pack("H*")
        prep_signature_bytes = [prep_signature].pack('B*') 
        signature = Serialization.sign(priv_key, single_sign_code_bytes + prep_signature_bytes)
        expect(signature).to eq expected_result

        # 3.serialize with signature
        upd_data = data.merge({'TxnSignature' => signature})
        expected_result =
          "1200002402A02CE3201B02AF469C6140000000004C4B406840000000000027107321ED8F6699A6F9529185671ACCBF283A7536D5782748A50DC2D79FDF4997213D311574409FDFCB90A9CD98E8E24C5368E085E47795C6C8D7E58E43CAB333BC7DD73B4888981CC1C36D2E4E34FC2289D8AA199B9EBA78DE7CC686AB87855E488EF040640A81149F612424D5DF9351F9872176B50DD3C78DE50A958314025610D0B151DCFD648EF2B0BD06D730F3FCA489"

        result = Serialization.serialize(upd_data)
        rresult = [result].pack('B*').unpack1('H*').upcase
        expect(rresult).to eq expected_result
      end
    end
  end
end

# MagentoClient

A Ruby interface to Magento's REST API

The main feature is automatic OAuth handshake with Magento - the OAuth access token is automatically fetched, so automated scripts can use Magento's REST API without needing any manual steps

## Usage

```
magento = MagentoClient.new({
	:url => 'http://my_magento_store.com',
	:key => 'OAuth Consumer Key',
	:secret => 'OAuth Consumer Secret',
	:username => 'Magento Admin username',
	:password => 'Magento Admin password',
	:store_code => 'en' # Used for Magento stores with multiple store views on the same domain.
})

products = magento.get('/api/rest/products')

puts "Fetched #{products.count} products"
```

module ProductsHelper

	PRODUCT_XML_PATH = "data/xml/products/"
	PRODUCT_XSL_PATH = "data/xsl/product.xslt"
	
	def load_xml(path)	
		require 'nokogiri'
	
		f = File.open( PRODUCT_XML_PATH + path)
		doc = Nokogiri::XML(f)
		xslt  = Nokogiri::XSLT(File.read(PRODUCT_XSL_PATH))
		f.close
		
		xslt.transform(doc)
	end
end

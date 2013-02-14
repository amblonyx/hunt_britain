module XMLHandler

	def load_xml(path)	
		require 'nokogiri'
	
		f = File.open( XML_PATH + "products/" + path)
		doc = Nokogiri::XML(f)
		xslt  = Nokogiri::XSLT(File.read(XSL_PATH + "product.xslt"))
		f.close
		
		xslt.transform(doc)
	end
end

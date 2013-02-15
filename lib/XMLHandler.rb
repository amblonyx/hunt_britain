module XMLHandler
	require 'nokogiri'

	def load_xml(path)	
	
		f = File.open( XML_PATH + "products/" + path)
		doc = Nokogiri::XML(f)
		xslt  = Nokogiri::XSLT(File.read(XSL_PATH + "product.xslt"))
		f.close
		
		xslt.transform(doc)
	end
	
	def transform_xml(model, xml)
	
		f = File.open( XML_PATH + "#{model}s/" + xml)
		doc = Nokogiri::XML(f)
		xslt  = Nokogiri::XSLT(File.read(XSL_PATH + "#{model}.xslt"))
		f.close
		
		xslt.transform(doc)
	
	end
	
end

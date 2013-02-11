module LocationsHelper
	LOCATION_XML_PATH = "data/xml/locations/"
	LOCATION_XSL_PATH = "data/xsl/location.xslt"
	
	def load_xml(path)	
		require 'nokogiri'
	
		f = File.open( LOCATION_XML_PATH + path)
		doc = Nokogiri::XML(f)
		xslt  = Nokogiri::XSLT(File.read(LOCATION_XSL_PATH))
		f.close
		
		xslt.transform(doc)
	end
end

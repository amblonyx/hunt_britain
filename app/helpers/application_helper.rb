module ApplicationHelper
	require 'nokogiri'

	def load_xml(model, xml)	
		if model.blank?
			f = File.open( XML_PATH + xml)
		else
			f = File.open( XML_PATH + "#{model}s/" + xml)
		end
		doc = Nokogiri::XML(f)
		f.close
		doc
	end

	def get_xml_node(model, xml, xpath)
		doc = load_xml(model, xml)
		node = doc.xpath(xpath)
		node
	end
	
	def transform_xml(model, xml)
		
		doc = load_xml(model, xml)
		xslt  = Nokogiri::XSLT(File.read(XSL_PATH + "#{model}.xslt"))
		
		xslt.transform(doc)
	
	end
end

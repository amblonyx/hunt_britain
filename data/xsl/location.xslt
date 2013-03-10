<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>

<xsl:template match="/location">
	<div class="well">
		  <xsl:for-each select="tab">		
				<section>
				  <h3><xsl:value-of select="label"/></h3>
				  <xsl:value-of select="content"/>
				</section>
		  </xsl:for-each>		  
	  </div>
</xsl:template>

</xsl:stylesheet>
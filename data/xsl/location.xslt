<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>

<xsl:template match="/location">
      <xsl:for-each select="tab">		
          <h2><xsl:value-of select="label"/></h2>
          <xsl:value-of select="content"/>
      </xsl:for-each>
</xsl:template>

</xsl:stylesheet>